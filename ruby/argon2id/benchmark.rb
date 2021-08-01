# Get performance for rbnacl's implementation of Argon2.
# ruby-bcrypt has a default cost of 12.
require 'rbnacl'
require 'benchmark'

ITERATIONS = 10
PASSWORD = "1'74WcqXfb\"W_n[eMfZg5MlVfF9iPKFlJZ&PKrBT8&GrB[P1Zu~eJ*1Hij~q57Xu".freeze
RESULT_FMT = "ruby rbnacl argon2id(%s)\tavg: %dms\tmin: %dms\tmax: %dms".freeze


# See current definitions here: https://github.com/RubyCrypto/rbnacl/blob/3fb9eb25f3e08d98f4a5b1beb787b0812cad6d7f/lib/rbnacl/password_hash/argon2.rb#L76-L94
costs = [
  :interactive,
  :moderate,
  :sensitive
]

costs.each do |cost|
  results = ITERATIONS.times.collect do
    Benchmark.measure do
      RbNaCl::PasswordHash::Argon2.new(cost, cost).digest_str(PASSWORD)
    end.real
  end

  puts RESULT_FMT % [cost.to_s.ljust(11), results.sum(0.0)/ITERATIONS*1000, results.min*1000, results.max*1000]
end
