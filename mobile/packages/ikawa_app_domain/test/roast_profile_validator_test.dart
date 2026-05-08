import 'package:ikawa_app_domain/ikawa_app_domain.dart';
import 'package:test/test.dart';

void main() {
  test('validator flags steep temp ramps and fan jumps on independent axes', () {
    final series = RoastProfileSeries(
      tempTimeSec: const [0, 10, 20],
      temp: const [150, 200, 240],
      fanTimeSec: const [0, 10, 20],
      fan: const [10, 180, 200],
    );
    final issues = const RoastProfileValidator().validate(series);
    expect(issues, isNotEmpty);
  });
}
