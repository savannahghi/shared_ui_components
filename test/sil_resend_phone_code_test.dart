import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sil_ui_components/sil_resend_phone_code.dart';
import 'package:sil_ui_components/src/constants.dart';

import 'mocks.dart';

void main() {
  Future<String> testFunc({
    required String phoneNumber,
    required int step,
    required dynamic client,
  }) {
    return Future<String>.value('1234');
  }

  testWidgets('resend phone code renders correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SILResendPhoneCode(
          client: MockHttpClient(),
          appWrapperContext: '',
          generateOtpFunc: testFunc,
          loader: Container(),
          phoneNumber: '',
          resetTimer: () {},
          retrySendOtpEndpoint: () {},
          httpClient: MockHttpClient(),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.byType(ListTile), findsNWidgets(2));
  });

  testWidgets('resend phone code via text message',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SILResendPhoneCode(
          client: MockHttpClient(),
          appWrapperContext: '',
          generateOtpFunc: testFunc,
          loader: const CircularProgressIndicator(key: Key('loader_indicator')),
          phoneNumber: '',
          resetTimer: () {},
          retrySendOtpEndpoint: (dynamic val) {
            return Uri.parse('http://example.com');
          },
          onOtpCallback: (BuildContext context, dynamic val) {
            // note: the ignoring here is very intentional
            // ignore: avoid_print
            print(val);
          },
          httpClient: MockHttpClient(),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    final Finder element = find.byKey(resendViaText);
    expect(element, findsNWidgets(1));
    expect(find.byKey(const Key('loader_indicator')), findsNWidgets(0));
    await tester.tap(element);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('loader_indicator')), findsNWidgets(0));
  });

  testWidgets('resend phone code via text message with error',
      (WidgetTester tester) async {
    bool isRestart = false;
    void restartTimer() {
      isRestart = true;
    }

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SILResendPhoneCode(
          client: MockHttpClient(),
          appWrapperContext: '',
          generateOtpFunc: testFunc,
          loader: const CircularProgressIndicator(key: Key('loader_indicator')),
          phoneNumber: '',
          resetTimer: restartTimer,
          retrySendOtpEndpoint: (dynamic val) {
            return Uri.parse('http://example.com');
          },
          onOtpCallback: (BuildContext context, dynamic val) {
            // note: the ignoring here is very intentional
            // ignore: avoid_print
            print(val);
          },
        ),
      ),
    ));
    await tester.pumpAndSettle();
    final Finder element = find.byKey(resendViaText);
    expect(element, findsNWidgets(1));
    expect(find.byKey(const Key('has_error')), findsNWidgets(0));
    expect(find.byKey(const Key('has_error_resend_btn')), findsNWidgets(0));
    await tester.tap(element);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('has_error')), findsNWidgets(1));
    expect(find.byKey(const Key('has_error_resend_btn')), findsNWidgets(1));
    await tester.tap(find.byKey(const Key('has_error_resend_btn')));
    expect(find.byKey(const Key('has_error')), findsNWidgets(1));
    expect(find.byKey(const Key('has_error_resend_btn')), findsNWidgets(1));

    expect(isRestart, true);
  });

  testWidgets('resend phone code via whatsapp message',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SILResendPhoneCode(
          client: MockHttpClient(),
          appWrapperContext: '',
          generateOtpFunc: testFunc,
          loader: const CircularProgressIndicator(key: Key('loader_indicator')),
          phoneNumber: '',
          resetTimer: () {},
          retrySendOtpEndpoint: (dynamic val) {
            return Uri.parse('http://example.com');
          },
          onOtpCallback: (BuildContext context, dynamic val) {
            // note: the ignoring here is very intentional
            // ignore: avoid_print
            print(val);
          },
          httpClient: MockHttpClient(),
          resendVia: ResendVia.graph,
        ),
      ),
    ));
    await tester.pumpAndSettle();
    final Finder element = find.byKey(const Key('send_via_whatsapp_msg'));
    expect(element, findsNWidgets(1));
    expect(find.byKey(const Key('loader_indicator')), findsNWidgets(0));
    await tester.tap(element);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('loader_indicator')), findsNWidgets(0));
  });

  testWidgets('resend phone code via whatsapp message with error message',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SILResendPhoneCode(
          client: MockHttpClient(),
          appWrapperContext: '',
          generateOtpFunc: (String phone) {},
          loader: const CircularProgressIndicator(key: Key('loader_indicator')),
          phoneNumber: '',
          resetTimer: () {},
          retrySendOtpEndpoint: (dynamic val) {
            return Uri.parse('http://example.com');
          },
          onOtpCallback: (BuildContext context, dynamic val) {
            // note: the ignoring here is very intentional
            // ignore: avoid_print
            print(val);
          },
          httpClient: MockHttpClient(),
          resendVia: ResendVia.graph,
        ),
      ),
    ));
    await tester.pumpAndSettle();
    final Finder element = find.byKey(const Key('send_via_whatsapp_msg'));
    expect(element, findsNWidgets(1));
    expect(find.byKey(const Key('has_error')), findsNWidgets(0));
    expect(find.byKey(const Key('has_error_resend_btn')), findsNWidgets(0));
    await tester.tap(element);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('has_error')), findsNWidgets(1));
    expect(find.byKey(const Key('has_error_resend_btn')), findsNWidgets(1));
    await tester.tap(find.byKey(const Key('has_error_resend_btn')));
    expect(find.byKey(const Key('has_error')), findsNWidgets(1));
    expect(find.byKey(const Key('has_error_resend_btn')), findsNWidgets(1));
  });
}
