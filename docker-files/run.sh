#!/bin/bash
set -e

echo "Starting container with debug info..."

# Recreate /etc/passwd if missing, empty, or missing androidusr
if [ ! -f /etc/passwd ] || [ ! -s /etc/passwd ] || ! grep -q "^androidusr:" /etc/passwd; then
  echo "[entrypoint] /etc/passwd is missing, empty, or corrupted. Rebuilding it..."

  # Start with root
  # echo "root:x:0:0:root:/root:/bin/bash" > /etc/passwd

  # Add androidusr
  echo "androidusr:x:1300:1301:Android User:/home/androidusr:/bin/bash" >> /etc/passwd
fi

# Use hosts file from docker-etc-backup
echo "Setting up hosts file with blocking rules..."
if [ -f "/docker-etc-backup/hosts" ]; then
  cp /docker-etc-backup/hosts /etc/hosts
  echo "Hosts file updated with blocking rules."
else
  echo "Warning: hosts file not found in docker-etc-backup, using default hosts setup."
fi

# Clean up stale display lock/socket
rm -f /tmp/.X0-lock /tmp/.X11-unix/X0

# Ensure no X lock
if [ -f /tmp/.X0-lock ]; then
  echo "Removing stale X lock..."
  rm -f /tmp/.X0-lock
fi

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
sleep 4

export DISPLAY=:0
export QT_QPA_PLATFORM=xcb

# Start window manager
echo "Starting window manager..."
openbox &
sleep 2

# Start the emulator using the correct path
echo "Starting Android emulator..."
exec /home/androidusr/docker-android/mixins/scripts/run.sh