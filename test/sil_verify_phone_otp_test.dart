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
      final Widget testWidget = MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: SILVerifyPhoneOtp(
                appWrapperContext: 'appcontext',
                client: FakeClient,
                generateOtpFunc: () => true,
                loader: const CircularProgressIndicator(),
                otp: '1223',
                phoneNo: '+254123654789',
                retrySendOtpEndpoint: () {},
                successCallBack: () {},
              ),
            );
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await tester.pumpAndSettle();

      expect(find.byType(SILVerifyPhoneOtp), findsOneWidget);
      expect(find.byType(SILPinCodeTextField), findsOneWidget);
    });
  });
}
