# IKAWA Flutter Workspace

This folder contains the Flutter/Dart mobile codebase following
`../docs/flutter-architecture.md`.

## Structure

- `apps/ikawa_mobile_app`: Flutter app shell
- `packages/ikawa_protocol_core`: Pure Dart protocol logic (CRC, framing, protobuf)
- `packages/ikawa_ble_transport`: BLE abstraction and plugin-backed transport
- `packages/ikawa_app_domain`: Orchestration layer between transport and protocol
- `packages/ikawa_devtools`: Logging, replay and debug utilities

## Bootstrap

1. Install Flutter and Dart (stable channel).
2. Install melos:
   - `dart pub global activate melos`
3. From `mobile/`:
   - `melos bootstrap`
   - `melos run generate-proto`
   - `melos run analyze`
   - `melos run test`

### Protobuf code generation notes

- Requires `protoc` installed.
- Requires Dart protoc plugin on `PATH` (`protoc-gen-dart`).
- Generated files go to:
  `packages/ikawa_protocol_core/lib/src/gen/`

## Next implementation milestone

Start in `packages/ikawa_protocol_core`:
- finish `crc16` vectors
- implement frame escape/unescape tests
- wire protobuf generation under `proto/`

flutter run -d 28031FDH200D0S --package-selector=ikawa_mobile_app

## Real BLE transport toggle

In `apps/ikawa_mobile_app/lib/main.dart`:
- set `useSimulatedTransport = true` for local no-hardware flow
- set `useSimulatedTransport = false` to use `ReactiveBleTransport`

## iOS simulator notes and troubleshooting

This app can run on iOS simulator runtimes (for simulator-mode transport), as
long as Xcode sees simulator destinations for the `Runner` scheme.

If `flutter run` reports destination/runtime errors:

1. Ensure at least one iOS simulator runtime is installed in Xcode.
2. From app root (`mobile/apps/ikawa_mobile_app`), run:
   - `xcrun simctl shutdown all`
   - `xcrun simctl delete unavailable`
3. Boot a specific simulator UUID:
   - `xcrun simctl boot <SIMULATOR_UUID>`
   - `open -a Simulator`
4. Verify Flutter sees it:
   - `flutter devices`
5. Run with explicit UUID:
   - `flutter run -d <SIMULATOR_UUID>`

If CocoaPods reports `Unable to determine the platform for the Runner target`,
ensure `ios/Podfile` contains:

`platform :ios, '13.0'`
