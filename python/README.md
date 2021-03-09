Uses Python 3's bcrypt library

```
docker build -t workfactor/python-bcrypt .
docker run -t workfactor/python-bcrypt:latest

python bcrypt(8)    avg: 21ms   min: 21ms   max: 21ms
python bcrypt(9)    avg: 42.4ms min: 41ms   max: 46ms
python bcrypt(10)   avg: 85.9ms min: 83ms   max: 89ms
python bcrypt(11)   avg: 190.5ms    min: 173ms  max: 220ms
python bcrypt(12)   avg: 339.7ms    min: 308ms  max: 375ms
python bcrypt(13)   avg: 657.9ms    min: 655ms  max: 663ms
python bcrypt(14)   avg: 1342.4ms   min: 1301ms max: 1420ms
python bcrypt(15)   avg: 2670.2ms   min: 2607ms max: 2859ms
python bcrypt(16)   avg: 5332.9ms   min: 5193ms max: 5572ms
```