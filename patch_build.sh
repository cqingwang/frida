#/bin/bash!

install_env() {
  sudo apt-get update && DEBIAN_FRONTEND=noninteractive sudo apt-get install nodejs npm build-essential tree ninja-build gcc-multilib g++-multilib lib32stdc++-9-dev flex bison xz-utils ruby ruby-dev python3-requests python3-setuptools python3-dev python3-pip libc6-dev libc6-dev-i386 -y
  sudo gem install fpm -v 1.11.0 --no-document
  python3 -m pip install lief
  python3 -m pip install graphlib
  python3 -m pip meson
#  python3 -m pip colorama
#  python3 -m pip prompt-toolkit
#  python3 -m pip pygments
}

patch() {
  echo "\n|start:patch-core - - -"
  cd subprojects/frida-core
  git am ../../../Patchs/strongR-frida/frida-core/*.patch
  cd ../../
  pwd

  echo "\n|start:patch-gum - - -"
  cd subprojects/frida-gum/gum
  git am ../../../../Patchs/strongR-frida/frida-gum/*.patch
  cd ../../../
  pwd
}

echo "\n|start:install_env - - -"
#install_env

echo "\n|start:ndk-build - - -"
#export ANDROID_NDK_ROOT=/Users/chan/Documents/sdk/android-sdk/ndk/25.2.9519653

export ANDROID_HOME="/opt/android-sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export ANDROID_NDK_HOME="$ANDROID_HOME/ndk/22.1.7171670"
export ANDROID_NDK_ROOT="$ANDROID_NDK_HOME"

export TOOLCHAINS_HOME="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64"
export CMAKE_HOME="$ANDROID_HOME/cmake/3.18.1"
export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$ANDROID_HOME/build-tools/30.0.2:$ANDROID_NDK_HOME:$CMAKE_HOME/bin:$TOOLCHAINS_HOME/bin"
ndk-build --version

#patch
echo "\n|start:configure - - -"
./configure --host=android-arm64 --enable-portal -- -Dfrida-gum:devkits=gum,gumjs -Dfrida-core:devkits=core

echo "\n|start:make - - -"
make
