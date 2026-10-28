"""Analyze native temporal-solver S11 exports; retain provenance of interpolation."""
import bisect
import json
import math
import sys
from pathlib import Path
from analyze_rf_fd import read_curve

prefix = Path(sys.argv[1])
real = read_curve(Path(str(prefix) + "_S11_real.txt"))
imag = read_curve(Path(str(prefix) + "_S11_imaginary.txt"))
if len(real) != len(imag) or len(real) < 2:
    raise ValueError("Expected a complete temporal frequency sweep")
freq = [row[0] for row in real]
gamma = []
for (f, r), (fi, i) in zip(real, imag):
    if abs(f - fi) > 1e-9 or not all(math.isfinite(v) for v in (f, r, i)):
        raise ValueError("Invalid complex export or mismatched frequency grids")
    gamma.append(complex(r, i))
if any(a >= b for a, b in zip(freq, freq[1:])):
    raise ValueError("Frequency grid must be strictly increasing")
db = [20 * math.log10(max(abs(v), 1e-15)) for v in gamma]
target = 0.868
idx = bisect.bisect_left(freq, target)
if idx < len(freq) and abs(freq[idx] - target) < 1e-8:
    g868 = gamma[idx]
    method = "native frequency sample"
else:
    if idx == 0 or idx == len(freq):
        raise ValueError("868 MHz is outside the simulated band")
    fraction = (target - freq[idx - 1]) / (freq[idx] - freq[idx - 1])
    g868 = gamma[idx - 1] + fraction * (gamma[idx] - gamma[idx - 1])
    method = "linear interpolation of native complex samples"
z868 = 50 * (1 + g868) / (1 - g868)
db868 = 20 * math.log10(max(abs(g868), 1e-15))
minimum = min(range(len(db)), key=db.__getitem__)


def threshold_band(threshold):
    if db[minimum] > threshold:
        return None
    l = r = minimum
    while l > 0 and db[l - 1] <= threshold:
        l -= 1
    while r < len(db) - 1 and db[r + 1] <= threshold:
        r += 1
    if l == 0 or r == len(db) - 1:
        return {"truncated_by_simulated_band": True}
    low = freq[l - 1] + (threshold - db[l - 1]) / (db[l] - db[l - 1]) * (freq[l] - freq[l - 1])
    high = freq[r] + (threshold - db[r]) / (db[r + 1] - db[r]) * (freq[r + 1] - freq[r])
    return {"low_MHz": low * 1000, "high_MHz": high * 1000,
            "bandwidth_MHz": (high - low) * 1000,
            "method": "linear dB threshold crossings around sampled global minimum"}


def threshold_intervals(frequency, magnitude_db, threshold):
    intervals = []
    i = 0
    while i < len(frequency):
        if magnitude_db[i] > threshold:
            i += 1
            continue
        left = i
        while i + 1 < len(frequency) and magnitude_db[i + 1] <= threshold:
            i += 1
        right = i
        low_truncated = left == 0
        high_truncated = right == len(frequency) - 1
        low = frequency[left] if low_truncated else frequency[left - 1] + (threshold - magnitude_db[left - 1]) / (magnitude_db[left] - magnitude_db[left - 1]) * (frequency[left] - frequency[left - 1])
        high = frequency[right] if high_truncated else frequency[right] + (threshold - magnitude_db[right]) / (magnitude_db[right + 1] - magnitude_db[right]) * (frequency[right + 1] - frequency[right])
        intervals.append({"low_MHz": low * 1000, "high_MHz": high * 1000,
                          "bandwidth_MHz": None if low_truncated or high_truncated else (high - low) * 1000,
                          "observed_width_MHz": (high - low) * 1000,
                          "low_truncated": low_truncated, "high_truncated": high_truncated})
        i += 1
    return intervals


all_bands = {str(level): threshold_intervals(freq, db, level) for level in [-10, -14]}
operating_bands = {level: next((band for band in bands if band["low_MHz"] <= 868 <= band["high_MHz"] and db868 <= float(level)), None) for level, bands in all_bands.items()}

report = {
    "source": str(prefix), "solver": "HF Time Domain", "samples": len(freq),
    "band_MHz": [freq[0] * 1000, freq[-1] * 1000],
    "at_868_MHz": {"S11_dB": db868, "S11_real": g868.real, "S11_imaginary": g868.imag,
                   "Z_real_ohm": z868.real, "Z_imaginary_ohm": z868.imag, "method": method},
    "sampled_minimum": {"frequency_MHz": freq[minimum] * 1000, "S11_dB": db[minimum]},
    "minus10_dB_band": threshold_band(-10), "minus14_dB_band": threshold_band(-14),
    "threshold_intervals_MHz": all_bands,
    "operating_bands_at_868_MHz": operating_bands,
    "frequency_step_max_MHz": max(b - a for a, b in zip(freq, freq[1:])) * 1000,
    "minimum_at_band_edge": minimum in (0, len(db) - 1),
    "passivity_tolerance_abs_gamma": 0.001,
    "passivity_within_tolerance": max(map(abs, gamma)) <= 1.001,
    "maximum_abs_gamma": max(map(abs, gamma)),
    "target_minus14_dB_at_868_met": db868 <= -14 and abs(g868) <= 1,
    "validation_status": "Preliminary mesh; inspect native termination and perform finer-mesh validation",
}
Path(str(prefix) + "_analysis_td.json").write_text(json.dumps(report, indent=2), encoding="utf-8")
print(json.dumps(report, indent=2))
