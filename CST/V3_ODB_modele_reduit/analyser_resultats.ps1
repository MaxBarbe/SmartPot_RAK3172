param([string]$Directory=$PSScriptRoot)
$ErrorActionPreference='Stop'
$c=[cultureinfo]::InvariantCulture
function ReadCurve($file) {
 @(Get-Content -LiteralPath $file | ForEach-Object {
   if($_ -match '^\s*([\d.Ee+\-]+)\s+([\d.Ee+\-]+)\s*$') {
    [pscustomobject]@{frequency_GHz=[double]::Parse($Matches[1],$c);S11_dB=[double]::Parse($Matches[2],$c)}
   }
 })
}
$a=ReadCurve (Join-Path $Directory 'S11_maillage5.txt')
$b=ReadCurve (Join-Path $Directory 'S11_maillage6_3.txt')
if($a.Count -ne 1001 -or $b.Count -ne 1001){throw 'Unexpected sample count'}
$b | Export-Csv -LiteralPath (Join-Path $Directory 'S11_preliminaire.csv') -NoTypeInformation -Encoding utf8
$at868=$b | Sort-Object {[math]::Abs($_.frequency_GHz-.868)} | Select-Object -First 1
$previous868=$a | Sort-Object {[math]::Abs($_.frequency_GHz-.868)} | Select-Object -First 1
$minimum=$b | Sort-Object S11_dB | Select-Object -First 1
$delta=0.0
for($i=0;$i -lt $a.Count;$i++) {
 if([math]::Abs($a[$i].frequency_GHz-$b[$i].frequency_GHz) -gt 1e-6){throw 'Frequency grids differ'}
 $delta=[math]::Max($delta,[math]::Abs($a[$i].S11_dB-$b[$i].S11_dB))
}
$summary=[ordered]@{
 status='solver_finished_successfully_preliminary_reduced_model'
 solver='CST 2026 Learning Edition, HF Time Domain'
 source_archive_sha256='058DA21323C9252999793997061988388D12FA4CB44B9573EB1FE389FC41E352'
 frequency_GHz=@(.7,1.0)
 sample_count=$b.Count
 mesh1_cells=93060
 mesh2_cells=92684
 mesh1_S11_868_dB=$previous868.S11_dB
 mesh2_S11_868_dB=$at868.S11_dB
 minimum_S11_dB=$minimum.S11_dB
 minimum_frequency_GHz=$minimum.frequency_GHz
 maximum_mesh_difference_dB=$delta
 samples_below_minus10dB=@($b | Where-Object S11_dB -lt -10).Count
 convergence='Not established: two constrained coarse meshes do not constitute a convergence study'
 warnings=@('First mesh: one mesh edge partially filled with PEC','Second mesh: check solver Model.log for warnings','Ground geometry is simplified; not the complete V3 PCB')
}
$summary | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $Directory 'resultats_preliminaires.json') -Encoding utf8
$manifestPath=Join-Path $Directory 'modele_et_limites.json'
$m=Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
$m.status=$summary.status
$m | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $manifestPath -Encoding utf8
$summary | ConvertTo-Json -Depth 5
