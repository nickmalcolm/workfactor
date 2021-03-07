Uses `bcrypt-ruby` to benchmark.

Example output:

```
docker build -t bcrypt-benchmark .
docker run -t bcrypt-benchmark
ruby bcrypt(8)	avg: 18ms	min: 18ms	max: 19ms
ruby bcrypt(9)	avg: 36ms	min: 35ms	max: 40ms
ruby bcrypt(10)	avg: 72ms	min: 71ms	max: 76ms
ruby bcrypt(11)	avg: 144ms	min: 143ms	max: 147ms
ruby bcrypt(12)	avg: 292ms	min: 287ms	max: 303ms
ruby bcrypt(13)	avg: 583ms	min: 575ms	max: 594ms
ruby bcrypt(14)	avg: 1156ms	min: 1149ms	max: 1166ms
ruby bcrypt(15)	avg: 2418ms	min: 2322ms	max: 2697ms
ruby bcrypt(16)	avg: 4684ms	min: 4655ms	max: 4698ms
```