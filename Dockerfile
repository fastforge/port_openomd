FROM ubuntu:22.04

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    flex \
    bison \
    wget \
    openjdk-11-jre-headless \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace

# Copy source code
COPY . .

# Build the project
RUN ./build.sh

# Set default command
CMD ["./install/bin/openomd_tools"]