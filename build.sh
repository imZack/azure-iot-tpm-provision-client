#!/bin/bash
set -ex

env

# Install Deps
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -o Dpkg::Options::="--force-confold" install -y \
  python \
  python-pip \
  curl \
  build-essential \
  pkg-config \
  libcurl4-openssl-dev \
  git \
  cmake \
  libssl-dev \
  uuid-dev \
  valgrind

pip install -U pip
hash -d pip
pip install exodus-bundler

# Build
git clone --recursive --depth 1 --branch "$SDK_TAG" https://github.com/Azure/azure-iot-sdk-c.git
cd azure-iot-sdk-c
mkdir cmake
cd cmake
cmake -Duse_prov_client:BOOL=ON -Duse_tpm_simulator:BOOL="$TPM_SIMULATOR" ..
make

# Create exodus bundle
exodus provisioning_client/tools/tpm_device_provision/tpm_device_provision --output "/output/tpm_device_provision-simulator_$TPM_SIMULATOR-$ARCH"
