# IKAWA Mobile App Architecture (Flutter)

This document is a concrete architecture for building the iOS/Android app as a
single Flutter codebase, while keeping BLE risk isolated and testability high.

## Goals

- One app codebase for iOS and Android.
- Shared protocol implementation in Dart (framing, CRC, protobuf mapping).
- Thin BLE transport layer with minimal platform-specific code.
- Fast local development without hardware + robust hardware-in-loop testing.

## Recommended Monorepo Layout

Use a Flutter workspace with local Dart/Flutter packages:

```text
mobile/
  apps/
    ikawa_mobile_app/
  packages/
    ikawa_protocol_core/
    ikawa_ble_transport/
    ikawa_app_domain/
    ikawa_devtools/
```

### `apps/ikawa_mobile_app`

Flutter UI app only:
- screens/widgets
- app routing
- dependency injection wiring
- feature flags (real BLE vs simulator)

No protocol encoding logic in widgets.

### `packages/ikawa_protocol_core`

Pure Dart package (no Flutter dependency):
- frame parser/encoder (`0x7E` delimiters, escaping rules)
- CRC16 implementation
- protobuf encoding/decoding of IKAWA messages
- command/response typed models
- deterministic state machine for request/response flow

This package is your highest-value shared asset.

### `packages/ikawa_ble_transport`

Flutter package for BLE IO abstraction:
- `BleTransport` interface
- default implementation backed by `flutter_reactive_ble` (or `flutter_blue_plus`)
- characteristic UUID definitions
- connection/notify/write behavior
- reconnection policy hooks

No business logic here; only bytes in/out and connection state.

### `packages/ikawa_app_domain`

Application services orchestrating transport and protocol:
- `RoasterSessionService`
- command pipelines (`send`, `await response`, timeout/retry)
- roast profile upload/download flows
- runtime state models exposed to UI

### `packages/ikawa_devtools`

Optional internal tooling package:
- packet/session recorder
- replay helpers for bug reproduction
- fixture helpers for tests

## Boundary Rules (Important)

- UI never talks directly to BLE plugin.
- BLE package never interprets command semantics.
- Protocol core never imports Flutter/plugin APIs.
- Domain package is the only layer that composes BLE + protocol.

These rules keep refactors manageable when BLE behavior gets tricky.

## Core Interfaces (Initial)

Define these first:

- `BleTransport`
  - `Future<void> connect(String deviceId)`
  - `Future<void> disconnect()`
  - `Stream<Uint8List> notifications()`
  - `Future<void> write(Uint8List bytes, {bool withResponse = true})`
  - `Stream<ConnectionState> connectionState()`

- `FrameCodec` (protocol core)
  - `List<Uint8List> splitFrames(Uint8List chunkedBytes)`
  - `Uint8List encodeFrame(Uint8List payload)`
  - `Uint8List decodeFrame(Uint8List framed)`

- `IkawaProtocolClient` (domain-facing protocol wrapper)
  - `Future<IkawaResponse> send(IkawaRequest req)`
  - handles sequence IDs, timeout/retry, response correlation

## Protobuf Strategy

Use `protoc` to generate Dart models from your schema:
- keep source `.proto` files in a shared `proto/` folder
- generate Dart into `ikawa_protocol_core/lib/src/gen/`
- commit generated code to avoid tooling friction for contributors

Treat generated files as build artifacts with no manual edits.

## State Management Choice

As a solo dev, pick predictable and lightweight:
- `riverpod` + `state_notifier` or `notifier`

Recommended split:
- transport connection state provider
- roaster runtime state provider
- command/task providers for profile upload and roast lifecycle

## Testing Strategy

### 1) Protocol Core Tests (highest priority)

In `ikawa_protocol_core/test/`:
- CRC vectors
- escape/unescape vectors
- frame chunk reassembly tests
- protobuf decode/encode golden tests
- malformed frame tests

These should run on every commit in CI.

### 2) Domain Service Tests

In `ikawa_app_domain/test/`:
- fake `BleTransport` to simulate notifications/writes
- timeout/retry behavior
- command correlation by sequence
- roast flow happy path + failure paths

### 3) App Integration Tests

In app package:
- smoke user journeys
- mocked domain services for deterministic UI tests

### 4) Hardware-in-Loop Checklist

Manual but structured:
- connect/disconnect stability
- profile upload
- status polling during roast
- interruption/recovery behavior
- app background/foreground transitions

## Dev Environment Modes

Support two run modes from day one:

- **Real BLE mode**
  - uses `BleTransport` plugin implementation
  - targets actual roaster

- **Simulator mode**
  - uses fake transport feeding recorded packets
  - zero hardware dependency

Toggle with compile-time or runtime feature flag.

## Logging and Diagnostics

Add these early:
- raw TX/RX packet logs (hex + timestamp)
- parsed command/response logs
- connection lifecycle events
- optional export of session logs for issue reports

This will save huge amounts of debugging time.

## Suggested Build Plan

- Create workspace/packages
- Implement `ikawa_protocol_core` framing + CRC + tests
- Add protobuf generation pipeline for Dart
- Implement BLE transport abstraction + plugin-backed implementation
- Build basic connect + notify + write test screen in app
- Implement `ikawa_app_domain` request/response pipeline
- Add profile/status flows and retry/timeout handling
- Hardware stabilization and error-handling polish
- Add session recorder/replayer and improve user-facing diagnostics

## What to Keep From This Python Repo

Keep this repo as:
- protocol reference implementation
- emulator/simulator behavior reference
- source of test vectors and packet captures

Do not depend on Python runtime inside the phone app.

## First Concrete Next Step

Create the Flutter workspace and the first package:
- `packages/ikawa_protocol_core`
- implement `crc16.dart`
- add 10+ CRC/framing tests using vectors from current Python logic

Once this is in place, UI and BLE work can safely iterate around a stable core.
