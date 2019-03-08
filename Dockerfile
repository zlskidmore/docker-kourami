# work from latest LTS ubuntu release
FROM ubuntu:18.04

# set environment variables
ENV kourami_version 0.9.6
ENV bwa_version 0.7.17

# Install dependencies
RUN apt-get update -y && apt-get install -y \
    build-essential \
    libnss-sss \
    openjdk-8-jre \
    curl \
    maven \
    libz-dev \
    unzip \
    vim \
    wget

# download bwa
WORKDIR /usr/local/bin/
RUN mkdir -p /usr/local/bin/ \
  && curl -SL https://github.com/lh3/bwa/archive/v${bwa_version}.zip \
  >  v${bwa_version}.zip
RUN unzip v${bwa_version}.zip && rm -f v${bwa_version}.zip
RUN cd /usr/local/bin/bwa-${bwa_version} && make
RUN ln -s /usr/local/bin/bwa-${bwa_version}/bwa /usr/local/bin

# Install kourami
WORKDIR /usr/local/bin/
RUN curl -SL https://github.com/Kingsford-Group/kourami/archive/v${kourami_version}.tar.gz \
    > v${kourami_version}.tar.gz
RUN tar -xzvf v${kourami_version}.tar.gz
WORKDIR /usr/local/bin/kourami-${kourami_version}
RUN mvn install
RUN bash /usr/local/bin/kourami-${kourami_version}/scripts/download_panel.sh
RUN ln -s /usr/local/bin/kourami-${kourami_version}/target/Kourami.jar /usr/local/bin/Kourami.jar
WORKDIR /usr/local/bin
