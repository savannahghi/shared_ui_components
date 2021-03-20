import 'package:flutter_test/flutter_test.dart';
import 'package:sil_ui_components/src/constants.dart';
import 'package:sil_ui_components/src/helpers.dart';

void main() {
  test('should return correct time respectively', () {
    expect(now, isA<DateTime>());
    expect(currentMonth, now.month);
    expect(oldestYear, currentYear - 122);
    expect(currentDay, now.day);
    expect(eligibleYear, DateTime(currentYear - 18, currentMonth, currentDay));
    expect(eligibleFutureYear, currentYear + 5);
  });

  test('should test PhoneNoConstants verifyDesc', () {
    const String phoneNo = '+2547xx xxx xx';
    expect(verifyDesc(phoneNo),
        'We have sent a 6 digit code to $phoneNo. Enter the code below to proceed');
  });

  test('should test alignLabelWithHint', () {
    expect(alignLabelWithHint(1), false);
    expect(alignLabelWithHint(2), true);
    expect(alignLabelWithHint(null), false);
  });

  test('should test popValue', () {
    expect(popValue('Kenya'), Country.kenya);
    expect(popValue('Uganda'), Country.uganda);
    expect(popValue('Tanzania'), Country.tanzania);
    expect(popValue('United States'), Country.us);
  });

  test('should test getCountry', () {
    expect(getCountry(Country.kenya), supportedCountries['kenya']);
    expect(getCountry(Country.uganda), supportedCountries['uganda']);
    expect(getCountry(Country.tanzania), supportedCountries['tanzania']);
    expect(getCountry(Country.us), supportedCountries['usa']);
  });
}
