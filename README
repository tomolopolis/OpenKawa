### IKAWA EMULATOR

A python app that implements some of the protocol of IKAWA roasting system.
Original simulator: https://github.com/esteveespuna/IkawaRoasterEmulator.

For the mobile app direction, see `docs/flutter-architecture.md`.
Initial Flutter workspace scaffold is under `mobile/`.

## Installation (uv)

Install dependencies and create a virtual environment:

uv sync

`bluezero` is Linux/BlueZ-based and is installed only on Linux in this project config.
On macOS, `uv sync` will skip Bluetooth runtime dependencies and still install the project for non-BLE development.

If you need to build `pycairo`/`pygobject` directly, install system build tools first (macOS example):

brew install pkg-config cairo cmake

## Protobuf generation

This repository expects the Python protobuf module generated from `IkawaCmd.protc`.
Generate it into an `IkawaCmd` package:

mkdir -p IkawaCmd
touch IkawaCmd/__init__.py
protoc -I=./ --python_out=./ ./IkawaCmd.protc

If you have protobuf runtime compatibility issues:

export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python

## Running

Preferred:

uv run ikawa-emulator

Protocol-only (no BLE, useful on macOS for app/protocol iteration):

uv run ikawa-emulator-protocol

Compatibility entrypoint:

uv run python pySimIkawa.py

## Linux development workflow (Docker/K8s)

Production and BLE runtime are Linux-first. For local development on macOS, run
the service in a Linux environment (VM or container).

When using Docker, remember BLE access usually requires host-level Bluetooth
access (often host networking + elevated privileges depending on setup).
This is expected for BlueZ-based services.

### Local container workflow

Build and run with Docker Compose:

docker compose up --build

Protocol-only service (recommended on macOS):

docker compose up --build ikawa-emulator-protocol

This development container:
- installs Linux BLE dependencies (`bluez`, `dbus`)
- runs `protoc` on startup to generate `IkawaCmd/protc_pb2.py`
- starts either:
  - `uv run ikawa-emulator` (full BLE mode), or
  - `uv run ikawa-emulator-protocol` when `IKAWA_PROTOCOL_ONLY=1`

Notes:
- This works best on a Linux host with Bluetooth access.
- On macOS Docker Desktop, host Bluetooth passthrough is limited; use a Linux VM
  for full BLE integration testing.
- The container starts its own D-Bus daemon and BlueZ userspace daemon.
  You still need real Linux BLE hardware passthrough to find an adapter.

Connect with IkawaMonitor APP or with the official app to this emulated roaster.

To start roasting create an empty file under the same running directory. This is equivalent to pressing the button on the IKAWA roaster.

touch simulate

The emulator will reply with a recorded session. In this repository you'll find an example : sim_session_exp3_feb26.csv

Once the session has been completed the file is removed. The emulator runs faster than the actual IKAWA, see the code to change this behaviour.

