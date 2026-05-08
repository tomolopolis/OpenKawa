import 'package:ikawa_protocol_core/ikawa_proto_gen.dart' as pb;

import 'roast_profile_catalog_entry.dart';
import 'roaster_session_service.dart';

class ProfileUploadResult {
  const ProfileUploadResult({
    required this.chunkCount,
    required this.attempts,
  });

  final int chunkCount;
  final int attempts;
}

class ProfileUploadService {
  ProfileUploadService({
    required this.sessionService,
    this.maxRetries = 2,
  });

  final RoasterSessionService sessionService;
  final int maxRetries;

  static const int cmdProfileSet = 14;

  /// Sends one profile with independent temp and fan point lists (protobuf shape).
  Future<ProfileUploadResult> uploadCatalogProfile(RoastProfileCatalogEntry entry) async {
    final profile = _toRoastProfile(entry);
    var tries = 0;
    while (true) {
      tries += 1;
      final request = pb.Message()
        ..cmdType = cmdProfileSet
        ..seq = tries
        ..profileSet = (pb.CmdProfileSet()..profile = profile);
      try {
        await sessionService.sendTypedRequest(request);
        return ProfileUploadResult(chunkCount: 1, attempts: tries);
      } catch (_) {
        if (tries > maxRetries) rethrow;
      }
    }
  }

  pb.RoastProfile _toRoastProfile(RoastProfileCatalogEntry entry) {
    final profile = pb.RoastProfile()
      ..schema = 2
      ..name = entry.profileName
      ..coffeeName = entry.coffeeName
      ..profileType = 'catalog'
      ..tempSensor = 0;
    for (var i = 0; i < entry.series.tempTimeSec.length; i++) {
      profile.tempPoints.add(pb.TempPoint()
        ..time = entry.series.tempTimeSec[i].round()
        ..temp = entry.series.temp[i].round());
    }
    for (var j = 0; j < entry.series.fanTimeSec.length; j++) {
      profile.fanPoints.add(pb.FanPoint()
        ..time = entry.series.fanTimeSec[j].round()
        ..power = entry.series.fan[j].round());
    }
    profile.id.addAll(entry.id.codeUnits.take(8));
    return profile;
  }
}
