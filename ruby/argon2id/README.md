Uses `rbnacl` to benchmark `argon2id` with its three built-in work factors.

Example output:

```
docker build -t workfactor/ruby-rbnacl .
docker run -t workfactor/ruby-rbnacl:latest
ruby rbnacl argon2id(interactive)	avg: 71ms	min: 69ms	max: 74ms
ruby rbnacl argon2id(moderate   )	avg: 443ms	min: 434ms	max: 454ms
ruby rbnacl argon2id(sensitive  )	avg: 2500ms	min: 2387ms	max: 2740ms
```