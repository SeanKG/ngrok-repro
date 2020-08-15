FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client curl unzip

RUN curl -O https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip && \
    unzip ngrok-stable-linux-amd64.zip -d /usr/local/bin && \
    rm -f ngrok-stable-linux-amd64.zip

RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp
# RUN bin/rails db:create && bin/rails db:migrate

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000
EXPOSE 4040

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
