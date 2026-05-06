import os

import IkawaCmd.protc_pb2 as ikawaCmd_pb2
import pandas as pd

from .helpers import RoastProfile


class RoasterState:
    def __init__(self):
        self.time = 0
        self.fan = int(50 * 2.55)
        self.fan_measured = int(50 * 12 / 60)

        self.simulating_roast = False
        self.simulating_roast_timer = 0
        self.start_roast_file = "./sim_session_exp3_feb26.csv"
        self.simulation_command_file = "./simulate"
        self.start_roast_file_index = 0
        self.simulated_roast_data = pd.DataFrame()

        if os.path.isfile(self.start_roast_file):
            self.simulated_roast_data = pd.read_csv(self.start_roast_file).dropna(axis=1).astype(int)
            self.simulated_roast_data.columns = list(
                map(lambda x: x[1:] if x[0] == " " else x, self.simulated_roast_data.columns)
            )
            self.state_from_simulation_idx(self.start_roast_file_index)
        else:
            print("No file found: " + self.start_roast_file)
            self.time = 0
            self.temp_above = 0
            self.fan = 0
            self.state = 0
            self.heater = 0
            self.p = 0
            self.i = 0
            self.d = 0
            self.setpoint = 0
            self.fan_measured = 0
            self.board_temp = 0
            self.temp_below = 0
            self.fan_rpm_measured = 0
            self.fan_rpm_setpoint = 0
            self.fan_i = 0
            self.fan_p = 0
            self.fan_d = 0
            self.fan_power = 0
            self.j = 0
            self.relay_state = 0
            self.pid_sensor = 0
            self.temp_above_filtered = 0
            self.temp_below_filtered = 0
            self.ror_above = 0
            self.ror_below = 0

        print("Initializing RoasterState")

    def next_step(self):
        if os.path.isfile(self.simulation_command_file):
            if self.start_roast_file_index >= len(self.simulated_roast_data):
                self.start_roast_file_index = 0
                os.remove(self.simulation_command_file)
            else:
                self.start_roast_file_index = self.start_roast_file_index + 5
        else:
            self.start_roast_file_index = 0

        self.state_from_simulation_idx(self.start_roast_file_index)

    def state_from_simulation_idx(self, idx):
        self.time = self.simulated_roast_data.iloc[idx]["time"]
        self.temp_above = self.simulated_roast_data.iloc[idx]["temp_above"]
        self.fan = self.simulated_roast_data.iloc[idx]["fan"]
        self.state = self.simulated_roast_data.iloc[idx]["state"]
        self.heater = self.simulated_roast_data.iloc[idx]["heater"]
        self.p = self.simulated_roast_data.iloc[idx]["p"]
        self.i = self.simulated_roast_data.iloc[idx]["i"]
        self.d = self.simulated_roast_data.iloc[idx]["d"]
        self.setpoint = self.simulated_roast_data.iloc[idx]["setpoint"]
        self.fan_measured = self.simulated_roast_data.iloc[idx]["fan_measured"]
        self.board_temp = self.simulated_roast_data.iloc[idx]["board_temp"]
        self.temp_below = self.simulated_roast_data.iloc[idx]["temp_below"]
        self.fan_rpm_measured = self.simulated_roast_data.iloc[idx]["fan_rpm_measured"]
        self.fan_rpm_setpoint = self.simulated_roast_data.iloc[idx]["fan_rpm_setpoint"]
        self.fan_i = self.simulated_roast_data.iloc[idx]["fan_i"]
        self.fan_p = self.simulated_roast_data.iloc[idx]["fan_p"]
        self.fan_d = self.simulated_roast_data.iloc[idx]["fan_d"]
        self.fan_power = self.simulated_roast_data.iloc[idx]["fan_power"]
        self.j = self.simulated_roast_data.iloc[idx]["j"]
        self.relay_state = self.simulated_roast_data.iloc[idx]["relay_state"]
        self.pid_sensor = self.simulated_roast_data.iloc[idx]["pid_sensor"]
        self.temp_above_filtered = self.simulated_roast_data.iloc[idx]["temp_above_filtered"]
        self.temp_below_filtered = self.simulated_roast_data.iloc[idx]["temp_below_filtered"]
        self.ror_above = self.simulated_roast_data.iloc[idx]["ror_above"]
        self.ror_below = self.simulated_roast_data.iloc[idx]["ror_below"]


class IkawaEmulatedRoaster:
    MACH_PROP_GET_TYPE = 2
    MACH_PROP_GET_ID = 3
    MACH_PROP_GET_SUPPORT_INFO = 23
    BOOTLOADER_GET_VERSION = 0
    HIST_GET_TOTAL_ROAST_COUNT = 13
    SETTING_GET = 17
    PROFILE_GET = 15
    PROFILE_SET = 16
    MACH_STATUS_GET_ERROR_VALUE = 10
    MACH_STATUS_GET_ALL_VALUE = 11

    def __init__(self):
        self.roaster = RoasterState()

    def process_command_from_app(self, message):
        try:
            decoded = ikawaCmd_pb2.Message().FromString(message)
            print(" seq: %d cmd_type %d" % (decoded.seq, decoded.cmd_type))
        except Exception as e:
            print("Error: Invalid Message Serialize ProtoBuf")
            print(e)
            return None

        respType = ikawaCmd_pb2.IkawaResponse()
        respType.seq = decoded.seq
        respType.resp = 1

        try:
            if decoded.cmd_type == self.MACH_PROP_GET_TYPE:
                respType.resp_mach_prop_type.type_ = 3
                respType.resp_mach_prop_type.variant = 0
            if decoded.cmd_type == self.MACH_PROP_GET_ID:
                respType.resp_mach_id.id_ = 800368
            if decoded.cmd_type == self.MACH_PROP_GET_SUPPORT_INFO:
                respType.resp_mach_prop_get_support_info.profile_schema = 2
            if decoded.cmd_type == self.BOOTLOADER_GET_VERSION:
                respType.resp_bootloader_get_version.version = 25
                respType.resp_bootloader_get_version.revision = "17-g1925dbd-DIRTY"
            if decoded.cmd_type == self.HIST_GET_TOTAL_ROAST_COUNT:
                respType.resp_hist_get_total_roast_count.total_roast_count = 5
            if decoded.cmd_type == self.PROFILE_SET:
                recv_profile = RoastProfile()
                recv_profile.from_proto(decoded)
                recv_profile.display_roast_profile()
                recv_profile.to_json_file("profile_set.json")
            if decoded.cmd_type == self.PROFILE_GET:
                last_roast_profile = RoastProfile()
                last_roast_profile.from_json("profile_get.json")
                last_roast_profile.display_roast_profile()
                respType = last_roast_profile.toProtoBuf(decoded.seq)
            if decoded.cmd_type == self.MACH_STATUS_GET_ERROR_VALUE:
                respType.resp_mach_status_get_error.error = 1
            if decoded.cmd_type == self.MACH_STATUS_GET_ALL_VALUE:
                respType.resp_mach_status_get_all.time = self.roaster.time
                respType.resp_mach_status_get_all.temp_above = self.roaster.temp_above
                respType.resp_mach_status_get_all.fan = self.roaster.fan
                respType.resp_mach_status_get_all.state = self.roaster.state
                respType.resp_mach_status_get_all.heater = self.roaster.heater
                respType.resp_mach_status_get_all.p = self.roaster.p
                respType.resp_mach_status_get_all.i = self.roaster.i
                respType.resp_mach_status_get_all.d = self.roaster.d
                respType.resp_mach_status_get_all.fan_measured = self.roaster.fan_measured
                respType.resp_mach_status_get_all.setpoint = self.roaster.setpoint
                respType.resp_mach_status_get_all.fan_i = self.roaster.fan_i
                respType.resp_mach_status_get_all.fan_p = self.roaster.fan_p
                respType.resp_mach_status_get_all.fan_d = self.roaster.fan_d
                respType.resp_mach_status_get_all.fan_power = self.roaster.fan_power
                respType.resp_mach_status_get_all.j = self.roaster.j
                respType.resp_mach_status_get_all.relay_state = self.roaster.relay_state
                respType.resp_mach_status_get_all.pid_sensor = self.roaster.pid_sensor
                respType.resp_mach_status_get_all.temp_above_filtered = self.roaster.temp_above_filtered
                respType.resp_mach_status_get_all.temp_below_filtered = self.roaster.temp_below_filtered
                respType.resp_mach_status_get_all.ror_above = self.roaster.ror_above
                respType.resp_mach_status_get_all.ror_below = self.roaster.ror_below
                respType.resp_mach_status_get_all.temp_below = self.roaster.temp_below
                self.roaster.next_step()
            if decoded.cmd_type == self.SETTING_GET:
                requested_field = decoded.setting_get.field
                respType.resp_setting_get.field = requested_field
                if requested_field == 24:
                    respType.resp_setting_get.field = 5
                if requested_field == 153:
                    respType.resp_setting_get.field = 230
                if requested_field == 154:
                    respType.resp_setting_get.field = 1
                if requested_field == 155:
                    respType.resp_setting_get.field = 3
                if requested_field == 158:
                    respType.resp_setting_get.field = 0
                if requested_field == 171:
                    respType.resp_setting_get.field = 0
                if requested_field == 174:
                    respType.resp_setting_get.field = 0
                if requested_field == 175:
                    respType.resp_setting_get.field = 5
        except Exception as e:
            print("Error: Invalid Message")
            print(e)
            return None

        return respType
