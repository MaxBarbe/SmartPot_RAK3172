param(
  [string]$Archive=(Join-Path $PSScriptRoot '..\..\pot_fleur_v3_provisoire_4couches\CST_import\SmartPot_V3_CST_ODB.zip'),
  [string]$OutputDirectory=(Join-Path $PSScriptRoot 'reconstruction_cst'),
  [switch]$Run
)
$ErrorActionPreference='Stop'
$culture=[Globalization.CultureInfo]::InvariantCulture
function N($x) { ([double]$x).ToString('0.#########',$culture) }
function D($x) { [double]::Parse($x,$culture) }
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip=[IO.Compression.ZipFile]::OpenRead($Archive)
function ReadEntry($name) {
  $entry=$zip.GetEntry($name)
  if(!$entry){throw "Missing archive entry: $name"}
  $reader=[IO.StreamReader]::new($entry.Open())
  try {$reader.ReadToEnd()} finally {$reader.Dispose()}
}
$features=ReadEntry 'steps/pcb/layers/f.cu/features'
$eda=ReadEntry 'steps/pcb/eda/data'
$profile=ReadEntry 'steps/pcb/profile'
$symbols=@{}
$records=[Collections.Generic.List[string]]::new()
foreach($line in ($features -split "`n")) {
  if($line -match '^\$(\d+) (.+)$') {$symbols[[int]$Matches[1]]=$Matches[2].Trim()}
  if($line -match '^(P|L|A|S) ') {$records.Add($line.Trim())}
}
# ODB feature indices count surface records once, not their contour records.
$net='';$selected=[Collections.Generic.HashSet[int]]::new()
foreach($line in ($eda -split "`n")) {
  if($line -match '^NET (\S+)') {$net=$Matches[1]}
  if(($net -match '^/Microcontroleur/RF_' -or $net -eq 'Net-(A1-VIN)') -and $line -match '^FID C 3 (\d+)') {[void]$selected.Add([int]$Matches[1])}
}
if($selected.Count -lt 15){throw 'RF net selection unexpectedly small'}
if($profile -notmatch '80\.0 -110\.0' -or $profile -notmatch '50\.0 -50\.0'){throw 'Unexpected board profile'}
$zip.Dispose()
New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
$destination=Join-Path $OutputDirectory 'SmartPot_V3_ODB_REDUIT.cst'
if(Test-Path -LiteralPath $destination){throw "Refusing to overwrite $destination"}
$app=New-Object -ComObject CSTStudio.Application
$model=$app.NewMWS()
function Hist($title,$code) {
  if(!$model.AddToHistory($title,$code)){throw "CST rejected: $title"}
}
function Brick($name,$component,$material,$x0,$x1,$y0,$y1,$z0,$z1) {
  Hist "Create $component/$name" @"
With Brick
 .Reset
 .Name "$name"
 .Component "$component"
 .Material "$material"
 .Xrange "$(N $x0)", "$(N $x1)"
 .Yrange "$(N $y0)", "$(N $y1)"
 .Zrange "$(N $z0)", "$(N $z1)"
 .Create
End With
"@
}
Hist 'Units and frequency' @'
With Units
 .Geometry "mm"
 .Frequency "GHz"
 .Time "ns"
End With
Solver.FrequencyRange "0.7", "1.0"
ChangeSolverType "HF Time Domain"
'@
Hist 'Provisional FR4 and copper' @'
With Material
 .Reset
 .Name "FR4_PROVISOIRE"
 .Type "Normal"
 .Epsilon "4.3"
 .Mue "1"
 .TanD "0.02"
 .TanDFreq "0.868"
 .TanDGiven "True"
 .Colour "0.2", "0.5", "0.2"
 .Create
End With
With Material
 .Reset
 .Name "Cuivre"
 .Type "Lossy metal"
 .Kappa "5.8e7"
 .Mue "1"
 .Colour "1", "0.6", "0.2"
 .Create
End With
'@
# Native ODB XY retained. Z stackup is taken from the accompanying KiCad export notes.
Brick 'FR4_bas' 'Substrat' 'FR4_PROVISOIRE' 50 80 -110 -50 0.035 0.162
Brick 'FR4_coeur' 'Substrat' 'FR4_PROVISOIRE' 50 80 -110 -50 0.197 0.603
Brick 'FR4_haut' 'Substrat' 'FR4_PROVISOIRE' 50 80 -110 -50 0.638 0.765
$planes=@(@('B',0,0.035),@('In2',0.162,0.197),@('In1',0.603,0.638),@('F',0.765,0.8))
foreach($p in $planes) {Brick "GND_$($p[0])" 'Masse_simplifiee' 'Cuivre' 50 80 -110 -60.5 $p[1] $p[2]}
Brick 'FR4_keepout_in2' 'Substrat' 'FR4_PROVISOIRE' 50 80 -60.5 -50 0.162 0.197
Brick 'FR4_keepout_in1' 'Substrat' 'FR4_PROVISOIRE' 50 80 -60.5 -50 0.603 0.638
$manifest=[Collections.Generic.List[object]]::new()
function Poly($name,$component,$points,$z,$height,$material='Cuivre') {
  $code="With Extrude`n.Reset`n.Name ""$name""`n.Component ""$component""`n.Material ""$material""`n.Mode ""Pointlist""`n.Height ""$(N $height)""`n.Twist ""0""`n.Taper ""0""`n.Origin ""0"", ""0"", ""$(N $z)""`n.Uvector ""1"", ""0"", ""0""`n.Vvector ""0"", ""1"", ""0""`n"
  $first=$true
  foreach($pt in $points) {
    $cmd=if($first){'.Point'}else{'.LineTo'};$first=$false
    $code+="$cmd ""$(N $pt[0])"", ""$(N $pt[1])""`n"
  }
  $code+=".LineTo ""$(N $points[0][0])"", ""$(N $points[0][1])""`n.Create`nEnd With"
  Hist "Create $component/$name" $code
}
function MakeFeature($id,$clearance=0,$component='RF',$name='') {
  $fields=($records[$id] -split ';')[0] -split '\s+'
  if(!$name){$name="odb_$id"}
  if($fields[0] -eq 'P') {
    $x=D $fields[1];$y=D $fields[2];$symbol=$symbols[[int]$fields[3]]
    if($fields[4] -ne 'P' -or $fields[6] -ne '8'){throw "Unsupported pad orientation/polarity: $($records[$id])"}
    $angle=(D $fields[7])*[Math]::PI/180
    if($symbol -notmatch '^rect([\d.]+)x([\d.]+)(?:xr([\d.]+))?$'){throw "Unsupported RF pad $symbol"}
    $w=(D $Matches[1])/1000+2*$clearance;$h=(D $Matches[2])/1000+2*$clearance
    # Rounded pads are approximated by their bounding rectangle; documented.
    $pts=@(@((-$w/2),(-$h/2)),@(($w/2),(-$h/2)),@(($w/2),($h/2)),@((-$w/2),($h/2)))
    $transformed=@(foreach($pt in $pts){ ,@(($x+$pt[0]*[Math]::Cos($angle)-$pt[1]*[Math]::Sin($angle)),($y+$pt[0]*[Math]::Sin($angle)+$pt[1]*[Math]::Cos($angle))) })
    Poly $name $component $transformed 0.765 0.035
  } elseif($fields[0] -eq 'L') {
    $x0=D $fields[1];$y0=D $fields[2];$x1=D $fields[3];$y1=D $fields[4]
    $symbol=$symbols[[int]$fields[5]]
    if($symbol -notmatch '^r([\d.]+)$'){throw "Unsupported RF trace symbol $symbol"}
    $w=(D $Matches[1])/1000+2*$clearance
    $len=[Math]::Sqrt(($x1-$x0)*($x1-$x0)+($y1-$y0)*($y1-$y0))
    $dx=($x1-$x0)/$len;$dy=($y1-$y0)/$len
    # Square-ended trace prism. Adjacent trace/pad overlap preserves continuity.
    $pts=@(@(($x0-$dx*$w/2-$dy*$w/2),($y0-$dy*$w/2+$dx*$w/2)),@(($x1+$dx*$w/2-$dy*$w/2),($y1+$dy*$w/2+$dx*$w/2)),@(($x1+$dx*$w/2+$dy*$w/2),($y1+$dy*$w/2-$dx*$w/2)),@(($x0-$dx*$w/2+$dy*$w/2),($y0-$dy*$w/2-$dx*$w/2)))
    Poly $name $component $pts 0.765 0.035
  } else {throw "Unsupported RF feature $($fields[0])"}
}
foreach($id in ($selected | Sort-Object)) {
  MakeFeature $id
  $manifest.Add(@{feature=$id;record=$records[$id]})
  # Synthetic coplanar clearance around feed-network features only.
  # Do not clear around the IFA branch, which intentionally shorts to top GND.
  $f=($records[$id] -split '\s+')
  $y=D $f[2]
  if($y -lt -60.5) {
    MakeFeature $id 0.25 'Degagement' "cut_$id"
    Hist "Clearance top ground $id" "Solid.Subtract ""Masse_simplifiee:GND_F"", ""Degagement:cut_$id"""
  }
}
Brick 'notch_A1_feed' 'Degagement' 'Cuivre' 51.59 52.5 -62 -60.49 0.765 0.8
Hist 'Isolate physical IFA feed' 'Solid.Subtract "Masse_simplifiee:GND_F", "Degagement:notch_A1_feed"'
# R4/R6 populated zero-ohm approximations, no bridges on C6/L1/J3.
Brick 'clear_R4' 'Degagement' 'Cuivre' 54.425 56.575 -70.3 -69.3 0.765 0.8
Hist 'R4 bridge clearance' 'Solid.Subtract "Masse_simplifiee:GND_F", "Degagement:clear_R4"'
Brick 'clear_R6' 'Degagement' 'Cuivre' 52.925 55.075 -63.8 -62.8 0.765 0.8
Hist 'R6 bridge clearance' 'Solid.Subtract "Masse_simplifiee:GND_F", "Degagement:clear_R6"'
Brick 'R4_0ohm' 'Ponts_ideaux' 'Cuivre' 54.675 56.325 -70.05 -69.55 0.765 0.8
Brick 'R6_0ohm' 'Ponts_ideaux' 'Cuivre' 53.175 54.825 -63.55 -63.05 0.765 0.8
# The archive's A1 ground pad joins the IFA branch to the simplified top plane.
Brick 'A1_court_circuit' 'RF' 'Cuivre' 50.5 51.546391 -61.8 -60.3 0.765 0.8
# Four idealised ground stitching posts. All other vias/holes are omitted.
foreach($xy in @(@(51,-65),@(79,-65),@(51,-108),@(79,-108))) {
  $name="liaison_$($xy[0])_$(-$xy[1])"
  Brick $name 'Masse_simplifiee' 'Cuivre' ($xy[0]-0.15) ($xy[0]+0.15) ($xy[1]-0.15) ($xy[1]+0.15) 0 0.8
}
Hist 'Air and open boundaries' @'
With Background
 .Type "Normal"
 .Epsilon "1"
 .Mu "1"
End With
With Boundary
 .Xmin "expanded open"
 .Xmax "expanded open"
 .Ymin "expanded open"
 .Ymax "expanded open"
 .Zmin "expanded open"
 .Zmax "expanded open"
End With
'@
Hist '50 ohm port U1.12 to In1' @'
With DiscretePort
 .Reset
 .PortNumber "1"
 .Type "SParameter"
 .Impedance "50"
 .SetP1 "False", "57.925", "-71.965", "0.765"
 .SetP2 "False", "57.925", "-71.965", "0.638"
 .InvertDirection "False"
 .LocalCoordinates "False"
 .Create
End With
'@
Hist 'Farfield at 868 MHz' @'
With Monitor
 .Reset
 .Name "farfield (f=0.868)"
 .Dimension "Volume"
 .Domain "Frequency"
 .FieldType "Farfield"
 .Frequency "0.868"
 .Create
End With
'@
Hist 'Preliminary mesh for Learning Edition' @'
With MeshSettings
 .SetMeshType "Hex"
 .Set "Version", 1
 .Set "StepsPerWaveNear", "6"
 .Set "StepsPerWaveFar", "3"
 .Set "StepsPerBoxNear", "6"
 .Set "StepsPerBoxFar", "3"
 .Set "WavelengthRefinementSameAsNear", "0"
 .Set "GeometryRefinementSameAsNear", "0"
End With
'@
$model.SaveAs($destination,$true)
@{archive=$Archive;archive_sha256=(Get-FileHash -LiteralPath $Archive -Algorithm SHA256).Hash;project=$destination;selected_rf_features=@($manifest);status='created_not_simulated';model='REDUCED - not full V3';assumptions=@('RF nets extracted by FID from ODB++ EDA data','four solid rectangular ground planes; synthetic 0.25 mm top clearances','FR4 er4.3 tanD0.02 and 0.8 mm stackup provisional','rounded RF pads approximated by bounding rectangles; square-ended traces','R4 R6 ideal bridges; no populated C6/L1/J3','four ideal ground posts; other vias, holes, copper, components and soldermask omitted')} | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath (Join-Path $OutputDirectory 'modele_et_limites.json') -Encoding utf8
Write-Output "Created $destination"
if($Run){$solver=$model.Solver();$result=$solver.Start();Write-Output "Solver return: $result";$model.Save()}
