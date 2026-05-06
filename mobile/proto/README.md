# Proto Source

Store canonical `.proto` schemas here for Dart generation.

Suggested workflow:

1. Rename/normalize the current schema into `.proto` format.
2. Generate Dart classes into:
   `packages/ikawa_protocol_core/lib/src/gen/`
3. Commit generated Dart files.

Generation command (example):

`protoc --dart_out=packages/ikawa_protocol_core/lib/src/gen -I=. proto/ikawa.proto`
