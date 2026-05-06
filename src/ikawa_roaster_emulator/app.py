import importlib
import os
import platform
import time


def run_protocol_only():
    from .emulator.state import IkawaEmulatedRoaster

    emulated_roaster = IkawaEmulatedRoaster()
    print("Starting IKAWA emulator in protocol-only mode (no BLE backend).")
    print("Create `simulate` file to drive roast session progression.")

    while True:
        # Keep emulator state logic alive for local protocol/app development.
        emulated_roaster.roaster.next_step()
        time.sleep(1)


def run():
    if os.getenv("IKAWA_PROTOCOL_ONLY", "").lower() in {"1", "true", "yes"}:
        return run_protocol_only()

    if platform.system().lower() != "linux":
        raise RuntimeError(
            "The BLE backend runs on Linux/BlueZ only. "
            "Run and debug this service in a Linux environment (native, VM, or container)."
        )

    from .bluetooth.controller import BLEPeripheral
    from .emulator.state import IkawaEmulatedRoaster

    adapter_module = importlib.import_module("bluezero.adapter")
    try:
        adapters = list(adapter_module.Adapter.available())
    except Exception as exc:
        raise RuntimeError(
            "BlueZ is not available on D-Bus. Ensure bluetoothd is running and "
            "the container has access to Linux Bluetooth resources."
        ) from exc

    if not adapters:
        raise RuntimeError(
            "No Bluetooth adapter found via BlueZ. "
            "For container runs, expose host Bluetooth or use a Linux VM with BLE hardware."
        )
    adapter_address = adapters[0].address

    emulated_roaster = IkawaEmulatedRoaster()
    ble_roaster = BLEPeripheral(adapter_address, emulated_roaster)
    ble_roaster.publish()


if __name__ == "__main__":
    run()
