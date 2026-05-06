// This is a generated file - do not edit.
//
// Generated from ikawa.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use messageDescriptor instead')
const Message$json = {
  '1': 'Message',
  '2': [
    {'1': 'cmd_type', '3': 1, '4': 2, '5': 5, '10': 'cmdType'},
    {'1': 'seq', '3': 2, '4': 2, '5': 5, '10': 'seq'},
    {
      '1': 'profile_set',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.ikawa_cmd.CmdProfileSet',
      '10': 'profileSet'
    },
    {
      '1': 'setting_get',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.ikawa_cmd.CmdSettingGet',
      '10': 'settingGet'
    },
  ],
};

/// Descriptor for `Message`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageDescriptor = $convert.base64Decode(
    'CgdNZXNzYWdlEhkKCGNtZF90eXBlGAEgAigFUgdjbWRUeXBlEhAKA3NlcRgCIAIoBVIDc2VxEj'
    'kKC3Byb2ZpbGVfc2V0GAQgASgLMhguaWthd2FfY21kLkNtZFByb2ZpbGVTZXRSCnByb2ZpbGVT'
    'ZXQSOQoLc2V0dGluZ19nZXQYBSABKAsyGC5pa2F3YV9jbWQuQ21kU2V0dGluZ0dldFIKc2V0dG'
    'luZ0dldA==');

@$core.Deprecated('Use cmdProfileSetDescriptor instead')
const CmdProfileSet$json = {
  '1': 'CmdProfileSet',
  '2': [
    {
      '1': 'profile',
      '3': 1,
      '4': 2,
      '5': 11,
      '6': '.ikawa_cmd.RoastProfile',
      '10': 'profile'
    },
  ],
};

/// Descriptor for `CmdProfileSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cmdProfileSetDescriptor = $convert.base64Decode(
    'Cg1DbWRQcm9maWxlU2V0EjEKB3Byb2ZpbGUYASACKAsyFy5pa2F3YV9jbWQuUm9hc3RQcm9maW'
    'xlUgdwcm9maWxl');

@$core.Deprecated('Use cmdSettingGetDescriptor instead')
const CmdSettingGet$json = {
  '1': 'CmdSettingGet',
  '2': [
    {'1': 'field', '3': 1, '4': 2, '5': 5, '10': 'field'},
  ],
};

/// Descriptor for `CmdSettingGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cmdSettingGetDescriptor = $convert
    .base64Decode('Cg1DbWRTZXR0aW5nR2V0EhQKBWZpZWxkGAEgAigFUgVmaWVsZA==');

@$core.Deprecated('Use ikawaResponseDescriptor instead')
const IkawaResponse$json = {
  '1': 'IkawaResponse',
  '2': [
    {'1': 'seq', '3': 1, '4': 2, '5': 5, '10': 'seq'},
    {
      '1': 'resp',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.ikawa_cmd.IkawaResponse.Resp',
      '10': 'resp'
    },
    {
      '1': 'resp_bootloader_get_version',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.ikawa_cmd.RespBootloaderGetVersion',
      '10': 'respBootloaderGetVersion'
    },
    {
      '1': 'resp_mach_prop_type',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.ikawa_cmd.RespMachPropGetType',
      '10': 'respMachPropType'
    },
    {
      '1': 'resp_mach_id',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.ikawa_cmd.RespMachPropGetID',
      '10': 'respMachId'
    },
    {
      '1': 'resp_mach_status_get_error',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.ikawa_cmd.RespMachStatusGetError',
      '10': 'respMachStatusGetError'
    },
    {
      '1': 'resp_mach_status_get_all',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.ikawa_cmd.RespMachStatusGetAll',
      '10': 'respMachStatusGetAll'
    },
    {
      '1': 'resp_hist_get_total_roast_count',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.ikawa_cmd.RespHistGetTotalRoastCount',
      '10': 'respHistGetTotalRoastCount'
    },
    {
      '1': 'resp_profile_get',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.ikawa_cmd.RespProfileGet',
      '10': 'respProfileGet'
    },
    {
      '1': 'resp_setting_get',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.ikawa_cmd.RespSettingGet',
      '10': 'respSettingGet'
    },
    {
      '1': 'resp_mach_prop_get_support_info',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.ikawa_cmd.RespMachPropGetSupportInfo',
      '10': 'respMachPropGetSupportInfo'
    },
  ],
  '4': [IkawaResponse_Resp$json],
};

@$core.Deprecated('Use ikawaResponseDescriptor instead')
const IkawaResponse_Resp$json = {
  '1': 'Resp',
  '2': [
    {'1': 'A', '2': 0},
    {'1': 'OK', '2': 1},
    {'1': 'BOOTLOADER_GET_VERSION', '2': 3},
    {'1': 'MACH_PROP_TYPE', '2': 4},
    {'1': 'MACH_ID', '2': 5},
    {'1': 'MACH_STATUS_GET_ERROR', '2': 12},
    {'1': 'MACH_STATUS_GET_ALL', '2': 13},
    {'1': 'HIST_GET_PROFILE_ROAST_COUNT', '2': 14},
    {'1': 'HIST_GET_TOTAL_ROAST_COUNT', '2': 15},
    {'1': 'PROFILE_GET', '2': 16},
    {'1': 'SETTING_GET', '2': 17},
    {'1': 'SETTING_GET_INFO', '2': 18},
    {'1': 'SETTING_GET_LIST', '2': 19},
    {'1': 'MACH_STATUS_GET_SENSORS', '2': 20},
    {'1': 'MACH_PROP_GET_SUPPORT_INFO', '2': 21},
    {'1': 'TEST_STATUS_GET', '2': 22},
    {'1': 'MACH_STATUS_GET_TIME', '2': 23},
    {'1': 'MACH_PROP_GET_NAME', '2': 24},
    {'1': 'ROAST_SUMMARY_GET', '2': 25},
  ],
};

/// Descriptor for `IkawaResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ikawaResponseDescriptor = $convert.base64Decode(
    'Cg1Ja2F3YVJlc3BvbnNlEhAKA3NlcRgBIAIoBVIDc2VxEjEKBHJlc3AYAiABKA4yHS5pa2F3YV'
    '9jbWQuSWthd2FSZXNwb25zZS5SZXNwUgRyZXNwEmIKG3Jlc3BfYm9vdGxvYWRlcl9nZXRfdmVy'
    'c2lvbhgDIAEoCzIjLmlrYXdhX2NtZC5SZXNwQm9vdGxvYWRlckdldFZlcnNpb25SGHJlc3BCb2'
    '90bG9hZGVyR2V0VmVyc2lvbhJNChNyZXNwX21hY2hfcHJvcF90eXBlGAQgASgLMh4uaWthd2Ff'
    'Y21kLlJlc3BNYWNoUHJvcEdldFR5cGVSEHJlc3BNYWNoUHJvcFR5cGUSPgoMcmVzcF9tYWNoX2'
    'lkGAUgASgLMhwuaWthd2FfY21kLlJlc3BNYWNoUHJvcEdldElEUgpyZXNwTWFjaElkEl0KGnJl'
    'c3BfbWFjaF9zdGF0dXNfZ2V0X2Vycm9yGAwgASgLMiEuaWthd2FfY21kLlJlc3BNYWNoU3RhdH'
    'VzR2V0RXJyb3JSFnJlc3BNYWNoU3RhdHVzR2V0RXJyb3ISVwoYcmVzcF9tYWNoX3N0YXR1c19n'
    'ZXRfYWxsGA0gASgLMh8uaWthd2FfY21kLlJlc3BNYWNoU3RhdHVzR2V0QWxsUhRyZXNwTWFjaF'
    'N0YXR1c0dldEFsbBJqCh9yZXNwX2hpc3RfZ2V0X3RvdGFsX3JvYXN0X2NvdW50GA8gASgLMiUu'
    'aWthd2FfY21kLlJlc3BIaXN0R2V0VG90YWxSb2FzdENvdW50UhpyZXNwSGlzdEdldFRvdGFsUm'
    '9hc3RDb3VudBJDChByZXNwX3Byb2ZpbGVfZ2V0GBAgASgLMhkuaWthd2FfY21kLlJlc3BQcm9m'
    'aWxlR2V0Ug5yZXNwUHJvZmlsZUdldBJDChByZXNwX3NldHRpbmdfZ2V0GBEgASgLMhkuaWthd2'
    'FfY21kLlJlc3BTZXR0aW5nR2V0Ug5yZXNwU2V0dGluZ0dldBJqCh9yZXNwX21hY2hfcHJvcF9n'
    'ZXRfc3VwcG9ydF9pbmZvGBUgASgLMiUuaWthd2FfY21kLlJlc3BNYWNoUHJvcEdldFN1cHBvcn'
    'RJbmZvUhpyZXNwTWFjaFByb3BHZXRTdXBwb3J0SW5mbyKxAwoEUmVzcBIFCgFBEAASBgoCT0sQ'
    'ARIaChZCT09UTE9BREVSX0dFVF9WRVJTSU9OEAMSEgoOTUFDSF9QUk9QX1RZUEUQBBILCgdNQU'
    'NIX0lEEAUSGQoVTUFDSF9TVEFUVVNfR0VUX0VSUk9SEAwSFwoTTUFDSF9TVEFUVVNfR0VUX0FM'
    'TBANEiAKHEhJU1RfR0VUX1BST0ZJTEVfUk9BU1RfQ09VTlQQDhIeChpISVNUX0dFVF9UT1RBTF'
    '9ST0FTVF9DT1VOVBAPEg8KC1BST0ZJTEVfR0VUEBASDwoLU0VUVElOR19HRVQQERIUChBTRVRU'
    'SU5HX0dFVF9JTkZPEBISFAoQU0VUVElOR19HRVRfTElTVBATEhsKF01BQ0hfU1RBVFVTX0dFVF'
    '9TRU5TT1JTEBQSHgoaTUFDSF9QUk9QX0dFVF9TVVBQT1JUX0lORk8QFRITCg9URVNUX1NUQVRV'
    'U19HRVQQFhIYChRNQUNIX1NUQVRVU19HRVRfVElNRRAXEhYKEk1BQ0hfUFJPUF9HRVRfTkFNRR'
    'AYEhUKEVJPQVNUX1NVTU1BUllfR0VUEBk=');

@$core.Deprecated('Use respMachStatusGetAllDescriptor instead')
const RespMachStatusGetAll$json = {
  '1': 'RespMachStatusGetAll',
  '2': [
    {'1': 'time', '3': 1, '4': 2, '5': 5, '10': 'time'},
    {'1': 'temp_above', '3': 2, '4': 1, '5': 5, '10': 'tempAbove'},
    {'1': 'fan', '3': 3, '4': 2, '5': 5, '10': 'fan'},
    {'1': 'state', '3': 4, '4': 2, '5': 5, '10': 'state'},
    {'1': 'heater', '3': 5, '4': 2, '5': 5, '10': 'heater'},
    {'1': 'p', '3': 6, '4': 2, '5': 5, '10': 'p'},
    {'1': 'i', '3': 7, '4': 2, '5': 5, '10': 'i'},
    {'1': 'd', '3': 8, '4': 2, '5': 5, '10': 'd'},
    {'1': 'setpoint', '3': 9, '4': 2, '5': 5, '10': 'setpoint'},
    {'1': 'fan_measured', '3': 10, '4': 2, '5': 5, '10': 'fanMeasured'},
    {'1': 'board_temp', '3': 11, '4': 1, '5': 5, '10': 'boardTemp'},
    {'1': 'temp_below', '3': 12, '4': 1, '5': 5, '10': 'tempBelow'},
    {'1': 'fan_rpm_measured', '3': 13, '4': 1, '5': 5, '10': 'fanRpmMeasured'},
    {'1': 'fan_rpm_setpoint', '3': 14, '4': 1, '5': 5, '10': 'fanRpmSetpoint'},
    {'1': 'fan_p', '3': 15, '4': 1, '5': 5, '10': 'fanP'},
    {'1': 'fan_i', '3': 16, '4': 1, '5': 5, '10': 'fanI'},
    {'1': 'fan_d', '3': 17, '4': 1, '5': 5, '10': 'fanD'},
    {'1': 'fan_power', '3': 18, '4': 1, '5': 5, '10': 'fanPower'},
    {'1': 'j', '3': 19, '4': 1, '5': 5, '10': 'j'},
    {'1': 'relay_state', '3': 20, '4': 1, '5': 5, '10': 'relayState'},
    {'1': 'pid_sensor', '3': 21, '4': 1, '5': 5, '10': 'pidSensor'},
    {
      '1': 'temp_above_filtered',
      '3': 22,
      '4': 1,
      '5': 5,
      '10': 'tempAboveFiltered'
    },
    {
      '1': 'temp_below_filtered',
      '3': 23,
      '4': 1,
      '5': 5,
      '10': 'tempBelowFiltered'
    },
    {'1': 'ror_above', '3': 24, '4': 1, '5': 5, '10': 'rorAbove'},
    {'1': 'ror_below', '3': 25, '4': 1, '5': 5, '10': 'rorBelow'},
  ],
};

/// Descriptor for `RespMachStatusGetAll`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List respMachStatusGetAllDescriptor = $convert.base64Decode(
    'ChRSZXNwTWFjaFN0YXR1c0dldEFsbBISCgR0aW1lGAEgAigFUgR0aW1lEh0KCnRlbXBfYWJvdm'
    'UYAiABKAVSCXRlbXBBYm92ZRIQCgNmYW4YAyACKAVSA2ZhbhIUCgVzdGF0ZRgEIAIoBVIFc3Rh'
    'dGUSFgoGaGVhdGVyGAUgAigFUgZoZWF0ZXISDAoBcBgGIAIoBVIBcBIMCgFpGAcgAigFUgFpEg'
    'wKAWQYCCACKAVSAWQSGgoIc2V0cG9pbnQYCSACKAVSCHNldHBvaW50EiEKDGZhbl9tZWFzdXJl'
    'ZBgKIAIoBVILZmFuTWVhc3VyZWQSHQoKYm9hcmRfdGVtcBgLIAEoBVIJYm9hcmRUZW1wEh0KCn'
    'RlbXBfYmVsb3cYDCABKAVSCXRlbXBCZWxvdxIoChBmYW5fcnBtX21lYXN1cmVkGA0gASgFUg5m'
    'YW5ScG1NZWFzdXJlZBIoChBmYW5fcnBtX3NldHBvaW50GA4gASgFUg5mYW5ScG1TZXRwb2ludB'
    'ITCgVmYW5fcBgPIAEoBVIEZmFuUBITCgVmYW5faRgQIAEoBVIEZmFuSRITCgVmYW5fZBgRIAEo'
    'BVIEZmFuRBIbCglmYW5fcG93ZXIYEiABKAVSCGZhblBvd2VyEgwKAWoYEyABKAVSAWoSHwoLcm'
    'VsYXlfc3RhdGUYFCABKAVSCnJlbGF5U3RhdGUSHQoKcGlkX3NlbnNvchgVIAEoBVIJcGlkU2Vu'
    'c29yEi4KE3RlbXBfYWJvdmVfZmlsdGVyZWQYFiABKAVSEXRlbXBBYm92ZUZpbHRlcmVkEi4KE3'
    'RlbXBfYmVsb3dfZmlsdGVyZWQYFyABKAVSEXRlbXBCZWxvd0ZpbHRlcmVkEhsKCXJvcl9hYm92'
    'ZRgYIAEoBVIIcm9yQWJvdmUSGwoJcm9yX2JlbG93GBkgASgFUghyb3JCZWxvdw==');

@$core.Deprecated('Use respMachStatusGetErrorDescriptor instead')
const RespMachStatusGetError$json = {
  '1': 'RespMachStatusGetError',
  '2': [
    {'1': 'error', '3': 1, '4': 2, '5': 5, '10': 'error'},
  ],
};

/// Descriptor for `RespMachStatusGetError`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List respMachStatusGetErrorDescriptor =
    $convert.base64Decode(
        'ChZSZXNwTWFjaFN0YXR1c0dldEVycm9yEhQKBWVycm9yGAEgAigFUgVlcnJvcg==');

@$core.Deprecated('Use respProfileGetDescriptor instead')
const RespProfileGet$json = {
  '1': 'RespProfileGet',
  '2': [
    {
      '1': 'profile',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.ikawa_cmd.RoastProfile',
      '10': 'profile'
    },
  ],
};

/// Descriptor for `RespProfileGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List respProfileGetDescriptor = $convert.base64Decode(
    'Cg5SZXNwUHJvZmlsZUdldBIxCgdwcm9maWxlGAEgASgLMhcuaWthd2FfY21kLlJvYXN0UHJvZm'
    'lsZVIHcHJvZmlsZQ==');

@$core.Deprecated('Use roastProfileDescriptor instead')
const RoastProfile$json = {
  '1': 'RoastProfile',
  '2': [
    {'1': 'schema', '3': 1, '4': 1, '5': 5, '10': 'schema'},
    {'1': 'id', '3': 2, '4': 1, '5': 12, '10': 'id'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'temp_points',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.ikawa_cmd.TempPoint',
      '10': 'tempPoints'
    },
    {
      '1': 'fan_points',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.ikawa_cmd.FanPoint',
      '10': 'fanPoints'
    },
    {'1': 'temp_sensor', '3': 6, '4': 1, '5': 5, '10': 'tempSensor'},
    {
      '1': 'cooldown_fan',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.ikawa_cmd.FanPoint',
      '10': 'cooldownFan'
    },
    {'1': 'coffee_name', '3': 8, '4': 1, '5': 9, '10': 'coffeeName'},
    {'1': 'user_id', '3': 9, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'coffee_id', '3': 10, '4': 1, '5': 9, '10': 'coffeeId'},
    {'1': 'coffee_web_url', '3': 11, '4': 1, '5': 9, '10': 'coffeeWebUrl'},
    {'1': 'profile_type', '3': 12, '4': 1, '5': 9, '10': 'profileType'},
  ],
};

/// Descriptor for `RoastProfile`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roastProfileDescriptor = $convert.base64Decode(
    'CgxSb2FzdFByb2ZpbGUSFgoGc2NoZW1hGAEgASgFUgZzY2hlbWESDgoCaWQYAiABKAxSAmlkEh'
    'IKBG5hbWUYAyABKAlSBG5hbWUSNQoLdGVtcF9wb2ludHMYBCADKAsyFC5pa2F3YV9jbWQuVGVt'
    'cFBvaW50Ugp0ZW1wUG9pbnRzEjIKCmZhbl9wb2ludHMYBSADKAsyEy5pa2F3YV9jbWQuRmFuUG'
    '9pbnRSCWZhblBvaW50cxIfCgt0ZW1wX3NlbnNvchgGIAEoBVIKdGVtcFNlbnNvchI2Cgxjb29s'
    'ZG93bl9mYW4YByABKAsyEy5pa2F3YV9jbWQuRmFuUG9pbnRSC2Nvb2xkb3duRmFuEh8KC2NvZm'
    'ZlZV9uYW1lGAggASgJUgpjb2ZmZWVOYW1lEhcKB3VzZXJfaWQYCSABKAlSBnVzZXJJZBIbCglj'
    'b2ZmZWVfaWQYCiABKAlSCGNvZmZlZUlkEiQKDmNvZmZlZV93ZWJfdXJsGAsgASgJUgxjb2ZmZW'
    'VXZWJVcmwSIQoMcHJvZmlsZV90eXBlGAwgASgJUgtwcm9maWxlVHlwZQ==');

@$core.Deprecated('Use fanPointDescriptor instead')
const FanPoint$json = {
  '1': 'FanPoint',
  '2': [
    {'1': 'time', '3': 1, '4': 1, '5': 5, '10': 'time'},
    {'1': 'power', '3': 2, '4': 1, '5': 5, '10': 'power'},
  ],
};

/// Descriptor for `FanPoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fanPointDescriptor = $convert.base64Decode(
    'CghGYW5Qb2ludBISCgR0aW1lGAEgASgFUgR0aW1lEhQKBXBvd2VyGAIgASgFUgVwb3dlcg==');

@$core.Deprecated('Use tempPointDescriptor instead')
const TempPoint$json = {
  '1': 'TempPoint',
  '2': [
    {'1': 'time', '3': 1, '4': 1, '5': 5, '10': 'time'},
    {'1': 'temp', '3': 2, '4': 1, '5': 5, '10': 'temp'},
  ],
};

/// Descriptor for `TempPoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tempPointDescriptor = $convert.base64Decode(
    'CglUZW1wUG9pbnQSEgoEdGltZRgBIAEoBVIEdGltZRISCgR0ZW1wGAIgASgFUgR0ZW1w');

@$core.Deprecated('Use respSettingGetDescriptor instead')
const RespSettingGet$json = {
  '1': 'RespSettingGet',
  '2': [
    {'1': 'field', '3': 1, '4': 1, '5': 5, '10': 'field'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
};

/// Descriptor for `RespSettingGet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List respSettingGetDescriptor = $convert.base64Decode(
    'Cg5SZXNwU2V0dGluZ0dldBIUCgVmaWVsZBgBIAEoBVIFZmllbGQSFAoFdmFsdWUYAiABKAVSBX'
    'ZhbHVl');

@$core.Deprecated('Use respHistGetTotalRoastCountDescriptor instead')
const RespHistGetTotalRoastCount$json = {
  '1': 'RespHistGetTotalRoastCount',
  '2': [
    {'1': 'total_roast_count', '3': 1, '4': 2, '5': 5, '10': 'totalRoastCount'},
  ],
};

/// Descriptor for `RespHistGetTotalRoastCount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List respHistGetTotalRoastCountDescriptor =
    $convert.base64Decode(
        'ChpSZXNwSGlzdEdldFRvdGFsUm9hc3RDb3VudBIqChF0b3RhbF9yb2FzdF9jb3VudBgBIAIoBV'
        'IPdG90YWxSb2FzdENvdW50');

@$core.Deprecated('Use respMachPropGetSupportInfoDescriptor instead')
const RespMachPropGetSupportInfo$json = {
  '1': 'RespMachPropGetSupportInfo',
  '2': [
    {'1': 'profile_schema', '3': 1, '4': 2, '5': 5, '10': 'profileSchema'},
  ],
};

/// Descriptor for `RespMachPropGetSupportInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List respMachPropGetSupportInfoDescriptor =
    $convert.base64Decode(
        'ChpSZXNwTWFjaFByb3BHZXRTdXBwb3J0SW5mbxIlCg5wcm9maWxlX3NjaGVtYRgBIAIoBVINcH'
        'JvZmlsZVNjaGVtYQ==');

@$core.Deprecated('Use respBootloaderGetVersionDescriptor instead')
const RespBootloaderGetVersion$json = {
  '1': 'RespBootloaderGetVersion',
  '2': [
    {'1': 'version', '3': 1, '4': 2, '5': 5, '10': 'version'},
    {'1': 'revision', '3': 2, '4': 2, '5': 9, '10': 'revision'},
  ],
};

/// Descriptor for `RespBootloaderGetVersion`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List respBootloaderGetVersionDescriptor =
    $convert.base64Decode(
        'ChhSZXNwQm9vdGxvYWRlckdldFZlcnNpb24SGAoHdmVyc2lvbhgBIAIoBVIHdmVyc2lvbhIaCg'
        'hyZXZpc2lvbhgCIAIoCVIIcmV2aXNpb24=');

@$core.Deprecated('Use respMachPropGetTypeDescriptor instead')
const RespMachPropGetType$json = {
  '1': 'RespMachPropGetType',
  '2': [
    {'1': 'type_', '3': 1, '4': 2, '5': 5, '10': 'type'},
    {'1': 'variant', '3': 2, '4': 2, '5': 5, '10': 'variant'},
  ],
};

/// Descriptor for `RespMachPropGetType`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List respMachPropGetTypeDescriptor = $convert.base64Decode(
    'ChNSZXNwTWFjaFByb3BHZXRUeXBlEhMKBXR5cGVfGAEgAigFUgR0eXBlEhgKB3ZhcmlhbnQYAi'
    'ACKAVSB3ZhcmlhbnQ=');

@$core.Deprecated('Use respMachPropGetIDDescriptor instead')
const RespMachPropGetID$json = {
  '1': 'RespMachPropGetID',
  '2': [
    {'1': 'id_', '3': 1, '4': 2, '5': 5, '10': 'id'},
  ],
};

/// Descriptor for `RespMachPropGetID`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List respMachPropGetIDDescriptor =
    $convert.base64Decode('ChFSZXNwTWFjaFByb3BHZXRJRBIPCgNpZF8YASACKAVSAmlk');
