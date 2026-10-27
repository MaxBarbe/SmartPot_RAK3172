param([string]$OutputDirectory=(Join-Path $PSScriptRoot 'reconstruction_cst'))
$ErrorActionPreference='Stop'
$sourceRoot=$PSScriptRoot
$root=[IO.Path]::GetFullPath($OutputDirectory)
New-Item -ItemType Directory -Path $root -Force | Out-Null
$dest=Join-Path $root 'SmartPot_V3_PCB_COMPLET.cst'
if(Test-Path -LiteralPath $dest){throw 'Output project already exists'}
$jobs=Get-Content -LiteralPath (Join-Path $sourceRoot 'full_geometry_jobs.json') -Raw | ConvertFrom-Json
$app=New-Object -ComObject CSTStudio.Application
$model=$app.NewMWS()
$app.SetQuietMode($true)
$state=[ordered]@{status='building';completed_jobs=0;total_jobs=$jobs.Count;last_job='';solver_result=$null;error=$null}
function SaveState {$state | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $root 'etat_reconstruction.json') -Encoding utf8}
try {
$setup=@'
With Units
.Geometry "mm"
.Frequency "GHz"
.Time "ns"
End With
Solver.FrequencyRange "0.7", "1"
ChangeSolverType "HF Time Domain"
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
if(!$model.AddToHistory('Materials and units',$setup)){throw 'CST rejected setup'}
SaveState
foreach($j in $jobs) {
 $state.last_job=$j.name
 SaveState
 if(!$model.AddToHistory($j.name,$j.code)){throw "CST rejected history: $($j.name)"}
 $state.completed_jobs++
 if($state.completed_jobs%10 -eq 0){SaveState;Write-Output "$($state.completed_jobs)/$($jobs.Count): $($j.name)"}
}
$simulation=@'
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
With DiscretePort
.Reset
.PortNumber "1"
.Type "SParameter"
.Impedance "50"
.SetP1 "False", "57.925", "-71.965", "0.765"
.SetP2 "False", "57.925", "-71.965", "0.638"
.LocalCoordinates "False"
.Create
End With
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
if(!$model.AddToHistory('Full PCB S11 test settings',$simulation)){throw 'CST rejected simulation setup'}
$model.SaveAs($dest,$true)
$state.status='geometry_saved_starting_solver';SaveState
$state.solver_result=($model.Solver()).Start()
$model.Save()
$state.status=if($state.solver_result -eq 1){'solver_returned_success_check_log'}else{'solver_failed_check_log'}
SaveState
Write-Output ($state | ConvertTo-Json -Depth 5)
} catch {
 $state.status='reconstruction_failed';$state.error=$_.Exception.Message
 SaveState
 try {$model.SaveAs((Join-Path $root 'SmartPot_V3_RECONSTRUCTION_INCOMPLETE.cst'),$true)}catch{}
 throw
} finally {$app.SetQuietMode($false)}
