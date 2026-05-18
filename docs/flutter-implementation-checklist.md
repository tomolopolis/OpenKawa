# Flutter mobile — implementation checklist

Living status for `mobile/` vs [`flutter-architecture.md`](flutter-architecture.md).  
Update checkboxes when items are completed or scope changes.

**Legend:** `[x]` done · `[~]` partial · `[ ]` not started

---

## Foundation (architecture spec)

- [x] Melos workspace: `ikawa_mobile_app`, `ikawa_protocol_core`, `ikawa_ble_transport`, `ikawa_app_domain`, `ikawa_devtools` (stub)
- [x] `ikawa_protocol_core`: CRC16, framing, reassembly, protobuf codegen from `proto/`
- [x] `ikawa_ble_transport`: `BleTransport`, `ReactiveBleTransport`, characteristic UUIDs
- [x] `ikawa_app_domain`: `RoasterSessionService`, `DefaultIkawaProtocolClient`, typed send + seq check
- [x] Simulator vs real BLE toggle (`useSimulatedTransport`)
- [x] Riverpod wiring; UI does not call BLE plugin directly
- [x] Protocol unit tests (CRC, codec, reassembler)
- [x] Domain unit tests (session, catalog, series, validator)
- [x] Minimal app widget tests (shell + simulator connect)
- [~] Request/response pipeline: timeout + seq match (no general retry / in-flight queue)
- [ ] CI: `melos analyze` + `melos test` on every push (no `.github` workflow yet)
- [ ] Protocol goldens: protobuf round-trip, malformed-frame / escape vectors
- [ ] BLE reconnection policy and background/foreground behavior

---

## Devtools & diagnostics

- [~] `ikawa_devtools`: package exists; `PacketLogEntry` only
- [ ] TX/RX packet log (hex + timestamp) in app or devtools
- [ ] Parsed command/response log + connection lifecycle events
- [ ] Session export for bug reports
- [ ] Packet recorder / replayer for fixtures

---

## Roaster connectivity (Roaster tab)

- [x] Scan, connect, disconnect
- [x] Android / iOS BLE permissions
- [x] `MACH_STATUS_GET_ALL` polling while connected
- [x] Machine info commands (version, type, id, support, roast count)
- [x] `PROFILE_GET` on status refresh (text summary)
- [x] `PROFILE_SET` upload (`ProfileUploadService`)
- [x] Live telemetry: time, bean temp, RoR, fan setpoint → chart overlay
- [ ] Map `pb.RoastProfile` ↔ `RoastProfileSeries` (domain mapper)
- [ ] Show downloaded machine profile on chart (not only catalog synthetic)
- [ ] Validate / document `status.time` vs profile `timeSec` on real hardware
- [ ] Hardware-in-the-loop checklist (reconnect, interrupt, background)

---

## Profiles & charts (Profiles tab)

- [x] In-memory catalog + search / filters
- [x] Profile detail: Temperature / Advanced modes
- [x] Chart: bean temp, RoR, fan (independent temp/fan time axes)
- [x] Synthetic curves: preheat → roast → cooling; RoR from temp; full fan in cooling
- [x] JSON profile import; roast level / DTR presets (`buildPresetSeries`)
- [x] `RoastProfileValidator`
- [x] Editable chart (advanced) + local validation feedback
- [ ] Persist edited / imported profiles (replace demo-only catalog)
- [ ] Upload edited profile from detail screen (if not already wired everywhere)

---

## Roast session & history

- [x] Local roast session: start / stop, mark first crack, DTR display
- [x] Sample recording during session; run history screen
- [x] Bean library (Hive)
- [ ] Wire start/stop to machine if protocol exposes it (today: app-side session only)
- [ ] Auto-save / richer run metadata from status or profile end state

---

## Suggested next milestones

1. **Real profiles E2E** — `PROFILE_GET` → `RoastProfileSeries`; chart + catalog from device/import.
2. **Reliability** — retries, reconnect, CI, HIL on one physical roaster.
3. **Diagnostics** — packet log UI + export via `ikawa_devtools`.

---

*Last reviewed: 2026-05-18*
