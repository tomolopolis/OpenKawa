This summary outlines the technical and design roadmap for your Flutter-based Ikawa Home replacement app, designed to keep the hardware functional and powerful after the official app's sunset in 2026.

## 🎨 UI & UX Perspective
*Focus: Progressive Disclosure (Simple for beginners, data-rich for pros).*
 * **Dual-Axis Charting:** * **Primary Y-Axis:** Temperature profile (Inlet Temp) represented as a bold solid line.
   * **Secondary Y-Axis:** Rate of Rise (RoR) represented as a thinner, smoother line.
   * **Normalization:** Use fl_chart with scaled values (e.g., RoR × 10) to display both on one graph.
 * **Set Point Interaction:** * Visual "nodes" on the profile curve that can be dragged to define the roast path.
   * Interpolated paths using Splines/Bezier curves to show the predicted machine behavior.
 * **Responsive Layout:**
   * **Mobile (Portrait):** Minimalist view with large "Start/Stop" and "Mark First Crack" buttons.
   * **Mobile (Landscape):** Automatically expands to the full Pro-Dashboard with the RoR curve.
   * **Tablet:** "Command Center" view with persistent sidebars for bean metrics and live stats.
 * **Event Marking:** Large, accessible button to mark **First Crack (FC)**, triggering a vertical timeline marker and a secondary "Development Timer."
 * **Live DTR% Gauge:** A real-time visual indicator of the Development Time Ratio, changing color as it hits the "Gold Zone" (15%–25%).

## ⚙️ Backend & Feature Perspective
*Focus: Robust data processing and hardware communication.*
 * **BLE Protocol (Bluetooth Low Energy):**
   * Integration of flutter_blue_plus for real-time telemetry (Inlet Temp, Fan Speed, Heater Power).
   * Profile Handshake: Logic to "chunk" and upload Time/Temp/Fan set point packets to the machine's buffer.
 * **The "RoR" Engine:**
   * **Stream Transformation:** A StreamTransformer to calculate \Delta T / \Delta t from raw BLE data.
   * **Smoothing Algorithms:** Implementation of Moving Averages or Kalman Filters to remove sensor jitter from the RoR curve.
 * **Data Models:**
   * **Green Bean Library:** Persistent storage (Isar/Hive) for Density (g/ml), Moisture (10-12\%), and Bean Size.
   * **Validation Logic:** A "Safety Guard" that prevents users from sending physically impossible curves (e.g., heat spikes the Ikawa heater can't achieve).
 * **Legacy Import:** Ability to parse and convert old .ikawa or .json files into the app's internal format.

## 🔌 Extra Integration Features
*Focus: Community growth and hardware enhancement.*
 * **External Sensor Support (The "Multiplexer"):**
   * Ability to connect a secondary BLE device (e.g., **BlueTherm One** or **Mastech/Center** meters) to plot true "Bean Temperature" alongside the Ikawa's "Inlet Temperature."
 * **Calculated Bean Temp (Virtual Probe):**
   * A software-only mathematical offset to estimate actual bean temperature for users without external hardware.
 * **Export & Compatibility:**
   * Feature to export roast logs as **Artisan-compatible CSVs**, allowing for deep desktop analysis.
 * **Proactive Roasting Assistant:**
   * **Density-Aware Alerts:** The app monitors the RoR and warns the user if dense beans are "stalling" based on the pre-roast data provided.
   * **Flick Warning:** Haptic/Visual alerts if the RoR spikes at the end of a roast (exothermic phase).
 * **Open Source Community:** A codebase designed for community contribution to ensure the Ikawa Home hardware lives on indefinitely.
**Next Steps for Development:**
 1. Establish a stable BLE handshake using flutter_blue_plus.
 2. Build the fl_chart base with dual-axis normalization.
 3. Implement the Simple Moving Average (SMA) logic for the RoR stream.
