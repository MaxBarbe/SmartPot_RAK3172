"""Lossless format conversion of the native CST complex S11 exports."""
import hashlib,json,sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from analyze_rf_fd import read_curve
p=Path(sys.argv[1]);real_file=Path(str(p)+'_S11_real.txt');imag_file=Path(str(p)+'_S11_imaginary.txt')
r=read_curve(real_file);im=read_curve(imag_file)
if len(r)!=len(im) or not r or any(abs(f-fi)>1e-9 for (f,_),(fi,_) in zip(r,im)):
    raise ValueError('Mismatched native complex grids')
comparison=Path(__file__).with_name('mesh_comparison.json')
stable=False
if comparison.exists():
    c=json.loads(comparison.read_text())
    stable=bool(c.get('converged')) and c['models'][-1]['model']==p.name
quality='Numerical mesh stability confirmed in accompanying report; materials remain provisional.' if stable else 'PRELIMINARY: numerical mesh convergence has NOT been confirmed.'
lines=['! '+p.name,'! Simulated CST 2019 data; not a VNA measurement.',
       '! Port 1: U1.12 RF pad to In1.Cu GND, reference impedance 50 ohm.',
       '! '+quality,'! Converted from native real/imaginary ASCII exports without fitting.',
       '# GHz S RI R 50']
lines += [f'{f:.12g} {x:.12g} {y:.12g}' for (f,x),(_,y) in zip(r,im)]
out=Path(str(p)+'.s1p');out.write_text('\n'.join(lines)+'\n',encoding='ascii')
back=[list(map(float,line.split())) for line in lines if line and line[0] not in '!#']
error=max(abs(complex(x,y)-complex(row[1],row[2])) for ((f,x),(_,y)),row in zip(zip(r,im),back))
if error>1e-10:raise ValueError('Touchstone roundtrip changed complex data')
manifest={'touchstone':out.name,'source_native_exports':{f.name:hashlib.sha256(f.read_bytes()).hexdigest() for f in [real_file,imag_file]},
          'reference_impedance_ohm':50,'samples':len(r),'maximum_complex_roundtrip_error':error,
          'mesh_stability_confirmed_for_this_model':stable,'measured':False}
Path(str(p)+'_touchstone_provenance.json').write_text(json.dumps(manifest,indent=2))
print(json.dumps(manifest,indent=2))
