FROM ubuntu:20.04
ENV ELIXIR_VERSION=1.11.3-otp-23

# Set Timezone so TZ Info doesn't hault the build
ENV DEBIAN_FRONTEND="noninteractive"
ENV TZ="America/Chicago"

# get tools needed to build required tools
RUN apt-get update && apt-get install -yq \
    build-essential \
    wget \
    curl \
    zip \
    openssh-client \
    postgresql \
    libnss3-dev \
    libxss-dev \
    libasound2-dev \
    git

# setup erlang apt repo
RUN wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb; \
    dpkg -i --force-depends erlang-solutions_2.0_all.deb

# setup nodejs apt repo
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

# install nodejs and erlang
RUN apt-get update && apt-get install -yq \
    nodejs \
    esl-erlang

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# install elixir
RUN wget https://repo.hex.pm/builds/elixir/v$ELIXIR_VERSION.zip && \
    mkdir -p /usr/local/elixir && \
    unzip -d /usr/local/elixir v$ELIXIR_VERSION.zip
ENV PATH=/usr/local/elixir/bin:$PATH

RUN mix local.hex --force; \
    mix local.rebar --force

# update npm
RUN npm install -g npm
