import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui_components/src/constants.dart';
import 'package:shared_ui_components/src/helpers.dart';
import 'package:shared_ui_components/src/widget_keys.dart';

import 'mocks.dart';

void main() {
  Future<String> testFunc({
    required String phoneNumber,
    required int step,
    required dynamic client,
  }) {
    return Future<String>.value('1234');
  }

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
    expect(popValue('Belgium'), Country.belgium);
    expect(popValue('United Kingdom'), Country.uk);
  });

  test('should test getCountry', () {
    expect(getCountry(Country.kenya), supportedCountries['kenya']);
    expect(getCountry(Country.uganda), supportedCountries['uganda']);
    expect(getCountry(Country.tanzania), supportedCountries['tanzania']);
    expect(getCountry(Country.us), supportedCountries['usa']);
    expect(getCountry(Country.belgium), supportedCountries['belgium']);
    expect(getCountry(Country.uk), supportedCountries['uk']);
  });

  testWidgets('resend phone code renders correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return TextButton(
              key: const Key('button'),
              onPressed: () {
                showResendBottomSheet(
                  appWrapperContext: 'AppWrapper',
                  client: MockHttpClient(),
                  context: context,
                  generateOtpFunc: testFunc,
                  loader: const CircularProgressIndicator(
                      key: Key('loader_indicator')),
                  phoneNo: '+254700123456',
                  resetTimer: null,
                  retrySendOtpEndpoint: (dynamic val) {
                    return Uri.parse('http://example.com');
                  },
                  httpClient: MockHttpClient(),
                );
              },
              child: const Text('button'),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('button')), findsNWidgets(1));
    await tester.tap(find.byKey(const Key('button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(resendViaText));
    await tester.pumpAndSettle();
  });
}
