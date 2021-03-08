# Work Factor

Work Factor lets you get real-world performance benchmarks for various password hashing libraries and their work factors. That makes it easier for you to decide which work factor your own application should use, and when you might need to change it.

See the Background section further down to learn more about work factors.

## Getting started

This project contains docker images which will run performance benchmarks for the following languages & libraries:

  - [Ruby's ruby-bcrypt](https://github.com/codahale/bcrypt-ruby)
  - [NodeJS's bcrypt](https://github.com/kelektiv/node.bcrypt.js)
  - ... see Roadmap

### Running the benchmarks yourself

This guide uses Terraform & AWS. You'll need to have both installed and configured with appropriate IAM credentials.

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
cd ruby
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

### Determining a work factor

Again, from the OWASP Password Storage Cheat Sheet:

> Determining the optimal work factor will require experimentation on the specific server(s) used by the application. As a general rule, calculating a hash should take less than one second, although on higher traffic sites it should be significantly less than this.

### Why is this using Docker?

Why in Docker - that'll slow things down?! Yes it will. However I imagine many of those interested in this already run their apps inside Docker. It also makes it easier to deploy all the various benchmarks to the same server for comparison.

## Roadmap

Contributions on the following would be welcome:

  - Additional password hashing libraries for popular languages
    + Python
    + Java
    + .Net
    + PHP
    + Go
  - Add current-state hashcat results (i.e. how fast can attackers brute force a cost-factor 13 password on a GPU-optimised instance)
