# openomd
Open source OMD handler

openomd is an open source OMD-C and OMD-D handler supports HKEx market data protocol. It is written in C++ and use **[Simple Binary Protocol](https://github.com/real-logic/simple-binary-encoding)**, target to be high performance.

### Build
Requirement: java-jre(1.7+), cmake (3.16+), C++ compiler (g++ 7.3.1+ or equivalent) for building and testing.

#### Quick Build
The project now uses CMake instead of Maven for better C++ integration and includes all third-party dependencies:

```sh
# Build everything (third-party libraries + OpenOMD)
./build.sh

# Build without running tests
./build.sh --no-test
```

#### Manual Build Steps

1. **Build third-party libraries**
```sh
cd third_party
./build_third_party.sh
```

2. **Build OpenOMD**
```sh
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
```

3. **Run tests**
```sh
ctest --output-on-failure
```

4. **Install**
```sh
make install
```

#### Third-party Dependencies
All dependencies are now included in the `third_party/` directory:
- **Simple Binary Encoding (SBE) 1.7.4** - Message encoding
- **Boost 1.68.0** - C++ libraries (system, filesystem, thread, etc.)
- **Google Test 1.11.0** - Testing framework
- **libpcap 1.10.1** - Packet capture
- **zlib 1.2.13** - Compression

#### SBE Message Generation
SBE messages are automatically generated during build. The build system handles the patching for OMD Group fields compatibility.

#### Using the Library
After installation, you can use OpenOMD in your CMake projects:

```cmake
find_package(openomd REQUIRED)
target_link_libraries(your_target openomd::openomd_handler)
```

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

## Legacy Maven Build (Deprecated)

**Note**: The original Maven-based build system is deprecated and may not work on all platforms (e.g., ARM64 Linux). Use the CMake build system above for better compatibility.

### Maven Build Requirements
- Java JRE 1.7+
- Maven 3.3.3+
- Platform-specific NAR plugin support

### Maven Build Commands
```sh
# Generate SBE messages
cd openomd_handler
mvn -f pom-gen.xml install
bash omdpatch.sh

# Build project
mvn clean compile

# Run tests
mvn test
```

### Known Issues
- NAR plugin may fail on ARM64 Linux due to missing linker configuration
- Requires external Maven repositories for dependencies
- Less reliable cross-platform support compared to CMake build
