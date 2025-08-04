#!/bin/bash

set -e

echo "Building OpenOMD Docker images for multiple architectures..."

# Build Ubuntu-based images
echo "Building Ubuntu AMD64 image..."
docker build --platform linux/amd64 -t openomd:ubuntu-amd64 -f Dockerfile .

echo "Building Ubuntu ARM64 image..."
docker build --platform linux/arm64 -t openomd:ubuntu-arm64 -f Dockerfile .

# Build Alpine-based images
echo "Building Alpine AMD64 image..."
docker build --platform linux/amd64 -t openomd:alpine-amd64 -f Dockerfile.alpine .

echo "Building Alpine ARM64 image..."
docker build --platform linux/arm64 -t openomd:alpine-arm64 -f Dockerfile.alpine .

echo "All Docker images built successfully!"
echo ""
echo "Available images:"
echo "  openomd:ubuntu-amd64"
echo "  openomd:ubuntu-arm64"
echo "  openomd:alpine-amd64"
echo "  openomd:alpine-arm64"
echo ""
echo "Run with: docker run --rm openomd:ubuntu-amd64 --help"