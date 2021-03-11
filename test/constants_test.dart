import 'package:flutter_test/flutter_test.dart';
import 'package:sil_ui_components/sil_country_picker.dart';
import 'package:sil_ui_components/utils/constants.dart';
import 'package:sil_ui_components/utils/helpers.dart';

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
    expect(PhoneNoConstants.verifyDesc(phoneNo),
        'We have sent a 6 digit code to $phoneNo. Enter the code below to proceed');
  });

  test('should test formatPhoneNumber', () {
    expect(formatPhoneNumber(countryCode: '+254', phoneNumber: '728101710'),
        '+254728101710');
    expect(formatPhoneNumber(countryCode: '254', phoneNumber: '728101710'),
        '+254728101710');
    expect(formatPhoneNumber(countryCode: '+1', phoneNumber: '928793687'),
        '+1928793687');
    expect(formatPhoneNumber(countryCode: '+254', phoneNumber: '0728101710'),
        '+254728101710');
  });

  test('should test alignLabelWithHint', () {
    expect(alignLabelWithHint(1), false);
    expect(alignLabelWithHint(2), true);
    expect(alignLabelWithHint(null), false);
  });

  test('should test popValue', () {
    expect(popValue('kenya'), Country.kenya);
    expect(popValue('uganda'), Country.uganda);
    expect(popValue('tanzania'), Country.tanzania);
    expect(popValue('United States'), Country.us);
  });

  test('should test getCountry', () {
    expect(getCountry(Country.kenya), supportedCountries['kenya']);
    expect(getCountry(Country.uganda), supportedCountries['uganda']);
    expect(getCountry(Country.tanzania), supportedCountries['tanzania']);
    expect(getCountry(Country.us), supportedCountries['usa']);
  });
}
