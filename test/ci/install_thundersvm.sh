#!/usr/bin/env bash

set -e

CACHE_DIR=$HOME/thundersvm/$THUNDERSVM_VERSION

if [ ! -d "$CACHE_DIR" ]; then
  git clone --recursive --branch $THUNDERSVM_VERSION https://github.com/Xtra-Computing/thundersvm
  mv thundersvm $CACHE_DIR
  cd $CACHE_DIR
  mkdir build
  cd build
  cmake -DUSE_CUDA=OFF -DUSE_EIGEN=ON ..
  make
else
  echo "ThunderSVM cached"
fi
