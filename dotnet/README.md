Uses `bcrypt.net` to benchmark.

Example output:

```
docker build -t workfactor/dotnet-bcrypt .
docker run -t workfactor/dotnet-bcrypt:latest
dotnet bcrypt(8)    avg: 33ms   min: 29ms   max:49ms
dotnet bcrypt(9)    avg: 61.9ms min: 58ms   max:70ms
dotnet bcrypt(10)   avg: 118.2ms    min: 116ms  max:122ms
dotnet bcrypt(11)   avg: 234.3ms    min: 231ms  max:240ms
dotnet bcrypt(12)   avg: 472.9ms    min: 466ms  max:513ms
dotnet bcrypt(13)   avg: 976.4ms    min: 936ms  max:1030ms
dotnet bcrypt(14)   avg: 1964.6ms   min: 1904ms max:2029ms
dotnet bcrypt(15)   avg: 3825.6ms   min: 3811ms max:3850ms
dotnet bcrypt(16)   avg: 7872ms min: 7475ms max:8756ms
```