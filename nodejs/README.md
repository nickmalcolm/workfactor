Benchmarks node's `bcrypt library.

Example output:

```
docker build -t workfactor/bcrypt-nodejs .
docker run -t workfactor/bcrypt-nodejs:latest
node bcrypt(8)   avg: 23ms   min: 22ms   max: 24ms
node bcrypt(9)   avg: 44ms   min: 43ms   max: 46ms
node bcrypt(10)  avg: 89ms   min: 87ms   max: 90ms
node bcrypt(11)  avg: 186ms  min: 180ms  max: 201ms
node bcrypt(12)  avg: 358ms  min: 354ms  max: 369ms
node bcrypt(13)  avg: 697ms  min: 684ms  max: 723ms
node bcrypt(14)  avg: 1418ms min: 1367ms max: 1515ms
node bcrypt(15)  avg: 2813ms min: 2775ms max: 2969ms
node bcrypt(16)  avg: 5732ms min: 5507ms max: 6123ms
``