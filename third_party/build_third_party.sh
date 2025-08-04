#!/bin/bash

set -e

THIRD_PARTY_DIR=$(pwd)
INSTALL_PREFIX=${THIRD_PARTY_DIR}/install

echo "Building third-party libraries..."
echo "Install prefix: ${INSTALL_PREFIX}"

mkdir -p ${INSTALL_PREFIX}/{include,lib,bin}

# Download and build Boost
echo "Building Boost..."
cd ${THIRD_PARTY_DIR}/boost
if [ ! -d "boost_1_68_0" ]; then
    echo "Downloading Boost 1.68.0..."
    wget -O boost_1_68_0.tar.gz https://sourceforge.net/projects/boost/files/boost/1.68.0/boost_1_68_0.tar.gz/download
    tar -xzf boost_1_68_0.tar.gz
    rm boost_1_68_0.tar.gz
fi
cd boost_1_68_0
if [ ! -f b2 ]; then
    ./bootstrap.sh --prefix=${INSTALL_PREFIX}
fi
./b2 --with-system --with-filesystem --with-thread --with-chrono --with-date_time \
     variant=release link=static threading=multi runtime-link=shared \
     cxxflags="-fPIC" install

# Extract and build zlib
echo "Building zlib..."
cd ${THIRD_PARTY_DIR}/zlib
if [ ! -d "zlib-1.2.13" ]; then
    tar -xzf zlib-1.2.13.tar.gz
fi
cd zlib-1.2.13
make clean || true
./configure --prefix=${INSTALL_PREFIX} --static
make -j$(nproc)
make install

# Extract and build libpcap
echo "Building libpcap..."
cd ${THIRD_PARTY_DIR}/pcap
if [ ! -d "libpcap-1.10.1" ]; then
    tar -xzf libpcap-1.10.1.tar.gz
fi
cd libpcap-1.10.1
make clean || true
./configure --prefix=${INSTALL_PREFIX} --disable-shared --enable-static
make -j$(nproc)
make install

# Extract and build Google Test/Mock
echo "Building Google Test/Mock..."
cd ${THIRD_PARTY_DIR}/gmock
if [ ! -d "googletest-release-1.11.0" ]; then
    tar -xzf googletest-1.11.0.tar.gz
fi
cd googletest-release-1.11.0
mkdir -p build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
         -DCMAKE_BUILD_TYPE=Release \
         -DBUILD_SHARED_LIBS=OFF \
         -DCMAKE_POSITION_INDEPENDENT_CODE=ON
make -j$(nproc)
make install

echo "Third-party libraries built successfully!"
echo "Libraries installed in: ${INSTALL_PREFIX}"