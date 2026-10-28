"""Read native CST complex S11 exports without modifying the simulated data."""
import json
import math
import re
import sys
from pathlib import Path


def read_curve(path):
    rows = []
    for line in path.read_text(errors="replace").splitlines():
        fields = line.split()
        if len(fields) != 2:
            continue
        try:
            frequency, value = map(float, fields)
        except ValueError:
            continue
        rows.append((frequency, value))
    if not rows:
        raise ValueError(f"No numeric result in {path}")
    return rows


if __name__ == "__main__":
    prefix = Path(sys.argv[1])
    real = read_curve(Path(str(prefix) + "_S11_real.txt"))
    imag = read_curve(Path(str(prefix) + "_S11_imaginary.txt"))
    if len(real) != len(imag):
        raise ValueError("Real and imaginary exports have different sample counts")
    rows = []
    for (f, r), (fi, i) in zip(real, imag):
        if abs(f - fi) > 1e-8:
            raise ValueError("Mismatched frequency grids")
        gamma = complex(r, i)
        impedance = 50 * (1 + gamma) / (1 - gamma)
        rows.append({"frequency_GHz": f, "S11_dB": 20 * math.log10(abs(gamma)),
                     "S11_real": r, "S11_imaginary": i,
                     "Z_real_ohm": impedance.real, "Z_imaginary_ohm": impedance.imag})
    target = min(rows, key=lambda row: abs(row["frequency_GHz"] - 0.868))
    if abs(target["frequency_GHz"] - 0.868) > 1e-7:
        raise ValueError("No actual sample at 868 MHz; interpolation not used")
    report = {"source": str(prefix), "samples": len(rows), "at_868_MHz": target,
              "target_minus14_dB_at_868_met": target["S11_dB"] <= -14,
              "resonance_minimum_established": False if len(rows) == 1 else "requires sweep review"}
    Path(str(prefix) + "_analysis.json").write_text(json.dumps(report, indent=2), encoding="utf-8")
    print(json.dumps(report, indent=2))
