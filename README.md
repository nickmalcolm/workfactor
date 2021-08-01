# Work Factor

Work Factor lets you get real-world performance benchmarks for various password hashing libraries and their work factors. That makes it easier for you to decide which work factor your own application should use, and when you might need to change it.

See the Background section further down to learn more about work factors.

## Getting started

The simplest way to get started is to run a benchmark locally. They're docker containers, so they'll run anywhere that Docker can run.

```
cd ruby/bcrypt
docker build -t workfactor/ruby-bcrypt .
docker run -t workfactor/ruby-bcrypt:latest
ruby bcrypt(8)  avg: 18ms min: 18ms max: 19ms
ruby bcrypt(9)  avg: 36ms min: 35ms max: 40ms
ruby bcrypt(10) avg: 72ms min: 71ms max: 76ms
ruby bcrypt(11) avg: 144ms  min: 143ms  max: 147ms
ruby bcrypt(12) avg: 292ms  min: 287ms  max: 303ms
ruby bcrypt(13) avg: 583ms  min: 575ms  max: 594ms
ruby bcrypt(14) avg: 1156ms min: 1149ms max: 1166ms
ruby bcrypt(15) avg: 2418ms min: 2322ms max: 2697ms
ruby bcrypt(16) avg: 4684ms min: 4655ms max: 4698ms
```

## Languages, Libraries, and Algorithms

This project contains docker images which will run performance benchmarks for the following languages & libraries:


|Language|PBKDF2|bcrypt|scrypt|Argon2id|
|--------|------|------|------|--------|
|JavaScript / NPM||[node.bcrypt.js](https://github.com/kelektiv/node.bcrypt.js)|||
|Python||[bcrypt](https://github.com/pyca/bcrypt/)||[1]|
|Java|||||
|C#||[BCrypt.Net](https://github.com/BcryptNet/bcrypt.net)|||
|PHP|||||
|Go||||||
|Ruby||[bcrypt](https://github.com/codahale/bcrypt-ruby)||[rbnacl](https://github.com/RubyCrypto/rbnacl)|

Any blank cells indicate there's no benchmark written yet - please contribute! Languages in the table are listed in order of "popularity" as [rated by StackOverflow 2020](https://insights.stackoverflow.com/survey/2020#technology).

[1] Python's `argon2-cffi` library provides [a CLI tool](https://argon2-cffi.readthedocs.io/en/stable/cli.html) which will determine the optimal Argon2 parameters on a given machine. Use that instead :)

## Running the benchmarks in AWS

This guide uses [Terraform](https://learn.hashicorp.com/collections/terraform/aws-get-started) & the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html). You'll need to have both installed and configured with appropriate IAM credentials.

Use the terraform plan to create an EC2 instance; modify it to change the instance type as desired.

```sh
cd infra
terraform plan -var your_ip=YOUR_IP_HERE
terraform apply -var your_ip=YOUR_IP_HERE

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.

Outputs:

workfactor_instance_ip = "XX.XXX.XXX.XXX"
workfactor_private_key = <<EOT
-----BEGIN RSA PRIVATE KEY-----
[REDACTED]
-----END RSA PRIVATE KEY-----
EOT
```

You've now got an instance IP and a private key, which you can save (and `chmod 600` it).

Here's how you'd build the ruby benchmark's docker image, and run that on EC2.

```sh
cd ruby/bcrypt
docker build -t workfactor/bcrypt-ruby .
docker tag workfactor/bcrypt-ruby:latest public.ecr.aws/ECR_ALIAS/workfactor/bcrypt-ruby:latest
docker push public.ecr.aws/ECR_ALIAS/workfactor/bcrypt-ruby:latest

ssh -i PATH_TO_PRIVATE_KEY ec2-user@INSTANCE_IP

docker pull public.ecr.aws/ECR_ALIAS/workfactor/bcrypt-ruby:latest
docker run -t workfactor/bcrypt-ruby:latest
```

And after a bit you'll get output like this (from a `t3.micro`):

```
ruby bcrypt(8)  avg: 15ms   min: 14ms   max: 15ms
ruby bcrypt(9)  avg: 29ms   min: 29ms   max: 30ms
ruby bcrypt(10) avg: 59ms   min: 59ms   max: 59ms
ruby bcrypt(11) avg: 118ms  min: 117ms  max: 119ms
ruby bcrypt(12) avg: 237ms  min: 236ms  max: 238ms
ruby bcrypt(13) avg: 473ms  min: 469ms  max: 475ms
ruby bcrypt(14) avg: 954ms  min: 944ms  max: 980ms
ruby bcrypt(15) avg: 1900ms min: 1880ms max: 1976ms
ruby bcrypt(16) avg: 3799ms min: 3771ms max: 3866ms
```

From that, you could decide that if your login microservice is written in ruby, runs on a `t3.micro`, and you want the login flow to take < 500ms, you could use a work factor of 13. That's one more than the default of 12! Remember, though - attackers will use much more powerful machine to brute-force passwords so in practice you should consider more than a `t3.micro`

## Background

### What is a work factor?

The [OWASP Password Storage Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html#work-factors) states:

> The purpose of the work factor is to make calculating the hash more computationally expensive, which in turn reduces the speed at which an attacker can attempt to crack the password hash. ... When choosing a work factor, a balance needs to be struck between security and performance. Higher work factors will make the hashes more difficult for an attacker to crack, but will also make the process of verifying a login attempt slower. If the work factor is too high, this may degrade the performance of the application, and could also be used by an attacker to carry out a denial of service attack by making a large number of login attempts to exhaust the server's CPU.

### How does a higher work factor protect my users?

Continuing on from the ruby work factor example above, let's say an attacker has got a hold of your database and is using a `t3.micro` to attempt to brute force passwords stored using `bcrypt` with a work factor of 13, which takes ~470ms to hash.

That means it'd take 33 days to check a user's password hash against [the top 100,000 most common passwords](https://github.com/danielmiessler/SecLists/blob/master/Passwords/Common-Credentials/10-million-password-list-top-100000.txt). And since bcrypt is salted, they need to attack each user's hash one by one. 

**You've given your users 33 days to go and change their password to something stronger and to enable MFA. Not bad!**

Unfortunately, we must remember that an attacker _will not_ use a `t3.micro`, and will also use dedicated password brute-forcing software, not `bcrypt-ruby`.

### Determining a work factor

Again, from the OWASP Password Storage Cheat Sheet:

> Determining the optimal work factor will require experimentation on the specific server(s) used by the application. As a general rule, calculating a hash should take less than one second, although on higher traffic sites it should be significantly less than this.

That is a very "it depends" definition, which is the reason for this project. With these docker images you can more easily determine what work factor and/or server type is appropriate for your use case!

### Why is this using Docker?

_"Why in Docker - that'll slow things down?!"_ 🤷‍♂️ 

  > By default, a container has no resource constraints and can use as much of a given resource as the host's kernel scheduler allows.
  > 
  >   \- [Docker Docs > Runtime options with Memory, CPUs, and GPUs](https://docs.docker.com/config/containers/resource_constraints/)

So without any other constraints or other resource-intensive processes on the benchmark server, this should run fine. Docker itself, running in the background, might slow it down.

On the other hand: there's a good chance that those interested in needing to evaluate password hashing benchmarks run their apps inside Docker already. Ultimately it made it easier to deploy all the various benchmarks to the same server for comparison. :)

## Contributions

  - Benchmark Docker containers for missing libraries (see the Table above), or additional libraries for the same language-algorithm combo
  - Benchmark results for all libraries on various AWS, Azure, and GCP instance types
  - Add current-state hashcat results (e.g. how fast can attackers brute force a cost-factor bcrypt 13 password on a GPU-optimised instance)
