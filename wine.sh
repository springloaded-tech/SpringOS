#!/bin/bash

# Update package list
echo "Updating package list..."
apt update

# Install Wine
echo "Installing Wine..."
apt install -y wine

# Confirm installation
echo "Wine installation complete."
