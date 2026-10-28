import json, math, struct, sys
from pathlib import Path
p=Path(sys.argv[1]);b=(p/'Result/Model.msh').read_bytes()
if struct.unpack_from('<I',b)[0]!=20080423:raise ValueError('Unrecognized native mesh format')
n=struct.unpack_from('<3i',b,8)
if len(b)!=32+8*sum(n):raise ValueError('Unexpected mesh coordinate storage')
values=struct.unpack_from('<'+str(sum(n))+'d',b,32)
axes=[[1000*x for x in values[sum(n[:i]):sum(n[:i+1])]] for i in range(3)]
if any(any(a>=b for a,b in zip(v,v[1:])) for v in axes):raise ValueError('Non-monotonic native mesh')
port_nodes=[z for z in axes[2] if .638-1e-7<=z<=.765+1e-7]
report={'model':p.name,'nodes':n,'cells':math.prod(v-1 for v in n),
        'minimum_steps_mm':[min(b-a for a,b in zip(v,v[1:])) for v in axes],
        'board_z_nodes_mm':[z for z in axes[2] if -.01<=z<=1.01],
        'port_z_nodes_mm':port_nodes,'port_cells_Z':len(port_nodes)-1,
        'port_center_nearest_X_error_mm':min(abs(x-57.925) for x in axes[0]),
        'port_center_nearest_Y_error_mm':min(abs(y+71.965) for y in axes[1])}
Path(str(p)+'_mesh_audit.json').write_text(json.dumps(report,indent=2))
print(json.dumps(report,indent=2))
if report['cells']>1000000:raise ValueError('Teaching license cell limit')
if report['port_cells_Z']<2:raise ValueError('Port gap has fewer than two cells')
