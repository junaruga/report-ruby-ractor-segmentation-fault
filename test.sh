#!/bin/bash

set -eux

export NPROC="$(nproc)"
export JOBS=-j$((1+${NPROC}))

# https://github.com/travis-ci/travis-build/blob/e411371dda21430a60f61b8f3f57943d2fe4d344/lib/travis/build/bash/travis_apt_get_options.bash#L7
export travis_apt_get_options='--allow-downgrades --allow-remove-essential --allow-change-held-packages'
export travis_apt_get_options="-yq --no-install-suggests --no-install-recommends $travis_apt_get_options"

export debugflags=-ggdb3
export RUBY_TESTOPTS="$JOBS -q --tty=no"
export SETARCH='setarch linux32 --verbose --32bit'

function install_pkgs {
    sudo apt -yq install gcc-arm-linux-gnueabihf
    sudo dpkg --add-architecture armhf
    dpkg --print-architecture
    sudo apt-get update
    sudo -E apt-get $travis_apt_get_options install \
        crossbuild-essential-armhf \
        libc6:armhf \
        libstdc++-10-dev:armhf \
        libffi-dev:armhf \
        libncurses-dev:armhf \
        libncursesw5-dev:armhf \
        libreadline-dev:armhf \
        libssl-dev:armhf \
        libyaml-dev:armhf \
        linux-libc-dev:armhf \
        zlib1g-dev:armhf

    sudo dpkg --remove-architecture armhf
}

# Install neessary packages at once.
# install_pkgs

arm-linux-gnueabihf-gcc --version
export CC=arm-linux-gnueabihf-gcc

./autogen.sh
mkdir build
cd build
$SETARCH ../configure -C --disable-install-doc --prefix=$(pwd)/install
$SETARCH make -s $JOBS
make -s $JOBS install

$SETARCH make -s test
$SETARCH make -s test-all RUBYOPT="-w"
$SETARCH make -s test-spec
