FROM elixir:1.9

EXPOSE 4000

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

# Setup for node + yarn
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt update \
    && apt install -y \
        g++ \
        gcc \
        inotify-tools \
        locales \
        nodejs \
        postgresql-client \
        yarn \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen

# The --force flag does the installation without a shell prompt
RUN mix do \
    local.hex --force, \
    local.rebar --force, \
    archive.install hex phx_new 1.4.10 --force

COPY ./src .

CMD [ "mix", "phx.server" ]
