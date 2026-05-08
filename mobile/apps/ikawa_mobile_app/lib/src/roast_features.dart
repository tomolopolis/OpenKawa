import 'dart:convert';
import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:ikawa_app_domain/ikawa_app_domain.dart';

class RoastSessionState {
  const RoastSessionState({
    this.isRunning = false,
    this.roastStartSec,
    this.firstCrackSec,
  });

  final bool isRunning;
  final double? roastStartSec;
  final double? firstCrackSec;

  RoastSessionState copyWith({
    bool? isRunning,
    double? roastStartSec,
    double? firstCrackSec,
    bool clearFirstCrack = false,
  }) {
    return RoastSessionState(
      isRunning: isRunning ?? this.isRunning,
      roastStartSec: roastStartSec ?? this.roastStartSec,
      firstCrackSec: clearFirstCrack ? null : (firstCrackSec ?? this.firstCrackSec),
    );
  }
}

double? calculateDtrPercent(RoastSessionState state, double liveTimeSec) {
  final roastStart = state.roastStartSec;
  final firstCrack = state.firstCrackSec;
  if (roastStart == null || firstCrack == null || liveTimeSec <= firstCrack) {
    return null;
  }
  final dev = liveTimeSec - firstCrack;
  final total = liveTimeSec - roastStart;
  if (total <= 0) return null;
  return (dev / total) * 100;
}

String dtrZone(double dtrPercent) {
  if (dtrPercent < 15) return 'Underdeveloped';
  if (dtrPercent <= 25) return 'Gold Zone';
  return 'Overdeveloped';
}

class AppBeanLibraryRepository {
  AppBeanLibraryRepository({String? storagePath})
      : _storagePath = storagePath ?? '${Directory.systemTemp.path}/ikawa_bean_library.json';

  final String _storagePath;
  static const _boxName = 'ikawa_bean_library_v1';
  static bool _hiveReady = false;

  Future<void> _ensureHive() async {
    if (_hiveReady) return;
    await Hive.initFlutter();
    _hiveReady = true;
  }

  Future<List<GreenBean>> load() async {
    await _ensureHive();
    final box = await Hive.openBox(_boxName);
    final stored = box.get('beans');
    if (stored is List) {
      return stored
          .map((e) => GreenBean.fromJson((e as Map<dynamic, dynamic>).cast<String, dynamic>()))
          .toList();
    }
    // Backward compatibility fallback from JSON file.
    final file = File(_storagePath);
    if (!await file.exists()) return const [];
    final raw = await file.readAsString();
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => GreenBean.fromJson((e as Map<dynamic, dynamic>).cast<String, dynamic>()))
        .toList();
  }

  Future<void> save(List<GreenBean> beans) async {
    await _ensureHive();
    final box = await Hive.openBox(_boxName);
    await box.put('beans', beans.map((b) => b.toJson()).toList(growable: false));
    final file = File(_storagePath);
    await file.parent.create(recursive: true);
    await file.writeAsString(
      jsonEncode(beans.map((b) => b.toJson()).toList()),
      flush: true,
    );
  }
}

enum RoastLevelPreset { light, lightMedium, medium, mediumDark, dark }

enum DevelopmentTimePreset { low, medium, high }

RoastProfileSeries buildPresetSeries({
  required RoastLevelPreset roastLevel,
  required DevelopmentTimePreset developmentTime,
}) {
  final roastLevelTarget = switch (roastLevel) {
    RoastLevelPreset.light => 202.0,
    RoastLevelPreset.lightMedium => 208.0,
    RoastLevelPreset.medium => 214.0,
    RoastLevelPreset.mediumDark => 220.0,
    RoastLevelPreset.dark => 226.0,
  };
  final totalTime = switch (roastLevel) {
    RoastLevelPreset.light => 570.0,
    RoastLevelPreset.lightMedium => 610.0,
    RoastLevelPreset.medium => 660.0,
    RoastLevelPreset.mediumDark => 700.0,
    RoastLevelPreset.dark => 740.0,
  };
  final devRatio = switch (developmentTime) {
    DevelopmentTimePreset.low => 0.16,
    DevelopmentTimePreset.medium => 0.21,
    DevelopmentTimePreset.high => 0.26,
  };
  final firstCrackSec = totalTime * (1 - devRatio);
  final t1 = 0.0;
  final t2 = 90.0;
  final t3 = (firstCrackSec - 85).clamp(200.0, totalTime - 120.0);
  final t4 = firstCrackSec;
  final t5 = totalTime;

  // "3 commandments" guardrails: steadily declining RoR (decreasing temp deltas),
  // no end-of-roast flick, and no baked flatline.
  final start = 150.0;
  final p2 = start;
  final p3 = roastLevelTarget - 26.0;
  final p4 = roastLevelTarget - 10.0;
  final p5 = roastLevelTarget;

  final fanBase = switch (roastLevel) {
    RoastLevelPreset.light => 88.0,
    RoastLevelPreset.lightMedium => 90.0,
    RoastLevelPreset.medium => 92.0,
    RoastLevelPreset.mediumDark => 94.0,
    RoastLevelPreset.dark => 96.0,
  };
  final fanTail = switch (developmentTime) {
    DevelopmentTimePreset.low => 130.0,
    DevelopmentTimePreset.medium => 138.0,
    DevelopmentTimePreset.high => 146.0,
  };

  return RoastProfileSeriesFactory.sparseSetpoints(
    tempTimeSec: [t1, t2, t3, t4, t5],
    temp: [start, p2, p3, p4, p5],
    fanTimeSec: [t1, (t3 + t4) / 2, t5],
    fan: [fanBase, (fanBase + fanTail) / 2, fanTail],
  );
}

class ProfileIoService {
  RoastProfileCatalogEntry importJsonProfile(String rawJson) {
    final data = jsonDecode(rawJson) as Map<String, dynamic>;
    final tempPoints = data['temp_points'] as List<dynamic>?;
    final fanPoints = data['fan_points'] as List<dynamic>?;

    if (tempPoints != null && fanPoints != null) {
      final tt = <double>[];
      final tv = <double>[];
      for (final p in tempPoints) {
        final row = (p as Map<dynamic, dynamic>).cast<String, dynamic>();
        tt.add((row['time'] as num).toDouble());
        tv.add((row['temp'] as num).toDouble());
      }
      final ft = <double>[];
      final fv = <double>[];
      for (final p in fanPoints) {
        final row = (p as Map<dynamic, dynamic>).cast<String, dynamic>();
        ft.add((row['time'] as num).toDouble());
        fv.add((row['power'] as num).toDouble());
      }
      return RoastProfileCatalogEntry(
        id: data['id'] as String? ?? 'imported-${DateTime.now().millisecondsSinceEpoch}',
        profileName: (data['name'] ?? data['profileName']) as String? ?? 'Imported profile',
        origin: data['origin'] as String? ?? 'Unknown',
        coffeeName: (data['coffee_name'] ?? data['coffeeName']) as String? ?? 'Unknown',
        processType: data['processType'] as String? ?? 'Unknown',
        roastLevel: data['roastLevel'] as String? ?? 'Unknown',
        series: RoastProfileSeries(
          tempTimeSec: tt,
          temp: tv,
          fanTimeSec: ft,
          fan: fv,
        ),
      );
    }

    final points = (data['points'] as List<dynamic>? ?? const []);
    final time = <double>[];
    final temp = <double>[];
    final fan = <double>[];
    for (final p in points) {
      final row = (p as Map<dynamic, dynamic>).cast<String, dynamic>();
      time.add((row['time'] as num).toDouble());
      temp.add((row['temp'] as num).toDouble());
      fan.add((row['fan'] as num).toDouble());
    }
    return RoastProfileCatalogEntry(
      id: data['id'] as String? ?? 'imported-${DateTime.now().millisecondsSinceEpoch}',
      profileName: data['profileName'] as String? ?? 'Imported profile',
      origin: data['origin'] as String? ?? 'Unknown',
      coffeeName: data['coffeeName'] as String? ?? 'Unknown',
      processType: data['processType'] as String? ?? 'Unknown',
      roastLevel: data['roastLevel'] as String? ?? 'Unknown',
      series: RoastProfileSeriesFactory.sparseSetpointsAligned(
        timeSec: time,
        temp: temp,
        fan: fan,
      ),
    );
  }

  String exportArtisanCsv({
    required RoastProfileCatalogEntry profile,
    required List<LiveRoastSample> samples,
  }) {
    final buffer = StringBuffer('Time,InletTemp,BeanTemp,RoR,Fan\n');
    for (final s in samples) {
      buffer.writeln(
        '${s.timeSec.toStringAsFixed(1)},${s.inletTempC.toStringAsFixed(1)},${s.beanTempC.toStringAsFixed(1)},${s.rorCPerMin.toStringAsFixed(2)},${s.fan.toStringAsFixed(1)}',
      );
    }
    return buffer.toString();
  }
}

class LiveRoastSample {
  const LiveRoastSample({
    required this.timeSec,
    required this.inletTempC,
    required this.beanTempC,
    required this.rorCPerMin,
    required this.fan,
  });

  final double timeSec;
  final double inletTempC;
  final double beanTempC;
  final double rorCPerMin;
  final double fan;
}

class ExternalSensorSample {
  const ExternalSensorSample({
    required this.timeSec,
    required this.beanProbeTempC,
  });

  final double timeSec;
  final double beanProbeTempC;
}

double estimateVirtualBeanTemp({
  required double inletTempC,
  required GreenBean? bean,
}) {
  if (bean == null) return inletTempC - 8;
  final densityPenalty = (bean.densityGPerMl - 0.65) * 14;
  final moisturePenalty = (bean.moisturePercent - 10.5) * 2;
  return inletTempC - 8 - densityPenalty - moisturePenalty;
}

class RoastAssistantWarning {
  const RoastAssistantWarning(this.message);
  final String message;
}

List<RoastAssistantWarning> evaluateRoastWarnings({
  required double rorCPerMin,
  required double elapsedSec,
  required GreenBean? bean,
}) {
  final out = <RoastAssistantWarning>[];
  final density = bean?.densityGPerMl ?? 0.65;
  if (density > 0.72 && elapsedSec > 180 && rorCPerMin < 4) {
    out.add(const RoastAssistantWarning('Stall risk: raise energy for dense bean.'));
  }
  if (elapsedSec > 420 && rorCPerMin > 11) {
    out.add(const RoastAssistantWarning('Flick risk near end of roast.'));
  }
  return out;
}

class RoastRunSummary {
  const RoastRunSummary({
    required this.profileId,
    required this.profileName,
    required this.startedAtIso,
    required this.endedAtIso,
    required this.durationSec,
    required this.dropTempC,
    this.firstCrackSec,
    this.developmentRatioPct,
  });

  final String profileId;
  final String profileName;
  final String startedAtIso;
  final String endedAtIso;
  final double durationSec;
  final double dropTempC;
  final double? firstCrackSec;
  final double? developmentRatioPct;

  Map<String, dynamic> toJson() => {
        'profileId': profileId,
        'profileName': profileName,
        'startedAtIso': startedAtIso,
        'endedAtIso': endedAtIso,
        'durationSec': durationSec,
        'dropTempC': dropTempC,
        'firstCrackSec': firstCrackSec,
        'developmentRatioPct': developmentRatioPct,
      };

  static RoastRunSummary fromJson(Map<String, dynamic> json) => RoastRunSummary(
        profileId: json['profileId'] as String,
        profileName: json['profileName'] as String,
        startedAtIso: json['startedAtIso'] as String,
        endedAtIso: json['endedAtIso'] as String,
        durationSec: (json['durationSec'] as num).toDouble(),
        dropTempC: (json['dropTempC'] as num).toDouble(),
        firstCrackSec: (json['firstCrackSec'] as num?)?.toDouble(),
        developmentRatioPct: (json['developmentRatioPct'] as num?)?.toDouble(),
      );
}

class RoastRunHistoryRepository {
  static const _boxName = 'ikawa_roast_runs_v1';

  Future<Map<String, List<RoastRunSummary>>> load() async {
    await Hive.initFlutter();
    final box = await Hive.openBox(_boxName);
    final raw = box.get('runsByProfile');
    if (raw is! Map) return const {};
    final out = <String, List<RoastRunSummary>>{};
    for (final e in raw.entries) {
      final key = e.key.toString();
      final list = (e.value as List<dynamic>)
          .map((v) => RoastRunSummary.fromJson((v as Map<dynamic, dynamic>).cast<String, dynamic>()))
          .toList();
      out[key] = list;
    }
    return out;
  }

  Future<void> save(Map<String, List<RoastRunSummary>> runsByProfile) async {
    await Hive.initFlutter();
    final box = await Hive.openBox(_boxName);
    final data = <String, List<Map<String, dynamic>>>{};
    for (final e in runsByProfile.entries) {
      data[e.key] = e.value.map((r) => r.toJson()).toList(growable: false);
    }
    await box.put('runsByProfile', data);
  }
}
