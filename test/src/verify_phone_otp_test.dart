import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sil_ui_components/src/inputs.dart';
import 'package:sil_ui_components/src/verify_phone_otp.dart';

void main() {
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
