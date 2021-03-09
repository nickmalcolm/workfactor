# Get performance for ruby's ruby-bcrypt.
# ruby-bcrypt has a default cost of 12.
require 'bcrypt'
require 'benchmark'

ITERATIONS = 10
PASSWORD = "1'74WcqXfb\"W_n[eMfZg5MlVfF9iPKFlJZ&PKrBT8&GrB[P1Zu~eJ*1Hij~q57Xu".freeze
RESULT_FMT = "ruby bcrypt(%d)\tavg: %dms\tmin: %dms\tmax: %dms".freeze

(8..16).each do |cost|
  BCrypt::Engine.cost = cost
  results = ITERATIONS.times.collect do
    Benchmark.measure do
      BCrypt::Password.create(PASSWORD)
    end.real
  end

  puts RESULT_FMT % [cost, results.sum(0.0)/ITERATIONS*1000, results.min*1000, results.max*1000]
end
