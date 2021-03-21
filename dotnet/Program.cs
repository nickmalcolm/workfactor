using System;
using System.Runtime.InteropServices;
using System.Collections.Generic;
using System.Linq;
using static System.Console;

// https://github.com/BcryptNet/bcrypt.net
// The default is 11
// using BCrypt = BCrypt.Net.BCrypt;

public static class Program
{
    public static void Main(string[] args) 
    {
          for (int cost = 8; cost <= 16; cost++)
          {
              List<long> numbers = new List<long>();
              for (int runs = 0; runs < 10; runs++)
              {
                  var watch = System.Diagnostics.Stopwatch.StartNew();
                  string passwordHash =  BCrypt.Net.BCrypt.HashPassword("my password", workFactor: cost);
                  watch.Stop();
                  var elapsedMs = watch.ElapsedMilliseconds;
                  numbers.Add(elapsedMs);
              }
              WriteLine($"dotnet bcrypt({cost})\tavg: {numbers.Average()}ms\tmin: {numbers.Min()}ms\tmax:{numbers.Max()}ms");
          }

    }
}