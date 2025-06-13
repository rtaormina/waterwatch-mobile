import 'package:flutter_test/flutter_test.dart';
import 'package:waterwatch/util/util_functions/format_date_time.dart';

void main() {
  group('formatDurationToMinSec', () {
    test('formats zero duration', () {
      expect(formatDurationToMinSec(Duration.zero), '00:00');
    });

    test('formats seconds only', () {
      expect(formatDurationToMinSec(const Duration(seconds: 5)), '00:05');
      expect(formatDurationToMinSec(const Duration(seconds: 59)), '00:59');
    });

    test('formats minutes and seconds correctly', () {
      expect(
        formatDurationToMinSec(const Duration(minutes: 1, seconds: 2)),
        '01:02',
      );
      expect(
        formatDurationToMinSec(const Duration(minutes: 10, seconds: 0)),
        '10:00',
      );
    });

    test('rolls over seconds > 60', () {
      // 125 seconds = 2m 5s
      expect(formatDurationToMinSec(const Duration(seconds: 125)), '02:05');
    });

    test('rolls over minutes > 60', () {
      // 61 minutes + 65 seconds = 1m 1s
      expect(
        formatDurationToMinSec(const Duration(minutes: 61, seconds: 65)),
        '02:05',
      );
    });

    test('ignores whole hours, only shows mm:ss', () {
      // 1h 2m 3s → 62m 3s → "02:03"
      expect(
        formatDurationToMinSec(
            const Duration(hours: 1, minutes: 2, seconds: 3)),
        '02:03',
      );
      // 25h 61m 61s → (25*60+61)=1561m → 1m ; 61s→1s → "01:01"
      expect(
        formatDurationToMinSec(
            const Duration(hours: 25, minutes: 61, seconds: 61)),
        '02:01',
      );
    });
  });
}
