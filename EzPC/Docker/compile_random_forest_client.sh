#!/bin/sh

# Authors: Mayank Rathee.

# Copyright:
# Copyright (c) 2018 Microsoft Research
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Switch ocaml version
echo "================================================================"
echo "ocaml version switching"
echo "================================================================"
opam switch 4.06.1
eval \(opam config env\)
echo "SWITCHED"

# make EzPC again
cd ../EzPC/
make
cd ..

cd EzPC/seclud_random_forest

echo "================================================================"
echo "Copying query files to correct directories"
echo "================================================================"
cp ../../../query.txt ../../../../ABY_latest/ABY/build/bin/decision_tree_query.txt
cp ../../../rf_stats.txt decision_tree_stat.txt

echo "================================================================"
echo "Compiling to ABY"
echo "================================================================"
pwd
python correct_ezpc_code_params.py
cd .. && ./ezpc.sh seclud_random_forest/random_forest_main.ezpc --bitlen 64 && cd seclud_random_forest


echo "================================================================"
echo "Copying generated files to latest ABY examples directory"
echo "================================================================"
cp random_forest_main0.cpp ../../../../ABY-latest/ABY/src/examples/docker-test/common/millionaire_prob.cpp

# Add all example files to CMakeLists
cd ../../../../ABY-latest/ABY/src/examples/docker-test/
> CMakeLists.txt
echo 'add_executable(random_forest millionaire_prob_test.cpp common/millionaire_prob.cpp common/millionaire_prob.h)' >> CMakeLists.txt
echo 'target_link_libraries(random_forest ABY::aby ENCRYPTO_utils::encrypto_utils)' >> CMakeLists.txt

# Build the ABY files of docker-test
cd ../../../build
make

cd ../../../EzPC/EzPC

echo "DONE"
echo "================================================================"
echo "Executables are ready. They can be found in ABY/build/bin"
echo "================================================================"

