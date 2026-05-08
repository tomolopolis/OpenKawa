import 'roast_profile_catalog_entry.dart';
import 'roast_profile_series.dart';

/// In-memory catalog and filter helpers. Replace with repository/API later.
class RoastProfileCatalog {
  RoastProfileCatalog({List<RoastProfileCatalogEntry>? entries})
      : _entries = List.unmodifiable(entries ?? defaultEntries);

  final List<RoastProfileCatalogEntry> _entries;

  List<RoastProfileCatalogEntry> get all => _entries;

  /// Case-insensitive substring match; empty or whitespace-only [query] matches all.
  static bool _fieldMatches(String value, String? query) {
    final q = query?.trim() ?? '';
    if (q.isEmpty) return true;
    return value.toLowerCase().contains(q.toLowerCase());
  }

  List<RoastProfileCatalogEntry> filter({
    String? profileName,
    String? origin,
    String? coffeeName,
    String? processType,
    String? roastLevel,
  }) {
    return _entries.where((e) {
      return _fieldMatches(e.profileName, profileName) &&
          _fieldMatches(e.origin, origin) &&
          _fieldMatches(e.coffeeName, coffeeName) &&
          _fieldMatches(e.processType, processType) &&
          _fieldMatches(e.roastLevel, roastLevel);
    }).toList();
  }

  /// Temp and fan use **independent** times (Ikawa-style). Times in seconds, fan 0–255-style.
  static RoastProfileSeries _seriesLight() {
    return RoastProfileSeriesFactory.sparseSetpoints(
      tempTimeSec: const [0, 120, 300, 480, 660],
      temp: const [158, 158, 176, 192, 204],
      fanTimeSec: const [0, 240, 660],
      fan: const [88, 112, 128],
    );
  }

  static RoastProfileSeries _seriesMedium() {
    return RoastProfileSeriesFactory.sparseSetpoints(
      tempTimeSec: const [0, 120, 320, 520, 720],
      temp: const [154, 154, 178, 198, 212],
      fanTimeSec: const [0, 360, 720],
      fan: const [90, 118, 132],
    );
  }

  static RoastProfileSeries _seriesMediumDark() {
    return RoastProfileSeriesFactory.sparseSetpoints(
      tempTimeSec: const [0, 150, 400, 580, 780],
      temp: const [150, 150, 188, 208, 218],
      fanTimeSec: const [0, 200, 520, 780],
      fan: const [86, 95, 125, 138],
    );
  }

  static RoastProfileSeries _seriesForRoastLevel(String roastLevel) {
    final r = roastLevel.toLowerCase();
    if (r.contains('light')) return _seriesLight();
    if (r.contains('medium-dark') || r.contains('dark')) return _seriesMediumDark();
    if (r.contains('medium')) return _seriesMedium();
    return _seriesMedium();
  }

  static final List<RoastProfileCatalogEntry> defaultEntries = [
    RoastProfileCatalogEntry(
      id: 'cat-001',
      profileName: 'Yirgacheffe Washed Light',
      origin: 'Ethiopia',
      coffeeName: 'Worka Sakaro',
      processType: 'Washed',
      roastLevel: 'Light',
      series: _seriesLight(),
    ),
    RoastProfileCatalogEntry(
      id: 'cat-002',
      profileName: 'Huila Honey Medium',
      origin: 'Colombia',
      coffeeName: 'Las Montañas',
      processType: 'Honey',
      roastLevel: 'Medium',
      series: _seriesForRoastLevel('Medium'),
    ),
    RoastProfileCatalogEntry(
      id: 'cat-003',
      profileName: 'Sumatra Wet-Hulled',
      origin: 'Indonesia',
      coffeeName: 'Gayo Highland',
      processType: 'Wet-hulled',
      roastLevel: 'Medium-dark',
      series: _seriesForRoastLevel('Medium-dark'),
    ),
    RoastProfileCatalogEntry(
      id: 'cat-004',
      profileName: 'Kenya Nyeri AA',
      origin: 'Kenya',
      coffeeName: 'Gachatha',
      processType: 'Washed',
      roastLevel: 'Light',
      series: _seriesForRoastLevel('Light'),
    ),
    RoastProfileCatalogEntry(
      id: 'cat-005',
      profileName: 'Natural Brazil Pulped',
      origin: 'Brazil',
      coffeeName: 'Cerrado Mineiro',
      processType: 'Natural',
      roastLevel: 'Medium',
      series: _seriesForRoastLevel('Medium'),
    ),
    RoastProfileCatalogEntry(
      id: 'cat-006',
      profileName: 'Simulator · City Roast',
      origin: 'Blend',
      coffeeName: 'Yirgacheffe (sim)',
      processType: 'Washed',
      roastLevel: 'Medium',
      series: RoastProfileSeriesFactory.sparseSetpoints(
        tempTimeSec: const [0, 100, 250, 400, 600],
        temp: const [150, 150, 175, 195, 208],
        fanTimeSec: const [0, 280, 600],
        fan: const [92, 118, 132],
      ),
    ),
  ];
}
