FROM 'ruby:2.7.2'
RUN apt-get update -y && \
	apt-get install -y libsodium-dev 

RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

ENTRYPOINT ["ruby", "benchmark.rb"]