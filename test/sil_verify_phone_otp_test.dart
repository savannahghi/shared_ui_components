import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sil_ui_components/sil_inputs.dart';
import 'package:sil_ui_components/sil_verify_phone_otp.dart';

class FakeClient {}

void main() {
  group('SILVerifyPhoneOtp', () {
    testWidgets('should render SILVerifyPhoneOtp ',
        (WidgetTester tester) async {
      void testCallback(
          {required String otp, required Function toggleLoading}) {}

      final Widget testWidget = MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: SILVerifyPhoneOtp(
                appWrapperContext: 'appcontext',
                client: FakeClient,
                generateOtpFunc: () {},
                loader: const CircularProgressIndicator(),
                otp: '123456',
                phoneNo: '+254123654789',
                retrySendOtpEndpoint: () {},
                successCallBack: testCallback,
                setValues: () {},
              ),
            );
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await tester.showKeyboard(find.byType(SILPinCodeTextField));
      await tester.enterText(find.byType(SILPinCodeTextField), '123456');
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(SILPinCodeTextField), '123457');
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('resendOtpCode')), findsOneWidget);
      await tester.tap(find.byKey(const Key('resendOtpCode')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('onCancelResendBottomSheetKey')),
          findsOneWidget);
      await tester.tap(find.byKey(const Key('onCancelResendBottomSheetKey')));

      await tester.pumpAndSettle();

      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
    });
    testWidgets('should render SILVerifyPhoneOtp when otp is wrong ',
        (WidgetTester tester) async {
      void testCallback({
        required String otp,
      }) {}

      final Widget testWidget = MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: SILVerifyPhoneOtp(
                appWrapperContext: 'appcontext',
                client: FakeClient,
                generateOtpFunc: () {},
                loader: const CircularProgressIndicator(),
                otp: '123456',
                phoneNo: '+254123654789',
                retrySendOtpEndpoint: () {},
                successCallBack: testCallback,
                setValues: () {},
              ),
            );
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await tester.enterText(find.byType(SILPinCodeTextField), '123457');
      await tester.pumpAndSettle();
    });
  });

  Future<String> testFunc({
    required String phoneNumber,
    required int step,
    required dynamic client,
  }) {
    return Future<String>.value('');
  }

  testWidgets('verify phone otp renders correctly',
      (WidgetTester tester) async {
    void testCallback({required String otp, required Function toggleLoading}) {}

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SILVerifyPhoneOtp(
          appWrapperContext: '',
          client: '',
          loader: Container(),
          otp: '123456',
          phoneNo: '',
          retrySendOtpEndpoint: () {},
          successCallBack: testCallback,
          generateOtpFunc: testFunc,
          setValues: () {},
        ),
      ),
    ));
    await tester.showKeyboard(find.byType(SILPinCodeTextField));
    await tester.enterText(find.byType(SILPinCodeTextField), '123456');
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(SILPinCodeTextField), '123457');
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('resendOtpCode')), findsOneWidget);
    await tester.tap(find.byKey(const Key('resendOtpCode')));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();

    expect(
        find.byKey(const Key('onCancelResendBottomSheetKey')), findsOneWidget);
    await tester.tap(find.byKey(const Key('onCancelResendBottomSheetKey')));
    await tester.pumpAndSettle();

    expect(find.byType(TextButton), findsOneWidget);
    await tester.tap(find.byType(TextButton));
    await tester.pumpAndSettle();
  });
}
