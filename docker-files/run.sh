#!/bin/bash
set -e

echo "Starting container with debug info..."

# Debug information
echo 'Debug: KVM device info:'
ls -l /dev/kvm || echo 'KVM device not found'
echo 'Debug: Current user info:'
id

# Clean up any stale files
echo "Cleaning up stale files..."
find /home/androidusr/.android/avd/ -name "*.lock" -delete 2>/dev/null || true
find /home/androidusr/emulator/ -name "*.lock" -delete 2>/dev/null || true
find /home/androidusr/emulator/ -name "*.pid" -delete 2>/dev/null || true
rm -rf /home/androidusr/.android/avd/*/snapshots/ 2>/dev/null || true
rm -rf /home/androidusr/android_emulator_home/snapshots/ 2>/dev/null || true

# Start Xvfb
echo "Starting Xvfb..."
Xvfb :0 -screen 0 1280x800x24 &
sleep 2

export DISPLAY=:0
export QT_QPA_PLATFORM=xcb

# Start window manager
echo "Starting window manager..."
openbox &
sleep 1

# Start the emulator using the correct path
echo "Starting Android emulator..."
exec /home/androidusr/docker-android/mixins/scripts/run.sh