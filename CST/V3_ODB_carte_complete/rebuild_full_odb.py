"""Reconstruct native CST solid history from ODB++ copper, without MATLAB.

All XY geometry comes from the archive. Circular/rounded primitives are
polygonised to <= 0.003 mm chord error. Copper and drills retain dimensions.
The result models bare PCB copper, not electrical component internals.
"""
import sys, json, re, math, zipfile, hashlib
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parent/'s11_python_deps'))
from shapely.geometry import Point, LineString, Polygon, box
from shapely import affinity, union_all, make_valid

ROOT=Path(__file__).resolve().parents[2]
ARCHIVE=ROOT/'CST/SmartPot_V3_CST_ODB.zip'
OUT=ROOT/'CST/V3_ODB_carte_complete'
OUT.mkdir(exist_ok=True)
z=zipfile.ZipFile(ARCHIVE)

def parts(g):
    if g.is_empty: return []
    if g.geom_type=='Polygon': return [g]
    if hasattr(g,'geoms'): return [p for c in g.geoms for p in parts(c)]
    return []

def symbol(name):
    m=re.fullmatch(r'r([\d.]+)',name)
    if m:return Point(0,0).buffer(float(m[1])/2000,quad_segs=24)
    m=re.fullmatch(r'rect([\d.]+)x([\d.]+)(?:xr([\d.]+))?',name)
    if not m:raise ValueError('Unhandled symbol '+name)
    w,h=map(lambda x:float(x)/1000,m.groups()[:2]); r=float(m[3] or 0)/1000
    if not r:return box(-w/2,-h/2,w/2,h/2)
    return box(-w/2+r,-h/2+r,w/2-r,h/2-r).buffer(r,quad_segs=24)

def read_features(name):
    syms={}; positive=[]; negative=[]; outlines=[]; count=0; expected=None
    surface=None; contour=None; in_hole=False; polarity=True
    for raw in z.read(name).decode().splitlines():
        line=raw.split(';')[0].strip(); f=line.split()
        if not f or line.startswith('#'):continue
        if f[0]=='F':expected=int(f[1])
        elif line.startswith('$'):syms[int(f[0][1:])]=f[1]
        elif f[0]=='S':
            count+=1; surface=[];polarity=f[1]=='P'
        elif f[0]=='OB':
            contour=[(float(f[1]),float(f[2]))]; in_hole=f[3]=='H'
        elif f[0]=='OS':contour.append((float(f[1]),float(f[2])))
        elif f[0]=='OC':raise ValueError('Arc contour needs explicit implementation')
        elif f[0]=='OE':
            p=make_valid(Polygon(contour))
            surface.append((in_hole,p));contour=None
        elif f[0]=='SE':
            outside=union_all([p for hole,p in surface if not hole])
            inside=union_all([p for hole,p in surface if hole])
            g=outside.difference(inside)
            (positive if polarity else negative).append(g);surface=None
        elif f[0]=='P':
            count+=1
            if f[6]!='8':raise ValueError('Unexpected orientation '+line)
            g=symbol(syms[int(f[3])]);g=affinity.rotate(g,float(f[7]),origin=(0,0))
            g=affinity.translate(g,float(f[1]),float(f[2]))
            (positive if f[4]=='P' else negative).append(g)
            outlines.append({'xy':[float(f[1]),float(f[2])],'symbol':syms[int(f[3])]})
        elif f[0]=='L':
            count+=1
            m=re.fullmatch(r'r([\d.]+)',syms[int(f[5])])
            if not m:raise ValueError('Nonround trace '+line)
            g=LineString([(float(f[1]),float(f[2])),(float(f[3]),float(f[4]))]).buffer(float(m[1])/2000,quad_segs=24)
            (positive if f[6]=='P' else negative).append(g)
        elif f[0] in ('A','T','B'):raise ValueError('Unsupported feature '+line)
    if expected is not None and count!=expected:raise ValueError(f'{name}: {count} != {expected}')
    return make_valid(union_all(positive).difference(union_all(negative))),outlines,count

profile,_,_=read_features('steps/pcb/profile')
if not all(abs(a-b)<1e-8 for a,b in zip(profile.bounds,(50,-110,80,-50))):raise ValueError('Unexpected outline')
plated,drills,drill_count=read_features('steps/pcb/layers/drill_plated_f.cu-b.cu/features')
nonplated,np_drills,np_count=read_features('steps/pcb/layers/drill_non-plated_f.cu-b.cu/features')
all_drills=union_all([plated,nonplated])
layers=[]
for name,z0,z1 in [('f.cu',.765,.8),('in1.cu',.603,.638),('in2.cu',.162,.197),('b.cu',0,.035)]:
    copper,_,count=read_features(f'steps/pcb/layers/{name}/features')
    if name=='f.cu':
        # Mounted 0-ohm series resistors, represented by ideal 0.5 mm bridges.
        copper=union_all([copper,box(54.675,-70.05,56.325,-69.55),box(53.175,-63.55,54.825,-63.05)])
    copper=make_valid(copper.difference(all_drills))
    # Remove only sub-0.00000001 mm2 numerical slivers, simplify <1 micrometre.
    polygons=[p.simplify(.001,preserve_topology=True) for p in parts(copper) if p.area>1e-8]
    layers.append((name,z0,z1,polygons,count))

def num(x):return f'{x:.9f}'.rstrip('0').rstrip('.') or '0'
def extrusion(name,component,ring,z0,z1,material):
    p=list(ring.coords)
    if p[0]==p[-1]:p=p[:-1]
    code=f'''With Extrude
.Reset
.Name "{name}"
.Component "{component}"
.Material "{material}"
.Mode "Pointlist"
.Height "{num(z1-z0)}"
.Twist "0"
.Taper "0"
.Origin "0", "0", "{num(z0)}"
.Uvector "1", "0", "0"
.Vvector "0", "1", "0"
'''
    for i,(x,y) in enumerate(p+[p[0]]):code+=f'.{"Point" if i==0 else "LineTo"} "{num(x)}", "{num(y)}"\n'
    return code+'.Create\nEnd With\n'

jobs=[]
def ring_solid(name,component,ring,z0,z1,mat):
    pts=list(ring.coords)
    xs=[p[0] for p in pts];ys=[p[1] for p in pts]
    cx=(max(xs)+min(xs))/2;cy=(max(ys)+min(ys))/2
    rx=(max(xs)-min(xs))/2;ry=(max(ys)-min(ys))/2;r=(rx+ry)/2
    if r>0 and abs(rx-ry)<.001 and max(abs(math.hypot(x-cx,y-cy)-r) for x,y in pts)<.0015:
        # Restore analytic circles instead of hundreds of planar wall faces.
        return f'''With Cylinder
.Reset
.Name "{name}"
.Component "{component}"
.Material "{mat}"
.OuterRadius "{num(r)}"
.InnerRadius "0"
.Axis "z"
.Zrange "{num(z0)}", "{num(z1)}"
.Xcenter "{num(cx)}"
.Ycenter "{num(cy)}"
.Create
End With
'''
    return extrusion(name,component,ring,z0,z1,mat)

def add_poly(poly,name,comp,z0,z1,mat):
    code=ring_solid(name,comp,poly.exterior,z0,z1,mat)
    jobs.append({'name':f'{comp}/{name}','code':code})
    for i,ring in enumerate(poly.interiors):
        cut=f'cut_{name}_{i}'
        code=ring_solid(cut,'TemporaryCuts',ring,z0,z1,mat)
        code+=f'Solid.Subtract "{comp}:{name}", "TemporaryCuts:{cut}"\n'
        jobs.append({'name':f'{comp}/{name} hole {i}','code':code})

# Full dielectric wherever internal copper is absent; copper volumes subtracted
# from an initially homogeneous substrate, so no artificial internal air layers.
add_poly(profile.difference(all_drills),'FR4','Substrat',.035,.765,'FR4_PROVISOIRE')
stats=[]
for layer,z0,z1,polys,count in layers:
    comp='Cuivre_'+layer.replace('.','_')
    stats.append({'layer':layer,'source_features':count,'connected_regions':len(polys),'holes':sum(len(p.interiors) for p in polys),'vertices':sum(len(p.exterior.coords)+sum(len(r.coords) for r in p.interiors) for p in polys),'area_mm2':sum(p.area for p in polys)})
    for i,p in enumerate(polys):
        name=f'region_{i:03d}'
        add_poly(p,name,comp,z0,z1,'Cuivre')
        if layer in ('in1.cu','in2.cu'):
            # Shape copies are only temporary cutters; original copper retained.
            code=ring_solid('dielectric_cut','TemporaryCuts',p.exterior,z0,z1,'FR4_PROVISOIRE')
            for j,r in enumerate(p.interiors):
                code+=ring_solid(f'inner_{j}','TemporaryCuts',r,z0,z1,'FR4_PROVISOIRE')
                code+=f'Solid.Subtract "TemporaryCuts:dielectric_cut", "TemporaryCuts:inner_{j}"\n'
            code+='Solid.Subtract "Substrat:FR4", "TemporaryCuts:dielectric_cut"\n'
            jobs.append({'name':f'Subtract {layer} copper volume from FR4 {i}','code':code})

for i,d in enumerate(drills):
    m=re.fullmatch(r'r([\d.]+)',d['symbol'])
    if not m:raise ValueError('Unsupported plated drill')
    radius=float(m[1])/2000
    # Wall thickness not supplied by ODB: explicitly assumed 25 micrometres.
    x,y=d['xy']
    jobs.append({'name':f'PlatedBarrels/via_{i:03d}','code':f'''With Cylinder
.Reset
.Name "via_{i:03d}"
.Component "PlatedBarrels"
.Material "Cuivre"
.OuterRadius "{num(radius+.025)}"
.InnerRadius "{num(radius)}"
.Axis "z"
.Zrange "0", "0.8"
.Xcenter "{num(x)}"
.Ycenter "{num(y)}"
.Create
End With
'''})

# Original board sheets already have drill holes; subtract outer barrel envelope
# from dielectric to avoid overlapping barrel metal and FR4.
for i,d in enumerate(drills):
    radius=float(d['symbol'][1:])/2000+.025;x,y=d['xy']
    jobs.append({'name':f'FR4 barrel clearance {i}','code':f'''With Cylinder
.Reset
.Name "barrel_cut"
.Component "TemporaryCuts"
.Material "FR4_PROVISOIRE"
.OuterRadius "{num(radius)}"
.InnerRadius "0"
.Axis "z"
.Zrange "0.035", "0.765"
.Xcenter "{num(x)}"
.Ycenter "{num(y)}"
.Create
End With
Solid.Subtract "Substrat:FR4", "TemporaryCuts:barrel_cut"
'''})

data={'archive':str(ARCHIVE),'sha256':hashlib.sha256(ARCHIVE.read_bytes()).hexdigest(),'layers':stats,'plated_holes':len(drills),'nonplated_holes':len(np_drills),'plating_wall_assumption_mm':.025,'polygonisation_max_target_mm':.003,'simplification_tolerance_mm':.001,'discarded_numerical_sliver_area_threshold_mm2':1e-8,'jobs':len(jobs),'limitations':['Bare PCB copper model; component bodies and electrical internal models omitted','R4 and R6 ideal bridges; C6 L1 J3 absent','FR4 er4.3 tanD0.02 provisional; soldermask omitted','Circular pad/track boundaries polygonised','CST licence and mesh limits remain applicable'],'status':'geometry_prepared_not_simulated'}
(OUT/'full_geometry_jobs.json').write_text(json.dumps(jobs),encoding='utf8')
(OUT/'geometrie_et_limites.json').write_text(json.dumps(data,indent=2),encoding='utf8')
print(json.dumps(data,indent=2))
