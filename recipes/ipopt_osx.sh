#!/bin/bash
set -e

VERSION=3.12.3

mypwd=`pwd`

wget http://www.coin-or.org/download/source/Ipopt/Ipopt-$VERSION.tgz
tar -xvf Ipopt-$VERSION.tgz
pushd Ipopt-$VERSION
pushd ThirdParty
pushd ASL && ./get.ASL && popd
pushd Blas && ./get.Blas && popd 
pushd Lapack && ./get.Lapack && popd 
pushd Metis && ./get.Metis && popd 
pushd Mumps && ./get.Mumps && popd
popd
mkdir build
pushd build
../configure --prefix=/Users/travis/ipopt-install --disable-shared ADD_FFLAGS=-fPIC ADD_CFLAGS=-fPIC ADD_CXXFLAGS=-fPIC --with-blas=BUILD --with-lapack=BUILD --with-mumps=BUILD --with-metis=BUILD --without-hsl --with-asl=BUILD
make
make install
popd && popd
tar -zcvf ipopt_osx.tar.gz -C /Users/travis/ipopt-install .
export PYTHONPATH="$PYTHONPATH:$mypwd/helpers" && python -c "from restricted import *; upload('ipopt_osx.tar.gz')"



