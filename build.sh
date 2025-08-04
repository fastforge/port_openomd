#!/bin/bash

set -e

PROJECT_ROOT=$(pwd)
BUILD_DIR=${PROJECT_ROOT}/build
INSTALL_DIR=${PROJECT_ROOT}/install

echo "OpenOMD Build Script"
echo "===================="

# Step 1: Build third-party libraries
echo "Step 1: Building third-party libraries..."
cd ${PROJECT_ROOT}/third_party
if [ ! -d "install" ]; then
    ./build_third_party.sh
else
    echo "Third-party libraries already built. Skipping..."
fi

# Step 2: Build OpenOMD
echo "Step 2: Building OpenOMD..."
cd ${PROJECT_ROOT}

# Create build directory
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

# Configure with CMake
cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
    -DBUILD_TESTS=ON \
    -DBUILD_TOOLS=ON

# Build
make -j$(nproc)

# Run tests
if [ "$1" != "--no-test" ]; then
    echo "Step 3: Running tests..."
    ctest --output-on-failure
fi

# Install
echo "Step 4: Installing..."
make install

echo ""
echo "Build completed successfully!"
echo "Installation directory: ${INSTALL_DIR}"
echo ""
echo "To run tools:"
echo "  ${INSTALL_DIR}/bin/openomd_tools"
echo ""
echo "To run tests manually:"
echo "  cd ${BUILD_DIR} && ctest"

## Docker Build

For cross-platform builds and testing:

```sh
# Build all architectures
./build-docker.sh

# Or use docker-compose
docker-compose build

# Run specific architecture
docker run --rm openomd:ubuntu-amd64 --help
docker run --rm openomd:alpine-arm64 --help
```

### Supported Platforms
- Ubuntu 22.04 (AMD64/ARM64)
- Alpine Linux 3.18 (AMD64/ARM64)