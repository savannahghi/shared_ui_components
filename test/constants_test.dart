import 'package:flutter_test/flutter_test.dart';

import '../lib/utils/constants.dart';

void main() {
  test('should return correct time respectively', () {
    expect(now, isA<DateTime>());
    expect(currentMonth, now.month);
    expect(oldestYear, currentYear - 122);
    expect(currentDay, now.day);
    expect(eligibleYear, DateTime(currentYear - 18, currentMonth, currentDay));
    expect(eligibleFutureYear, currentYear + 5);
  });
}
