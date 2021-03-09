# Code based on examples from https://pypi.org/project/bcrypt/
# Python's bcrypt has a default work factor of 12.

import bcrypt
import time
import statistics
import math

password = b"1'74WcqXfb\"W_n[eMfZg5MlVfF9iPKFlJZ&PKrBT8&GrB[P1Zu~eJ*1Hij~q57Xu"


for workfactor in range(8,16+1):
    results = []

    for i in range(10):
        t0 = time.time()
        hashed = bcrypt.hashpw(password, bcrypt.gensalt(workfactor))
        t1 = time.time()
        results.append(math.ceil((t1 - t0) * 1000))

    avgt = statistics.mean(results)
    mint = min(results)
    maxt = max(results)
    print(f"python bcrypt({workfactor})\tavg: {avgt}ms\tmin: {mint}ms\tmax: {maxt}ms")
