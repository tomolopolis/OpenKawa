#!/usr/bin/env sh
set -eu

cd /workspace

# If host D-Bus is not mounted, start a local system bus.
if [ ! -S /run/dbus/system_bus_socket ]; then
  mkdir -p /run/dbus
  dbus-uuidgen --ensure=/etc/machine-id
  dbus-daemon --system --fork --nopidfile
fi

# Ensure BlueZ daemon is running in containerized dev environments.
if command -v bluetoothd >/dev/null 2>&1; then
  bluetoothd --nodetach >/tmp/bluetoothd.log 2>&1 &
fi

mkdir -p IkawaCmd
touch IkawaCmd/__init__.py
protoc -I=. --python_out=. IkawaCmd.protc

if [ "${IKAWA_PROTOCOL_ONLY:-0}" = "1" ]; then
  exec uv run ikawa-emulator-protocol
fi

exec uv run ikawa-emulator
