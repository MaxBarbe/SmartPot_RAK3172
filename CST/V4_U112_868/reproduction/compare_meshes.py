"""Compare saved CST exports; never infer convergence from solver termination alone."""
import json, math, re, sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from analyze_rf_fd import read_curve
rows=[]
curves=[]
for arg in sys.argv[1:]:
    p=Path(arg)
    a=json.loads(Path(str(p)+'_analysis_td.json').read_text())
    log=(p/'Result/Model.log').read_text(errors='replace')
    if 'Steady state energy criterion met, solver finished successfully.' not in log:
        raise ValueError(f'{p.name}: native steady-state termination is not confirmed')
    radiation={}
    for line in Path(str(p)+'_radiation.txt').read_text().splitlines():
        if '=' in line:
            k,v=line.split('=',1);radiation[k]=float(v.replace(',','.'))
    gamma2=a['at_868_MHz']['S11_real']**2+a['at_868_MHz']['S11_imaginary']**2
    if not all(math.isfinite(v) for v in radiation.values()):raise ValueError('Non-finite native farfield result')
    if radiation['RADIATED_POWER_W']<=0:raise ValueError('Native radiated power is zero or unavailable')
    # The export macro explicitly selects a logarithmic CST 2019 plot.
    # Native efficiencies are dB; the gain identities below verify these units.
    er=10**(radiation['RADIATION_EFFICIENCY_NATIVE']/10)
    et=10**(radiation['TOTAL_EFFICIENCY_NATIVE']/10)
    if not (0<er<=1.001 and 0<et<=1.001):raise ValueError('Unphysical native efficiencies')
    error=abs(et-er*(1-gamma2))
    if error>.01:raise ValueError(f'Power normalization inconsistency {error}')
    if er>0 and et>0:
        d=radiation['DIRECTIVITY_MAX_DBI']
        if abs(radiation['GAIN_MAX_DBI']-d-10*math.log10(er))>.05:raise ValueError('Gain/radiation-efficiency normalization mismatch')
        if abs(radiation['REALIZED_GAIN_MAX_DB']-d-10*math.log10(et))>.05:raise ValueError('Realized gain/total-efficiency normalization mismatch')
    mesh=json.loads(Path(str(p)+'_mesh_audit.json').read_text())
    duration=re.search(r'Total simulation time:\s*(\d+)\s*s',log)
    row={'model':p.name,'cells':mesh['cells'],'port_cells_Z':mesh['port_cells_Z'],
         'native_total_simulation_time_s':int(duration[1]) if duration else None,
         'S11_868_dB':a['at_868_MHz']['S11_dB'],'minimum':a['sampled_minimum'],
         'minus10_dB_band':a['minus10_dB_band'],'radiation_efficiency_percent':100*er,
         'operating_bands_at_868_MHz':a.get('operating_bands_at_868_MHz'),
         'total_efficiency_percent':100*et,'native_efficiency_unit_verified_by_gain_identity':'dB',
         'power_balance_error':error,'realized_gain_max_dBi':radiation['REALIZED_GAIN_MAX_DB'],
         'minimum_at_band_edge':a.get('minimum_at_band_edge',a['sampled_minimum']['frequency_MHz'] in a['band_MHz']),
         'passivity_within_tolerance':a.get('passivity_within_tolerance',a['maximum_abs_gamma']<=1.001)}
    rows.append(row)
    r=read_curve(Path(str(p)+'_S11_real.txt'));im=read_curve(Path(str(p)+'_S11_imaginary.txt'))
    curves.append([(f,complex(x,y)) for (f,x),(_,y) in zip(r,im)])
report={'models':rows,'converged':False,'criteria':{'S11_868_dB':.2,'minimum_frequency_MHz':1,
    'efficiency_percentage_points':2,'efficiency_relative_change':.05,'realized_gain_dB':.2,
    'maximum_complex_gamma_difference_in_simulated_band':.02}}
if len(rows)>=2:
    a,b=rows[-2:]
    ca,cb=curves[-2:]
    if len(ca)!=len(cb) or any(abs(f-fa)>1e-8 for (f,_),(fa,_) in zip(ca,cb)):
        raise ValueError('Different frequency grids require explicit interpolation')
    differences=[abs(x-y) for (_,x),(_,y) in zip(ca,cb)]
    near=[v for (f,_),v in zip(ca,differences) if .858<=f<=.878]
    deltas={'S11_868_dB':abs(a['S11_868_dB']-b['S11_868_dB']),
        'minimum_frequency_MHz':abs(a['minimum']['frequency_MHz']-b['minimum']['frequency_MHz']),
        'radiation_efficiency_pp':abs(a['radiation_efficiency_percent']-b['radiation_efficiency_percent']),
        'total_efficiency_pp':abs(a['total_efficiency_percent']-b['total_efficiency_percent']),
        'realized_gain_dB':abs(a['realized_gain_max_dBi']-b['realized_gain_max_dBi']),
        'radiation_efficiency_relative_change':abs(a['radiation_efficiency_percent']-b['radiation_efficiency_percent'])/max(a['radiation_efficiency_percent'],b['radiation_efficiency_percent']),
        'total_efficiency_relative_change':abs(a['total_efficiency_percent']-b['total_efficiency_percent'])/max(a['total_efficiency_percent'],b['total_efficiency_percent']),
        'maximum_complex_gamma_difference':max(differences),'maximum_complex_gamma_difference_858_878_MHz':max(near)}
    report['last_mesh_deltas']=deltas
    report['converged']=(deltas['S11_868_dB']<=.2 and deltas['minimum_frequency_MHz']<=1
        and max(deltas['radiation_efficiency_pp'],deltas['total_efficiency_pp'])<=2
        and max(deltas['radiation_efficiency_relative_change'],deltas['total_efficiency_relative_change'])<=.05
        and deltas['realized_gain_dB']<=.2 and deltas['maximum_complex_gamma_difference']<=.02
        and not b['minimum_at_band_edge'] and a['passivity_within_tolerance'] and b['passivity_within_tolerance'])
    report['target_margin_to_minus14_dB']=-14-b['S11_868_dB']
    report['target_met_with_margin_over_observed_mesh_delta']=(report['converged'] and b['S11_868_dB']+deltas['S11_868_dB']<=-14)
Path(__file__).with_name('mesh_comparison.json').write_text(json.dumps(report,indent=2))
print(json.dumps(report,indent=2))
