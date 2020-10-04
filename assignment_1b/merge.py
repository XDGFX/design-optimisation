#!/usr/bin/env python3

import io
import os

output = []
output.append(["id", "v_avg", "v_sd", "f_avg", "f_sd"])
repeat = "3"
dumpfile = "dump.csv"

for root, dirs, files in os.walk("."):
    for data in files:
        if data.endswith(".csv") and data != dumpfile:
            with io.open(data) as f:
                lines = f.readlines()
                v = lines[1].split(",")
                f = lines[2].split(",")

                output.append(
                    [repeat + data.rstrip(".csv"), v[5], v[6], f[5], f[6]])

with io.open(dumpfile, "a") as f:
    for line in output:
        f.write(",".join(line) + "\n")
