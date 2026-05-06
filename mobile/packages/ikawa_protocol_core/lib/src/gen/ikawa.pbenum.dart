// This is a generated file - do not edit.
//
// Generated from ikawa.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class IkawaResponse_Resp extends $pb.ProtobufEnum {
  static const IkawaResponse_Resp A =
      IkawaResponse_Resp._(0, _omitEnumNames ? '' : 'A');
  static const IkawaResponse_Resp OK =
      IkawaResponse_Resp._(1, _omitEnumNames ? '' : 'OK');
  static const IkawaResponse_Resp BOOTLOADER_GET_VERSION =
      IkawaResponse_Resp._(3, _omitEnumNames ? '' : 'BOOTLOADER_GET_VERSION');
  static const IkawaResponse_Resp MACH_PROP_TYPE =
      IkawaResponse_Resp._(4, _omitEnumNames ? '' : 'MACH_PROP_TYPE');
  static const IkawaResponse_Resp MACH_ID =
      IkawaResponse_Resp._(5, _omitEnumNames ? '' : 'MACH_ID');
  static const IkawaResponse_Resp MACH_STATUS_GET_ERROR =
      IkawaResponse_Resp._(12, _omitEnumNames ? '' : 'MACH_STATUS_GET_ERROR');
  static const IkawaResponse_Resp MACH_STATUS_GET_ALL =
      IkawaResponse_Resp._(13, _omitEnumNames ? '' : 'MACH_STATUS_GET_ALL');
  static const IkawaResponse_Resp HIST_GET_PROFILE_ROAST_COUNT =
      IkawaResponse_Resp._(
          14, _omitEnumNames ? '' : 'HIST_GET_PROFILE_ROAST_COUNT');
  static const IkawaResponse_Resp HIST_GET_TOTAL_ROAST_COUNT =
      IkawaResponse_Resp._(
          15, _omitEnumNames ? '' : 'HIST_GET_TOTAL_ROAST_COUNT');
  static const IkawaResponse_Resp PROFILE_GET =
      IkawaResponse_Resp._(16, _omitEnumNames ? '' : 'PROFILE_GET');
  static const IkawaResponse_Resp SETTING_GET =
      IkawaResponse_Resp._(17, _omitEnumNames ? '' : 'SETTING_GET');
  static const IkawaResponse_Resp SETTING_GET_INFO =
      IkawaResponse_Resp._(18, _omitEnumNames ? '' : 'SETTING_GET_INFO');
  static const IkawaResponse_Resp SETTING_GET_LIST =
      IkawaResponse_Resp._(19, _omitEnumNames ? '' : 'SETTING_GET_LIST');
  static const IkawaResponse_Resp MACH_STATUS_GET_SENSORS =
      IkawaResponse_Resp._(20, _omitEnumNames ? '' : 'MACH_STATUS_GET_SENSORS');
  static const IkawaResponse_Resp MACH_PROP_GET_SUPPORT_INFO =
      IkawaResponse_Resp._(
          21, _omitEnumNames ? '' : 'MACH_PROP_GET_SUPPORT_INFO');
  static const IkawaResponse_Resp TEST_STATUS_GET =
      IkawaResponse_Resp._(22, _omitEnumNames ? '' : 'TEST_STATUS_GET');
  static const IkawaResponse_Resp MACH_STATUS_GET_TIME =
      IkawaResponse_Resp._(23, _omitEnumNames ? '' : 'MACH_STATUS_GET_TIME');
  static const IkawaResponse_Resp MACH_PROP_GET_NAME =
      IkawaResponse_Resp._(24, _omitEnumNames ? '' : 'MACH_PROP_GET_NAME');
  static const IkawaResponse_Resp ROAST_SUMMARY_GET =
      IkawaResponse_Resp._(25, _omitEnumNames ? '' : 'ROAST_SUMMARY_GET');

  static const $core.List<IkawaResponse_Resp> values = <IkawaResponse_Resp>[
    A,
    OK,
    BOOTLOADER_GET_VERSION,
    MACH_PROP_TYPE,
    MACH_ID,
    MACH_STATUS_GET_ERROR,
    MACH_STATUS_GET_ALL,
    HIST_GET_PROFILE_ROAST_COUNT,
    HIST_GET_TOTAL_ROAST_COUNT,
    PROFILE_GET,
    SETTING_GET,
    SETTING_GET_INFO,
    SETTING_GET_LIST,
    MACH_STATUS_GET_SENSORS,
    MACH_PROP_GET_SUPPORT_INFO,
    TEST_STATUS_GET,
    MACH_STATUS_GET_TIME,
    MACH_PROP_GET_NAME,
    ROAST_SUMMARY_GET,
  ];

  static final $core.List<IkawaResponse_Resp?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 25);
  static IkawaResponse_Resp? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const IkawaResponse_Resp._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
