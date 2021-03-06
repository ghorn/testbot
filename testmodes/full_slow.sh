#!/bin/bash
set -e

mkdir build
pushd build
cmake -DWITH_WORHP=ON -DWITH_SLICOT=ON -DWITH_OOQP=ON -DWITH_PROFILING=ON -DWITH_DOC=ON -DWITH_EXAMPLES=ON -DWITH_COVERAGE=ON -DWITH_EXTRA_WARNINGS=ON -DWITH_PYTHON=ON -DWITH_JSON=ON .. 
make -j2
sudo make -j2 install
popd

git clone https://github.com/jgillis/pyreport.git
pushd pyreport && sudo python setup.py install && popd
sudo apt-get install python-lxml valgrind -y

python -c "from casadi.tools import *;loadAllCompiledPlugins()"
pushd test && make unittests_py_slow && popd
pushd build && make json && popd


