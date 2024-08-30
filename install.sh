#!/bin/bash

# Exit on any error
set -e

# Change to the directory where the script is located
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
cd "$SCRIPT_DIR"

# Define necessary variables
LIBFPRINT_FILE="libfprint-2.so.2"

# Step 1: Install libfprint RPM for CS9711
echo "Step 1: Installing libfprint RPM for CS9711..."
sudo dnf install -y ./rpm/libfprint-1.94.6-0.0.1.x86_64.rpm

# Step 2: Install fprint and related packages
echo "Step 2: Installing fprint and fprintd-pam..."
sudo dnf install -y fprintd fprintd-pam

# Verify the shared library
echo "Verifying the shared library..."
if ! ldconfig -p | grep -q "$LIBFPRINT_FILE"; then
    echo "Error: $LIBFPRINT_FILE not found in ldconfig."
    exit 1
fi

# Step 4: Reload ldconfig to apply new library configurations
echo "Step 4: Reloading ldconfig..."
sudo ldconfig

# Step 5: Start fprintd.service
echo "Step 5: Starting fprintd.service..."
sudo systemctl start fprintd.service

# Optional: Enable fprintd.service to start at boot
echo "Checking if fprintd.service needs configuration for startup..."
if ! grep -q "\[Install\]" /usr/lib/systemd/system/fprintd.service; then
    echo -e "\n[Install]\nWantedBy=multi-user.target" | sudo tee -a /usr/lib/systemd/system/fprintd.service
fi

echo "Enabling fprintd.service to start at boot..."
sudo systemctl enable fprintd.service

# Enable fingerprint authentication in authselect
echo "Enabling fingerprint authentication with authselect..."
sudo authselect enable-feature with-fingerprint

echo "Script completed successfully."
echo "Make sure to add fingerprints through GNOME settings or the relevant GUI tool."
