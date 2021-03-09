// Get performance metrics for npm's bcrypt.
//
// Performance code from https://nodejs.org/api/perf_hooks.html#perf_hooks_class_performance
// Bcrypt code from https://www.npmjs.com/package/bcrypt
// Node's bcrypt has a default work factor of 10.
const { performance } = require('perf_hooks');

const iterations = 10
const password = "1'74WcqXfb\"W_n[eMfZg5MlVfF9iPKFlJZ&PKrBT8&GrB[P1Zu~eJ*1Hij~q57Xu"

const factors = [8, 9, 10, 11, 12, 13, 14, 15, 16]
const bcrypt = require('bcrypt');


for (let saltRounds of factors) {
  let results = []

  for (let i = 0; i < iterations; i++) {
    let start = performance.now()
    let salt  = bcrypt.genSaltSync(saltRounds)
    let hash  = bcrypt.hashSync(password, salt)
    let end   = performance.now()

    results.push(end - start)
  }
  
  let average = Math.ceil(results.reduce((a,b) => (a+b)) / results.length)
  let min = Math.ceil(Math.min(...results))
  let max = Math.ceil(Math.max(...results))

  console.log(`node bcrypt(${saltRounds})\tavg: ${average}ms\tmin: ${min}ms\tmax: ${max}ms`)
}
