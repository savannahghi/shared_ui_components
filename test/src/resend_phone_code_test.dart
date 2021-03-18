import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sil_ui_components/sil_resend_phone_code.dart';

void main() {
  Future<String> testFunc({
    required String phoneNumber,
    required int step,
    required dynamic client,
  }) {
    return Future<String>.value('');
  }

  testWidgets('resend phone code renders correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SILResendPhoneCode(
          client: '',
          appWrapperContext: '',
          generateOtpFunc: testFunc,
          loader: Container(),
          phoneNumber: '',
          resetTimer: () {},
          retrySendOtpEndpoint: () {},
        ),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.byType(ListTile), findsNWidgets(2));
    //await tester.tap(find.text(viaText));
    // await tester.pumpAndSettle();
  });
}
