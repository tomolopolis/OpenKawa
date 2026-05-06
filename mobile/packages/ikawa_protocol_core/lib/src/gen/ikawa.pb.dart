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

import 'ikawa.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'ikawa.pbenum.dart';

class Message extends $pb.GeneratedMessage {
  factory Message({
    $core.int? cmdType,
    $core.int? seq,
    CmdProfileSet? profileSet,
    CmdSettingGet? settingGet,
  }) {
    final result = create();
    if (cmdType != null) result.cmdType = cmdType;
    if (seq != null) result.seq = seq;
    if (profileSet != null) result.profileSet = profileSet;
    if (settingGet != null) result.settingGet = settingGet;
    return result;
  }

  Message._();

  factory Message.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Message.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Message',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ikawa_cmd'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'cmdType', fieldType: $pb.PbFieldType.Q3)
    ..aI(2, _omitFieldNames ? '' : 'seq', fieldType: $pb.PbFieldType.Q3)
    ..aOM<CmdProfileSet>(4, _omitFieldNames ? '' : 'profileSet',
        subBuilder: CmdProfileSet.create)
    ..aOM<CmdSettingGet>(5, _omitFieldNames ? '' : 'settingGet',
        subBuilder: CmdSettingGet.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Message clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Message copyWith(void Function(Message) updates) =>
      super.copyWith((message) => updates(message as Message)) as Message;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Message create() => Message._();
  @$core.override
  Message createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Message getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Message>(create);
  static Message? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get cmdType => $_getIZ(0);
  @$pb.TagNumber(1)
  set cmdType($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCmdType() => $_has(0);
  @$pb.TagNumber(1)
  void clearCmdType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get seq => $_getIZ(1);
  @$pb.TagNumber(2)
  set seq($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSeq() => $_has(1);
  @$pb.TagNumber(2)
  void clearSeq() => $_clearField(2);

  @$pb.TagNumber(4)
  CmdProfileSet get profileSet => $_getN(2);
  @$pb.TagNumber(4)
  set profileSet(CmdProfileSet value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasProfileSet() => $_has(2);
  @$pb.TagNumber(4)
  void clearProfileSet() => $_clearField(4);
  @$pb.TagNumber(4)
  CmdProfileSet ensureProfileSet() => $_ensure(2);

  @$pb.TagNumber(5)
  CmdSettingGet get settingGet => $_getN(3);
  @$pb.TagNumber(5)
  set settingGet(CmdSettingGet value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSettingGet() => $_has(3);
  @$pb.TagNumber(5)
  void clearSettingGet() => $_clearField(5);
  @$pb.TagNumber(5)
  CmdSettingGet ensureSettingGet() => $_ensure(3);
}

class CmdProfileSet extends $pb.GeneratedMessage {
  factory CmdProfileSet({
    RoastProfile? profile,
  }) {
    final result = create();
    if (profile != null) result.profile = profile;
    return result;
  }

  CmdProfileSet._();

  factory CmdProfileSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CmdProfileSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CmdProfileSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ikawa_cmd'),
      createEmptyInstance: create)
    ..aQM<RoastProfile>(1, _omitFieldNames ? '' : 'profile',
        subBuilder: RoastProfile.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CmdProfileSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CmdProfileSet copyWith(void Function(CmdProfileSet) updates) =>
      super.copyWith((message) => updates(message as CmdProfileSet))
          as CmdProfileSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CmdProfileSet create() => CmdProfileSet._();
  @$core.override
  CmdProfileSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CmdProfileSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CmdProfileSet>(create);
  static CmdProfileSet? _defaultInstance;

  @$pb.TagNumber(1)
  RoastProfile get profile => $_getN(0);
  @$pb.TagNumber(1)
  set profile(RoastProfile value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProfile() => $_has(0);
  @$pb.TagNumber(1)
  void clearProfile() => $_clearField(1);
  @$pb.TagNumber(1)
  RoastProfile ensureProfile() => $_ensure(0);
}

class CmdSettingGet extends $pb.GeneratedMessage {
  factory CmdSettingGet({
    $core.int? field_1,
  }) {
    final result = create();
    if (field_1 != null) result.field_1 = field_1;
    return result;
  }

  CmdSettingGet._();

  factory CmdSettingGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CmdSettingGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CmdSettingGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ikawa_cmd'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'field', fieldType: $pb.PbFieldType.Q3);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CmdSettingGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CmdSettingGet copyWith(void Function(CmdSettingGet) updates) =>
      super.copyWith((message) => updates(message as CmdSettingGet))
          as CmdSettingGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CmdSettingGet create() => CmdSettingGet._();
  @$core.override
  CmdSettingGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CmdSettingGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CmdSettingGet>(create);
  static CmdSettingGet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get field_1 => $_getIZ(0);
  @$pb.TagNumber(1)
  set field_1($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasField_1() => $_has(0);
  @$pb.TagNumber(1)
  void clearField_1() => $_clearField(1);
}

class IkawaResponse extends $pb.GeneratedMessage {
  factory IkawaResponse({
    $core.int? seq,
    IkawaResponse_Resp? resp,
    RespBootloaderGetVersion? respBootloaderGetVersion,
    RespMachPropGetType? respMachPropType,
    RespMachPropGetID? respMachId,
    RespMachStatusGetError? respMachStatusGetError,
    RespMachStatusGetAll? respMachStatusGetAll,
    RespHistGetTotalRoastCount? respHistGetTotalRoastCount,
    RespProfileGet? respProfileGet,
    RespSettingGet? respSettingGet,
    RespMachPropGetSupportInfo? respMachPropGetSupportInfo,
  }) {
    final result = create();
    if (seq != null) result.seq = seq;
    if (resp != null) result.resp = resp;
    if (respBootloaderGetVersion != null)
      result.respBootloaderGetVersion = respBootloaderGetVersion;
    if (respMachPropType != null) result.respMachPropType = respMachPropType;
    if (respMachId != null) result.respMachId = respMachId;
    if (respMachStatusGetError != null)
      result.respMachStatusGetError = respMachStatusGetError;
    if (respMachStatusGetAll != null)
      result.respMachStatusGetAll = respMachStatusGetAll;
    if (respHistGetTotalRoastCount != null)
      result.respHistGetTotalRoastCount = respHistGetTotalRoastCount;
    if (respProfileGet != null) result.respProfileGet = respProfileGet;
    if (respSettingGet != null) result.respSettingGet = respSettingGet;
    if (respMachPropGetSupportInfo != null)
      result.respMachPropGetSupportInfo = respMachPropGetSupportInfo;
    return result;
  }

  IkawaResponse._();

  factory IkawaResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IkawaResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IkawaResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ikawa_cmd'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'seq', fieldType: $pb.PbFieldType.Q3)
    ..aE<IkawaResponse_Resp>(2, _omitFieldNames ? '' : 'resp',
        enumValues: IkawaResponse_Resp.values)
    ..aOM<RespBootloaderGetVersion>(
        3, _omitFieldNames ? '' : 'respBootloaderGetVersion',
        subBuilder: RespBootloaderGetVersion.create)
    ..aOM<RespMachPropGetType>(4, _omitFieldNames ? '' : 'respMachPropType',
        subBuilder: RespMachPropGetType.create)
    ..aOM<RespMachPropGetID>(5, _omitFieldNames ? '' : 'respMachId',
        subBuilder: RespMachPropGetID.create)
    ..aOM<RespMachStatusGetError>(
        12, _omitFieldNames ? '' : 'respMachStatusGetError',
        subBuilder: RespMachStatusGetError.create)
    ..aOM<RespMachStatusGetAll>(
        13, _omitFieldNames ? '' : 'respMachStatusGetAll',
        subBuilder: RespMachStatusGetAll.create)
    ..aOM<RespHistGetTotalRoastCount>(
        15, _omitFieldNames ? '' : 'respHistGetTotalRoastCount',
        subBuilder: RespHistGetTotalRoastCount.create)
    ..aOM<RespProfileGet>(16, _omitFieldNames ? '' : 'respProfileGet',
        subBuilder: RespProfileGet.create)
    ..aOM<RespSettingGet>(17, _omitFieldNames ? '' : 'respSettingGet',
        subBuilder: RespSettingGet.create)
    ..aOM<RespMachPropGetSupportInfo>(
        21, _omitFieldNames ? '' : 'respMachPropGetSupportInfo',
        subBuilder: RespMachPropGetSupportInfo.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IkawaResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IkawaResponse copyWith(void Function(IkawaResponse) updates) =>
      super.copyWith((message) => updates(message as IkawaResponse))
          as IkawaResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IkawaResponse create() => IkawaResponse._();
  @$core.override
  IkawaResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IkawaResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IkawaResponse>(create);
  static IkawaResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get seq => $_getIZ(0);
  @$pb.TagNumber(1)
  set seq($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSeq() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeq() => $_clearField(1);

  @$pb.TagNumber(2)
  IkawaResponse_Resp get resp => $_getN(1);
  @$pb.TagNumber(2)
  set resp(IkawaResponse_Resp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasResp() => $_has(1);
  @$pb.TagNumber(2)
  void clearResp() => $_clearField(2);

  @$pb.TagNumber(3)
  RespBootloaderGetVersion get respBootloaderGetVersion => $_getN(2);
  @$pb.TagNumber(3)
  set respBootloaderGetVersion(RespBootloaderGetVersion value) =>
      $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRespBootloaderGetVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearRespBootloaderGetVersion() => $_clearField(3);
  @$pb.TagNumber(3)
  RespBootloaderGetVersion ensureRespBootloaderGetVersion() => $_ensure(2);

  @$pb.TagNumber(4)
  RespMachPropGetType get respMachPropType => $_getN(3);
  @$pb.TagNumber(4)
  set respMachPropType(RespMachPropGetType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRespMachPropType() => $_has(3);
  @$pb.TagNumber(4)
  void clearRespMachPropType() => $_clearField(4);
  @$pb.TagNumber(4)
  RespMachPropGetType ensureRespMachPropType() => $_ensure(3);

  @$pb.TagNumber(5)
  RespMachPropGetID get respMachId => $_getN(4);
  @$pb.TagNumber(5)
  set respMachId(RespMachPropGetID value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRespMachId() => $_has(4);
  @$pb.TagNumber(5)
  void clearRespMachId() => $_clearField(5);
  @$pb.TagNumber(5)
  RespMachPropGetID ensureRespMachId() => $_ensure(4);

  @$pb.TagNumber(12)
  RespMachStatusGetError get respMachStatusGetError => $_getN(5);
  @$pb.TagNumber(12)
  set respMachStatusGetError(RespMachStatusGetError value) =>
      $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasRespMachStatusGetError() => $_has(5);
  @$pb.TagNumber(12)
  void clearRespMachStatusGetError() => $_clearField(12);
  @$pb.TagNumber(12)
  RespMachStatusGetError ensureRespMachStatusGetError() => $_ensure(5);

  @$pb.TagNumber(13)
  RespMachStatusGetAll get respMachStatusGetAll => $_getN(6);
  @$pb.TagNumber(13)
  set respMachStatusGetAll(RespMachStatusGetAll value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasRespMachStatusGetAll() => $_has(6);
  @$pb.TagNumber(13)
  void clearRespMachStatusGetAll() => $_clearField(13);
  @$pb.TagNumber(13)
  RespMachStatusGetAll ensureRespMachStatusGetAll() => $_ensure(6);

  @$pb.TagNumber(15)
  RespHistGetTotalRoastCount get respHistGetTotalRoastCount => $_getN(7);
  @$pb.TagNumber(15)
  set respHistGetTotalRoastCount(RespHistGetTotalRoastCount value) =>
      $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasRespHistGetTotalRoastCount() => $_has(7);
  @$pb.TagNumber(15)
  void clearRespHistGetTotalRoastCount() => $_clearField(15);
  @$pb.TagNumber(15)
  RespHistGetTotalRoastCount ensureRespHistGetTotalRoastCount() => $_ensure(7);

  @$pb.TagNumber(16)
  RespProfileGet get respProfileGet => $_getN(8);
  @$pb.TagNumber(16)
  set respProfileGet(RespProfileGet value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasRespProfileGet() => $_has(8);
  @$pb.TagNumber(16)
  void clearRespProfileGet() => $_clearField(16);
  @$pb.TagNumber(16)
  RespProfileGet ensureRespProfileGet() => $_ensure(8);

  @$pb.TagNumber(17)
  RespSettingGet get respSettingGet => $_getN(9);
  @$pb.TagNumber(17)
  set respSettingGet(RespSettingGet value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasRespSettingGet() => $_has(9);
  @$pb.TagNumber(17)
  void clearRespSettingGet() => $_clearField(17);
  @$pb.TagNumber(17)
  RespSettingGet ensureRespSettingGet() => $_ensure(9);

  @$pb.TagNumber(21)
  RespMachPropGetSupportInfo get respMachPropGetSupportInfo => $_getN(10);
  @$pb.TagNumber(21)
  set respMachPropGetSupportInfo(RespMachPropGetSupportInfo value) =>
      $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasRespMachPropGetSupportInfo() => $_has(10);
  @$pb.TagNumber(21)
  void clearRespMachPropGetSupportInfo() => $_clearField(21);
  @$pb.TagNumber(21)
  RespMachPropGetSupportInfo ensureRespMachPropGetSupportInfo() => $_ensure(10);
}

class RespMachStatusGetAll extends $pb.GeneratedMessage {
  factory RespMachStatusGetAll({
    $core.int? time,
    $core.int? tempAbove,
    $core.int? fan,
    $core.int? state,
    $core.int? heater,
    $core.int? p,
    $core.int? i,
    $core.int? d,
    $core.int? setpoint,
    $core.int? fanMeasured,
    $core.int? boardTemp,
    $core.int? tempBelow,
    $core.int? fanRpmMeasured,
    $core.int? fanRpmSetpoint,
    $core.int? fanP,
    $core.int? fanI,
    $core.int? fanD,
    $core.int? fanPower,
    $core.int? j,
    $core.int? relayState,
    $core.int? pidSensor,
    $core.int? tempAboveFiltered,
    $core.int? tempBelowFiltered,
    $core.int? rorAbove,
    $core.int? rorBelow,
  }) {
    final result = create();
    if (time != null) result.time = time;
    if (tempAbove != null) result.tempAbove = tempAbove;
    if (fan != null) result.fan = fan;
    if (state != null) result.state = state;
    if (heater != null) result.heater = heater;
    if (p != null) result.p = p;
    if (i != null) result.i = i;
    if (d != null) result.d = d;
    if (setpoint != null) result.setpoint = setpoint;
    if (fanMeasured != null) result.fanMeasured = fanMeasured;
    if (boardTemp != null) result.boardTemp = boardTemp;
    if (tempBelow != null) result.tempBelow = tempBelow;
    if (fanRpmMeasured != null) result.fanRpmMeasured = fanRpmMeasured;
    if (fanRpmSetpoint != null) result.fanRpmSetpoint = fanRpmSetpoint;
    if (fanP != null) result.fanP = fanP;
    if (fanI != null) result.fanI = fanI;
    if (fanD != null) result.fanD = fanD;
    if (fanPower != null) result.fanPower = fanPower;
    if (j != null) result.j = j;
    if (relayState != null) result.relayState = relayState;
    if (pidSensor != null) result.pidSensor = pidSensor;
    if (tempAboveFiltered != null) result.tempAboveFiltered = tempAboveFiltered;
    if (tempBelowFiltered != null) result.tempBelowFiltered = tempBelowFiltered;
    if (rorAbove != null) result.rorAbove = rorAbove;
    if (rorBelow != null) result.rorBelow = rorBelow;
    return result;
  }

  RespMachStatusGetAll._();

  factory RespMachStatusGetAll.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RespMachStatusGetAll.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RespMachStatusGetAll',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ikawa_cmd'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'time', fieldType: $pb.PbFieldType.Q3)
    ..aI(2, _omitFieldNames ? '' : 'tempAbove')
    ..aI(3, _omitFieldNames ? '' : 'fan', fieldType: $pb.PbFieldType.Q3)
    ..aI(4, _omitFieldNames ? '' : 'state', fieldType: $pb.PbFieldType.Q3)
    ..aI(5, _omitFieldNames ? '' : 'heater', fieldType: $pb.PbFieldType.Q3)
    ..aI(6, _omitFieldNames ? '' : 'p', fieldType: $pb.PbFieldType.Q3)
    ..aI(7, _omitFieldNames ? '' : 'i', fieldType: $pb.PbFieldType.Q3)
    ..aI(8, _omitFieldNames ? '' : 'd', fieldType: $pb.PbFieldType.Q3)
    ..aI(9, _omitFieldNames ? '' : 'setpoint', fieldType: $pb.PbFieldType.Q3)
    ..aI(10, _omitFieldNames ? '' : 'fanMeasured',
        fieldType: $pb.PbFieldType.Q3)
    ..aI(11, _omitFieldNames ? '' : 'boardTemp')
    ..aI(12, _omitFieldNames ? '' : 'tempBelow')
    ..aI(13, _omitFieldNames ? '' : 'fanRpmMeasured')
    ..aI(14, _omitFieldNames ? '' : 'fanRpmSetpoint')
    ..aI(15, _omitFieldNames ? '' : 'fanP')
    ..aI(16, _omitFieldNames ? '' : 'fanI')
    ..aI(17, _omitFieldNames ? '' : 'fanD')
    ..aI(18, _omitFieldNames ? '' : 'fanPower')
    ..aI(19, _omitFieldNames ? '' : 'j')
    ..aI(20, _omitFieldNames ? '' : 'relayState')
    ..aI(21, _omitFieldNames ? '' : 'pidSensor')
    ..aI(22, _omitFieldNames ? '' : 'tempAboveFiltered')
    ..aI(23, _omitFieldNames ? '' : 'tempBelowFiltered')
    ..aI(24, _omitFieldNames ? '' : 'rorAbove')
    ..aI(25, _omitFieldNames ? '' : 'rorBelow');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RespMachStatusGetAll clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RespMachStatusGetAll copyWith(void Function(RespMachStatusGetAll) updates) =>
      super.copyWith((message) => updates(message as RespMachStatusGetAll))
          as RespMachStatusGetAll;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RespMachStatusGetAll create() => RespMachStatusGetAll._();
  @$core.override
  RespMachStatusGetAll createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RespMachStatusGetAll getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RespMachStatusGetAll>(create);
  static RespMachStatusGetAll? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get time => $_getIZ(0);
  @$pb.TagNumber(1)
  set time($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearTime() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get tempAbove => $_getIZ(1);
  @$pb.TagNumber(2)
  set tempAbove($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTempAbove() => $_has(1);
  @$pb.TagNumber(2)
  void clearTempAbove() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get fan => $_getIZ(2);
  @$pb.TagNumber(3)
  set fan($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFan() => $_has(2);
  @$pb.TagNumber(3)
  void clearFan() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get state => $_getIZ(3);
  @$pb.TagNumber(4)
  set state($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasState() => $_has(3);
  @$pb.TagNumber(4)
  void clearState() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get heater => $_getIZ(4);
  @$pb.TagNumber(5)
  set heater($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasHeater() => $_has(4);
  @$pb.TagNumber(5)
  void clearHeater() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get p => $_getIZ(5);
  @$pb.TagNumber(6)
  set p($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasP() => $_has(5);
  @$pb.TagNumber(6)
  void clearP() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get i => $_getIZ(6);
  @$pb.TagNumber(7)
  set i($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasI() => $_has(6);
  @$pb.TagNumber(7)
  void clearI() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get d => $_getIZ(7);
  @$pb.TagNumber(8)
  set d($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasD() => $_has(7);
  @$pb.TagNumber(8)
  void clearD() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get setpoint => $_getIZ(8);
  @$pb.TagNumber(9)
  set setpoint($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSetpoint() => $_has(8);
  @$pb.TagNumber(9)
  void clearSetpoint() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get fanMeasured => $_getIZ(9);
  @$pb.TagNumber(10)
  set fanMeasured($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasFanMeasured() => $_has(9);
  @$pb.TagNumber(10)
  void clearFanMeasured() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get boardTemp => $_getIZ(10);
  @$pb.TagNumber(11)
  set boardTemp($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasBoardTemp() => $_has(10);
  @$pb.TagNumber(11)
  void clearBoardTemp() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get tempBelow => $_getIZ(11);
  @$pb.TagNumber(12)
  set tempBelow($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasTempBelow() => $_has(11);
  @$pb.TagNumber(12)
  void clearTempBelow() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get fanRpmMeasured => $_getIZ(12);
  @$pb.TagNumber(13)
  set fanRpmMeasured($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasFanRpmMeasured() => $_has(12);
  @$pb.TagNumber(13)
  void clearFanRpmMeasured() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.int get fanRpmSetpoint => $_getIZ(13);
  @$pb.TagNumber(14)
  set fanRpmSetpoint($core.int value) => $_setSignedInt32(13, value);
  @$pb.TagNumber(14)
  $core.bool hasFanRpmSetpoint() => $_has(13);
  @$pb.TagNumber(14)
  void clearFanRpmSetpoint() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get fanP => $_getIZ(14);
  @$pb.TagNumber(15)
  set fanP($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasFanP() => $_has(14);
  @$pb.TagNumber(15)
  void clearFanP() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.int get fanI => $_getIZ(15);
  @$pb.TagNumber(16)
  set fanI($core.int value) => $_setSignedInt32(15, value);
  @$pb.TagNumber(16)
  $core.bool hasFanI() => $_has(15);
  @$pb.TagNumber(16)
  void clearFanI() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.int get fanD => $_getIZ(16);
  @$pb.TagNumber(17)
  set fanD($core.int value) => $_setSignedInt32(16, value);
  @$pb.TagNumber(17)
  $core.bool hasFanD() => $_has(16);
  @$pb.TagNumber(17)
  void clearFanD() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.int get fanPower => $_getIZ(17);
  @$pb.TagNumber(18)
  set fanPower($core.int value) => $_setSignedInt32(17, value);
  @$pb.TagNumber(18)
  $core.bool hasFanPower() => $_has(17);
  @$pb.TagNumber(18)
  void clearFanPower() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.int get j => $_getIZ(18);
  @$pb.TagNumber(19)
  set j($core.int value) => $_setSignedInt32(18, value);
  @$pb.TagNumber(19)
  $core.bool hasJ() => $_has(18);
  @$pb.TagNumber(19)
  void clearJ() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.int get relayState => $_getIZ(19);
  @$pb.TagNumber(20)
  set relayState($core.int value) => $_setSignedInt32(19, value);
  @$pb.TagNumber(20)
  $core.bool hasRelayState() => $_has(19);
  @$pb.TagNumber(20)
  void clearRelayState() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.int get pidSensor => $_getIZ(20);
  @$pb.TagNumber(21)
  set pidSensor($core.int value) => $_setSignedInt32(20, value);
  @$pb.TagNumber(21)
  $core.bool hasPidSensor() => $_has(20);
  @$pb.TagNumber(21)
  void clearPidSensor() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.int get tempAboveFiltered => $_getIZ(21);
  @$pb.TagNumber(22)
  set tempAboveFiltered($core.int value) => $_setSignedInt32(21, value);
  @$pb.TagNumber(22)
  $core.bool hasTempAboveFiltered() => $_has(21);
  @$pb.TagNumber(22)
  void clearTempAboveFiltered() => $_clearField(22);

  @$pb.TagNumber(23)
  $core.int get tempBelowFiltered => $_getIZ(22);
  @$pb.TagNumber(23)
  set tempBelowFiltered($core.int value) => $_setSignedInt32(22, value);
  @$pb.TagNumber(23)
  $core.bool hasTempBelowFiltered() => $_has(22);
  @$pb.TagNumber(23)
  void clearTempBelowFiltered() => $_clearField(23);

  @$pb.TagNumber(24)
  $core.int get rorAbove => $_getIZ(23);
  @$pb.TagNumber(24)
  set rorAbove($core.int value) => $_setSignedInt32(23, value);
  @$pb.TagNumber(24)
  $core.bool hasRorAbove() => $_has(23);
  @$pb.TagNumber(24)
  void clearRorAbove() => $_clearField(24);

  @$pb.TagNumber(25)
  $core.int get rorBelow => $_getIZ(24);
  @$pb.TagNumber(25)
  set rorBelow($core.int value) => $_setSignedInt32(24, value);
  @$pb.TagNumber(25)
  $core.bool hasRorBelow() => $_has(24);
  @$pb.TagNumber(25)
  void clearRorBelow() => $_clearField(25);
}

class RespMachStatusGetError extends $pb.GeneratedMessage {
  factory RespMachStatusGetError({
    $core.int? error,
  }) {
    final result = create();
    if (error != null) result.error = error;
    return result;
  }

  RespMachStatusGetError._();

  factory RespMachStatusGetError.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RespMachStatusGetError.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RespMachStatusGetError',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ikawa_cmd'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'error', fieldType: $pb.PbFieldType.Q3);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RespMachStatusGetError clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RespMachStatusGetError copyWith(
          void Function(RespMachStatusGetError) updates) =>
      super.copyWith((message) => updates(message as RespMachStatusGetError))
          as RespMachStatusGetError;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RespMachStatusGetError create() => RespMachStatusGetError._();
  @$core.override
  RespMachStatusGetError createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RespMachStatusGetError getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RespMachStatusGetError>(create);
  static RespMachStatusGetError? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get error => $_getIZ(0);
  @$pb.TagNumber(1)
  set error($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(1)
  void clearError() => $_clearField(1);
}

class RespProfileGet extends $pb.GeneratedMessage {
  factory RespProfileGet({
    RoastProfile? profile,
  }) {
    final result = create();
    if (profile != null) result.profile = profile;
    return result;
  }

  RespProfileGet._();

  factory RespProfileGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RespProfileGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RespProfileGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ikawa_cmd'),
      createEmptyInstance: create)
    ..aOM<RoastProfile>(1, _omitFieldNames ? '' : 'profile',
        subBuilder: RoastProfile.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RespProfileGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RespProfileGet copyWith(void Function(RespProfileGet) updates) =>
      super.copyWith((message) => updates(message as RespProfileGet))
          as RespProfileGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RespProfileGet create() => RespProfileGet._();
  @$core.override
  RespProfileGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RespProfileGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RespProfileGet>(create);
  static RespProfileGet? _defaultInstance;

  @$pb.TagNumber(1)
  RoastProfile get profile => $_getN(0);
  @$pb.TagNumber(1)
  set profile(RoastProfile value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProfile() => $_has(0);
  @$pb.TagNumber(1)
  void clearProfile() => $_clearField(1);
  @$pb.TagNumber(1)
  RoastProfile ensureProfile() => $_ensure(0);
}

class RoastProfile extends $pb.GeneratedMessage {
  factory RoastProfile({
    $core.int? schema,
    $core.List<$core.int>? id,
    $core.String? name,
    $core.Iterable<TempPoint>? tempPoints,
    $core.Iterable<FanPoint>? fanPoints,
    $core.int? tempSensor,
    FanPoint? cooldownFan,
    $core.String? coffeeName,
    $core.String? userId,
    $core.String? coffeeId,
    $core.String? coffeeWebUrl,
    $core.String? profileType,
  }) {
    final result = create();
    if (schema != null) result.schema = schema;
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (tempPoints != null) result.tempPoints.addAll(tempPoints);
    if (fanPoints != null) result.fanPoints.addAll(fanPoints);
    if (tempSensor != null) result.tempSensor = tempSensor;
    if (cooldownFan != null) result.cooldownFan = cooldownFan;
    if (coffeeName != null) result.coffeeName = coffeeName;
    if (userId != null) result.userId = userId;
    if (coffeeId != null) result.coffeeId = coffeeId;
    if (coffeeWebUrl != null) result.coffeeWebUrl = coffeeWebUrl;
    if (profileType != null) result.profileType = profileType;
    return result;
  }

  RoastProfile._();

  factory RoastProfile.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RoastProfile.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RoastProfile',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ikawa_cmd'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'schema')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OY)
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..pPM<TempPoint>(4, _omitFieldNames ? '' : 'tempPoints',
        subBuilder: TempPoint.create)
    ..pPM<FanPoint>(5, _omitFieldNames ? '' : 'fanPoints',
        subBuilder: FanPoint.create)
    ..aI(6, _omitFieldNames ? '' : 'tempSensor')
    ..aOM<FanPoint>(7, _omitFieldNames ? '' : 'cooldownFan',
        subBuilder: FanPoint.create)
    ..aOS(8, _omitFieldNames ? '' : 'coffeeName')
    ..aOS(9, _omitFieldNames ? '' : 'userId')
    ..aOS(10, _omitFieldNames ? '' : 'coffeeId')
    ..aOS(11, _omitFieldNames ? '' : 'coffeeWebUrl')
    ..aOS(12, _omitFieldNames ? '' : 'profileType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoastProfile clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoastProfile copyWith(void Function(RoastProfile) updates) =>
      super.copyWith((message) => updates(message as RoastProfile))
          as RoastProfile;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoastProfile create() => RoastProfile._();
  @$core.override
  RoastProfile createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RoastProfile getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RoastProfile>(create);
  static RoastProfile? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get schema => $_getIZ(0);
  @$pb.TagNumber(1)
  set schema($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSchema() => $_has(0);
  @$pb.TagNumber(1)
  void clearSchema() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get id => $_getN(1);
  @$pb.TagNumber(2)
  set id($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<TempPoint> get tempPoints => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<FanPoint> get fanPoints => $_getList(4);

  @$pb.TagNumber(6)
  $core.int get tempSensor => $_getIZ(5);
  @$pb.TagNumber(6)
  set tempSensor($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTempSensor() => $_has(5);
  @$pb.TagNumber(6)
  void clearTempSensor() => $_clearField(6);

  @$pb.TagNumber(7)
  FanPoint get cooldownFan => $_getN(6);
  @$pb.TagNumber(7)
  set cooldownFan(FanPoint value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCooldownFan() => $_has(6);
  @$pb.TagNumber(7)
  void clearCooldownFan() => $_clearField(7);
  @$pb.TagNumber(7)
  FanPoint ensureCooldownFan() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get coffeeName => $_getSZ(7);
  @$pb.TagNumber(8)
  set coffeeName($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCoffeeName() => $_has(7);
  @$pb.TagNumber(8)
  void clearCoffeeName() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get userId => $_getSZ(8);
  @$pb.TagNumber(9)
  set userId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasUserId() => $_has(8);
  @$pb.TagNumber(9)
  void clearUserId() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get coffeeId => $_getSZ(9);
  @$pb.TagNumber(10)
  set coffeeId($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCoffeeId() => $_has(9);
  @$pb.TagNumber(10)
  void clearCoffeeId() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get coffeeWebUrl => $_getSZ(10);
  @$pb.TagNumber(11)
  set coffeeWebUrl($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCoffeeWebUrl() => $_has(10);
  @$pb.TagNumber(11)
  void clearCoffeeWebUrl() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get profileType => $_getSZ(11);
  @$pb.TagNumber(12)
  set profileType($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasProfileType() => $_has(11);
  @$pb.TagNumber(12)
  void clearProfileType() => $_clearField(12);
}

class FanPoint extends $pb.GeneratedMessage {
  factory FanPoint({
    $core.int? time,
    $core.int? power,
  }) {
    final result = create();
    if (time != null) result.time = time;
    if (power != null) result.power = power;
    return result;
  }

  FanPoint._();

  factory FanPoint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FanPoint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FanPoint',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ikawa_cmd'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'time')
    ..aI(2, _omitFieldNames ? '' : 'power')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FanPoint clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FanPoint copyWith(void Function(FanPoint) updates) =>
      super.copyWith((message) => updates(message as FanPoint)) as FanPoint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FanPoint create() => FanPoint._();
  @$core.override
  FanPoint createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FanPoint getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FanPoint>(create);
  static FanPoint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get time => $_getIZ(0);
  @$pb.TagNumber(1)
  set time($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearTime() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get power => $_getIZ(1);
  @$pb.TagNumber(2)
  set power($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPower() => $_has(1);
  @$pb.TagNumber(2)
  void clearPower() => $_clearField(2);
}

class TempPoint extends $pb.GeneratedMessage {
  factory TempPoint({
    $core.int? time,
    $core.int? temp,
  }) {
    final result = create();
    if (time != null) result.time = time;
    if (temp != null) result.temp = temp;
    return result;
  }

  TempPoint._();

  factory TempPoint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TempPoint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TempPoint',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ikawa_cmd'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'time')
    ..aI(2, _omitFieldNames ? '' : 'temp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TempPoint clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TempPoint copyWith(void Function(TempPoint) updates) =>
      super.copyWith((message) => updates(message as TempPoint)) as TempPoint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TempPoint create() => TempPoint._();
  @$core.override
  TempPoint createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TempPoint getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TempPoint>(create);
  static TempPoint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get time => $_getIZ(0);
  @$pb.TagNumber(1)
  set time($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearTime() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get temp => $_getIZ(1);
  @$pb.TagNumber(2)
  set temp($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTemp() => $_has(1);
  @$pb.TagNumber(2)
  void clearTemp() => $_clearField(2);
}

class RespSettingGet extends $pb.GeneratedMessage {
  factory RespSettingGet({
    $core.int? field_1,
    $core.int? value,
  }) {
    final result = create();
    if (field_1 != null) result.field_1 = field_1;
    if (value != null) result.value = value;
    return result;
  }

  RespSettingGet._();

  factory RespSettingGet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RespSettingGet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RespSettingGet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ikawa_cmd'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'field')
    ..aI(2, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RespSettingGet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RespSettingGet copyWith(void Function(RespSettingGet) updates) =>
      super.copyWith((message) => updates(message as RespSettingGet))
          as RespSettingGet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RespSettingGet create() => RespSettingGet._();
  @$core.override
  RespSettingGet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RespSettingGet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RespSettingGet>(create);
  static RespSettingGet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get field_1 => $_getIZ(0);
  @$pb.TagNumber(1)
  set field_1($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasField_1() => $_has(0);
  @$pb.TagNumber(1)
  void clearField_1() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get value => $_getIZ(1);
  @$pb.TagNumber(2)
  set value($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);
}

class RespHistGetTotalRoastCount extends $pb.GeneratedMessage {
  factory RespHistGetTotalRoastCount({
    $core.int? totalRoastCount,
  }) {
    final result = create();
    if (totalRoastCount != null) result.totalRoastCount = totalRoastCount;
    return result;
  }

  RespHistGetTotalRoastCount._();

  factory RespHistGetTotalRoastCount.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RespHistGetTotalRoastCount.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RespHistGetTotalRoastCount',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ikawa_cmd'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'totalRoastCount',
        fieldType: $pb.PbFieldType.Q3);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RespHistGetTotalRoastCount clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RespHistGetTotalRoastCount copyWith(
          void Function(RespHistGetTotalRoastCount) updates) =>
      super.copyWith(
              (message) => updates(message as RespHistGetTotalRoastCount))
          as RespHistGetTotalRoastCount;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RespHistGetTotalRoastCount create() => RespHistGetTotalRoastCount._();
  @$core.override
  RespHistGetTotalRoastCount createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RespHistGetTotalRoastCount getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RespHistGetTotalRoastCount>(create);
  static RespHistGetTotalRoastCount? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get totalRoastCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set totalRoastCount($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotalRoastCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalRoastCount() => $_clearField(1);
}

class RespMachPropGetSupportInfo extends $pb.GeneratedMessage {
  factory RespMachPropGetSupportInfo({
    $core.int? profileSchema,
  }) {
    final result = create();
    if (profileSchema != null) result.profileSchema = profileSchema;
    return result;
  }

  RespMachPropGetSupportInfo._();

  factory RespMachPropGetSupportInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RespMachPropGetSupportInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RespMachPropGetSupportInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ikawa_cmd'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'profileSchema',
        fieldType: $pb.PbFieldType.Q3);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RespMachPropGetSupportInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RespMachPropGetSupportInfo copyWith(
          void Function(RespMachPropGetSupportInfo) updates) =>
      super.copyWith(
              (message) => updates(message as RespMachPropGetSupportInfo))
          as RespMachPropGetSupportInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RespMachPropGetSupportInfo create() => RespMachPropGetSupportInfo._();
  @$core.override
  RespMachPropGetSupportInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RespMachPropGetSupportInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RespMachPropGetSupportInfo>(create);
  static RespMachPropGetSupportInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get profileSchema => $_getIZ(0);
  @$pb.TagNumber(1)
  set profileSchema($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProfileSchema() => $_has(0);
  @$pb.TagNumber(1)
  void clearProfileSchema() => $_clearField(1);
}

class RespBootloaderGetVersion extends $pb.GeneratedMessage {
  factory RespBootloaderGetVersion({
    $core.int? version,
    $core.String? revision,
  }) {
    final result = create();
    if (version != null) result.version = version;
    if (revision != null) result.revision = revision;
    return result;
  }

  RespBootloaderGetVersion._();

  factory RespBootloaderGetVersion.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RespBootloaderGetVersion.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RespBootloaderGetVersion',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ikawa_cmd'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'version', fieldType: $pb.PbFieldType.Q3)
    ..aQS(2, _omitFieldNames ? '' : 'revision');

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RespBootloaderGetVersion clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RespBootloaderGetVersion copyWith(
          void Function(RespBootloaderGetVersion) updates) =>
      super.copyWith((message) => updates(message as RespBootloaderGetVersion))
          as RespBootloaderGetVersion;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RespBootloaderGetVersion create() => RespBootloaderGetVersion._();
  @$core.override
  RespBootloaderGetVersion createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RespBootloaderGetVersion getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RespBootloaderGetVersion>(create);
  static RespBootloaderGetVersion? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get version => $_getIZ(0);
  @$pb.TagNumber(1)
  set version($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get revision => $_getSZ(1);
  @$pb.TagNumber(2)
  set revision($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevision() => $_clearField(2);
}

class RespMachPropGetType extends $pb.GeneratedMessage {
  factory RespMachPropGetType({
    $core.int? type,
    $core.int? variant,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (variant != null) result.variant = variant;
    return result;
  }

  RespMachPropGetType._();

  factory RespMachPropGetType.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RespMachPropGetType.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RespMachPropGetType',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ikawa_cmd'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'type',
        protoName: 'type_', fieldType: $pb.PbFieldType.Q3)
    ..aI(2, _omitFieldNames ? '' : 'variant', fieldType: $pb.PbFieldType.Q3);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RespMachPropGetType clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RespMachPropGetType copyWith(void Function(RespMachPropGetType) updates) =>
      super.copyWith((message) => updates(message as RespMachPropGetType))
          as RespMachPropGetType;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RespMachPropGetType create() => RespMachPropGetType._();
  @$core.override
  RespMachPropGetType createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RespMachPropGetType getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RespMachPropGetType>(create);
  static RespMachPropGetType? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get type => $_getIZ(0);
  @$pb.TagNumber(1)
  set type($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get variant => $_getIZ(1);
  @$pb.TagNumber(2)
  set variant($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVariant() => $_has(1);
  @$pb.TagNumber(2)
  void clearVariant() => $_clearField(2);
}

class RespMachPropGetID extends $pb.GeneratedMessage {
  factory RespMachPropGetID({
    $core.int? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  RespMachPropGetID._();

  factory RespMachPropGetID.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RespMachPropGetID.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RespMachPropGetID',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'ikawa_cmd'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'id',
        protoName: 'id_', fieldType: $pb.PbFieldType.Q3);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RespMachPropGetID clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RespMachPropGetID copyWith(void Function(RespMachPropGetID) updates) =>
      super.copyWith((message) => updates(message as RespMachPropGetID))
          as RespMachPropGetID;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RespMachPropGetID create() => RespMachPropGetID._();
  @$core.override
  RespMachPropGetID createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RespMachPropGetID getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RespMachPropGetID>(create);
  static RespMachPropGetID? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
