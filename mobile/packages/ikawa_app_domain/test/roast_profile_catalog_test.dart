import 'package:ikawa_app_domain/src/roast_profile_catalog.dart';
import 'package:test/test.dart';

void main() {
  test('filter by profile name only', () {
    final cat = RoastProfileCatalog();
    final r = cat.filter(profileName: 'yirg');
    expect(r.length, 1);
    expect(r.single.profileName, contains('Yirgacheffe'));
  });

  test('empty name query returns all', () {
    final cat = RoastProfileCatalog();
    expect(cat.filter(profileName: '   ').length, cat.all.length);
  });

  test('advanced filters combine with AND', () {
    final cat = RoastProfileCatalog();
    final r = cat.filter(
      profileName: '',
      origin: 'ethiopia',
      processType: 'washed',
      roastLevel: 'light',
    );
    expect(r.length, 1);
    for (final e in r) {
      expect(e.origin.toLowerCase(), contains('ethiopia'));
      expect(e.processType.toLowerCase(), contains('washed'));
      expect(e.roastLevel.toLowerCase(), contains('light'));
    }
  });
}
