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

  static RoastProfileSeries _seriesForRoastLevel(String roastLevel) {
    final r = roastLevel.toLowerCase();
    if (r.contains('light')) {
      return RoastProfileSeriesFactory.synthetic(
        durationSec: 660,
        startTemp: 158,
        endTemp: 204,
      );
    }
    if (r.contains('medium-dark') || r.contains('dark')) {
      return RoastProfileSeriesFactory.synthetic(
        durationSec: 780,
        startTemp: 150,
        endTemp: 218,
      );
    }
    if (r.contains('medium')) {
      return RoastProfileSeriesFactory.synthetic(
        durationSec: 720,
        startTemp: 154,
        endTemp: 212,
      );
    }
    return RoastProfileSeriesFactory.synthetic(
      durationSec: 720,
      startTemp: 155,
      endTemp: 210,
    );
  }

  static final List<RoastProfileCatalogEntry> defaultEntries = [
    RoastProfileCatalogEntry(
      id: 'cat-001',
      profileName: 'Yirgacheffe Washed Light',
      origin: 'Ethiopia',
      coffeeName: 'Worka Sakaro',
      processType: 'Washed',
      roastLevel: 'Light',
      series: RoastProfileSeriesFactory.synthetic(
        durationSec: 660,
        startTemp: 158,
        endTemp: 204,
      ),
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
      series: RoastProfileSeriesFactory.synthetic(
        durationSec: 600,
        startTemp: 150,
        endTemp: 208,
      ),
    ),
  ];
}
