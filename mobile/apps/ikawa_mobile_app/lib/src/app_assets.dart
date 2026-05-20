abstract final class AppAssets {
  static const String appIcon = 'assets/images/app_icon.png';
  static const String background1 = 'assets/images/background1.png';
  static const String background2 = 'assets/images/background2.png';
  static const String background3 = 'assets/images/background3.png';

  /// Tab index → illustrative background (profiles, roaster, history).
  static String backgroundForTab(int index) {
    return switch (index) {
      0 => background2,
      1 => background1,
      _ => background3,
    };
  }
}
