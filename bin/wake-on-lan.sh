#!/usr/bin/env bash
echo "Running script with bash version: $BASH_VERSION"
GIT_ROOT=$(git rev-parse --show-toplevel)

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
echo "Running on ${machine}"

case ${machine} in
  Linux)
    apt-get install etherwake
    etherwake 04:42:1a:25:a6:e0
    ;;

  Mac)  
    brew install wakeonlan
    wakeonlan 04:42:1a:25:a6:e0
    ;;

  *)
    echo "UNKNOWN:${unameOut}"
    ;;
esac
