import 'roast_profile_series.dart';

/// Browsable roast profile metadata for the app catalog (not wire protobuf).
class RoastProfileCatalogEntry {
  const RoastProfileCatalogEntry({
    required this.id,
    required this.profileName,
    required this.origin,
    required this.coffeeName,
    required this.processType,
    required this.roastLevel,
    required this.series,
  });

  final String id;
  final String profileName;
  final String origin;
  final String coffeeName;
  final String processType;
  final String roastLevel;
  final RoastProfileSeries series;
}
