import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sil_ui_components/sil_inputs.dart';
import 'package:sil_ui_components/sil_resend_phone_code.dart';
import 'package:sil_ui_components/sil_verify_phone_otp.dart';
import 'package:sil_ui_components/src/app_strings.dart';
import 'package:sil_ui_components/src/constants.dart';

import 'mocks.dart';

void main() {
  group('SILVerifyPhoneOtp', () {
    final VerifyPhoneBehaviorSubject verifyPhoneBehaviorSubject =
        VerifyPhoneBehaviorSubject();
    bool testCallback({required String otp, required Function toggleLoading}) {
      return true;
    }

    testWidgets('should render resend otp ', (WidgetTester tester) async {
      await tester.runAsync(() async {
        final Widget testWidget = MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                body: SILVerifyPhoneOtp(
                  appWrapperContext: 'appcontext',
                  client: MockHttpClient,
                  generateOtpFunc: () {},
                  loader: const CircularProgressIndicator(),
                  otp: '123456',
                  phoneNo: '0712345678',
                  retrySendOtpEndpoint: (dynamic val) {
                    return Uri.parse('http://example.com');
                  },
                  successCallBack: testCallback,
                ),
              );
            },
          ),
        );
        await tester.pumpWidget(testWidget);

        await tester.pump();
        expect(find.byType(SILPinCodeTextField), findsOneWidget);
        await tester.tap(find.byType(SILPinCodeTextField));
        await tester.enterText(find.byType(SILPinCodeTextField), '123456');
        await tester.pumpAndSettle();

        expect(find.byKey(resendOtp), findsOneWidget);
        await tester.tap(find.byKey(resendOtp));
        await tester.pumpAndSettle();

        expect(find.text('Resend code'), findsOneWidget);
        expect(find.byKey(cancelResendOtp), findsOneWidget);
        expect(find.byType(SILResendPhoneCode), findsOneWidget);
        expect(find.byKey(resendViaText), findsOneWidget);

        await tester.tap(find.byKey(resendViaText));
        await tester.pumpAndSettle();

        // expect(find.text('$codeSent 0712345678'), findsOneWidget);
      });
    });

    testWidgets('should render SILVerifyPhoneOtp when otp is correct ',
        (WidgetTester tester) async {
      final Widget testWidget = MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: SILVerifyPhoneOtp(
                appWrapperContext: 'appcontext',
                client: MockHttpClient,
                generateOtpFunc: () {},
                loader: const CircularProgressIndicator(),
                otp: '123456',
                phoneNo: '0712345678',
                retrySendOtpEndpoint: () {},
                successCallBack: testCallback,
              ),
            );
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      expect(find.byType(SILPinCodeTextField), findsOneWidget);
      await tester.tap(find.byType(SILPinCodeTextField));
      await tester.enterText(find.byType(SILPinCodeTextField), '123456');

      await tester.pumpAndSettle();

      expect(find.byKey(resendOtp), findsOneWidget);
      await tester.tap(find.byKey(resendOtp));
      await tester.pumpAndSettle();

      expect(find.byKey(cancelResendOtp), findsOneWidget);
      await tester.tap(find.byKey(cancelResendOtp));

      await tester.pumpAndSettle();

      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('should render SILVerifyPhoneOtp when otp is wrong ',
        (WidgetTester tester) async {
      final Widget testWidget = MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: SILVerifyPhoneOtp(
                appWrapperContext: 'appcontext',
                client: MockHttpClient,
                generateOtpFunc: () {},
                loader: const CircularProgressIndicator(),
                otp: '123456',
                phoneNo: '0712345678',
                retrySendOtpEndpoint: () {},
                successCallBack: testCallback,
              ),
            );
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      expect(find.byType(SILPinCodeTextField), findsOneWidget);
      await tester.tap(find.byType(SILPinCodeTextField));

      await tester.enterText(find.byType(SILPinCodeTextField), '123457');
      await tester.pumpAndSettle();
      expect(find.byKey(infoBottomSheetKey), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);

      await tester.tap(find.byType(Image));
      await tester.pumpAndSettle();
      expect(find.byKey(infoBottomSheetKey), findsNothing);
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
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SILVerifyPhoneOtp(
            appWrapperContext: '',
            client: MockHttpClient,
            loader: Container(),
            otp: '123456',
            phoneNo: '',
            retrySendOtpEndpoint: () {},
            successCallBack: testCallback,
            generateOtpFunc: testFunc,
          ),
        ),
      ));
      await tester.showKeyboard(find.byType(SILPinCodeTextField));
      await tester.enterText(find.byType(SILPinCodeTextField), '123456');
      await tester.pumpAndSettle();

      expect(find.byKey(resendOtp), findsOneWidget);
      await tester.tap(find.byKey(resendOtp));
      await tester.pumpAndSettle();

      expect(find.byKey(cancelResendOtp), findsOneWidget);
      await tester.tap(find.byKey(cancelResendOtp));
      await tester.pumpAndSettle();

      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
    });

    testWidgets('should render the loader  ', (WidgetTester tester) async {
      final Widget testWidget = MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: SILVerifyPhoneOtp(
                appWrapperContext: 'appcontext',
                client: MockHttpClient,
                generateOtpFunc: () {},
                loader: const CircularProgressIndicator(),
                otp: '123456',
                phoneNo: '0712345678',
                retrySendOtpEndpoint: () {},
                successCallBack: testCallback,
              ),
            );
          },
        ),
      );

      verifyPhoneBehaviorSubject.loading.add(true);
      await tester.pumpWidget(testWidget);

      expect(find.byType(SILPinCodeTextField), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'should call custom callback when change number button is pressed',
        (WidgetTester tester) async {
      const SnackBar snackBar =
          SnackBar(content: Text('Change number clicked'));
      final Widget testWidget = MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: SILVerifyPhoneOtp(
                appWrapperContext: 'appcontext',
                client: MockHttpClient,
                generateOtpFunc: () {},
                loader: const CircularProgressIndicator(),
                otp: '123456',
                phoneNo: '0712345678',
                retrySendOtpEndpoint: () {},
                successCallBack: testCallback,
                changeNumberCallback: () {
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              ),
            );
          },
        ),
      );
      verifyPhoneBehaviorSubject.loading.add(false);

      await tester.pumpWidget(testWidget);
      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.byType(ScaffoldMessenger), findsOneWidget);
    });

    testWidgets(
        'should navigate when change number button is pressed and custom callback is null',
        (WidgetTester tester) async {
      final Widget testWidget = MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: SILVerifyPhoneOtp(
                appWrapperContext: 'appcontext',
                client: MockHttpClient,
                generateOtpFunc: () {},
                loader: const CircularProgressIndicator(),
                otp: '123456',
                phoneNo: '0712345678',
                retrySendOtpEndpoint: () {},
                successCallBack: testCallback,
              ),
            );
          },
        ),
      );
      verifyPhoneBehaviorSubject.loading.add(false);

      await tester.pumpWidget(testWidget);
      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.byType(TextButton), findsNothing);
    });

    testWidgets('should resend OTP sucessfully', (WidgetTester tester) async {
      await tester.runAsync(() async {
        Future<String> testFunc({
          required String phoneNumber,
          required int step,
          required dynamic client,
        }) {
          return Future<String>.value('1234');
        }

        final Widget testWidget = MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                body: SILVerifyPhoneOtp(
                  appWrapperContext: 'appcontext',
                  client: MockHttpClient(),
                  httpClient: MockHttpClient(),
                  generateOtpFunc: testFunc,
                  loader: const CircularProgressIndicator(),
                  otp: '123456',
                  phoneNo: '+0712345678',
                  retrySendOtpEndpoint: (dynamic val) {
                    return Uri.parse('http://example.com');
                  },
                  successCallBack: testCallback,
                ),
              );
            },
          ),
        );

        await tester.pumpWidget(testWidget);

        expect(find.byType(SILPinCodeTextField), findsOneWidget);
        await tester.tap(find.byType(SILPinCodeTextField));
        await tester.enterText(find.byType(SILPinCodeTextField), '123456');

        await tester.pumpAndSettle();

        expect(find.byKey(resendOtp), findsOneWidget);
        await tester.tap(find.byKey(resendOtp));
        await tester.pumpAndSettle();

        expect(find.byKey(resendViaText), findsOneWidget);
        await tester.tap(find.byKey(resendViaText));
        await tester.pumpAndSettle();

        expect(find.byType(Image), findsOneWidget);
        await tester.tap(find.byType(Image));

        await tester.pumpAndSettle();

        expect(find.byKey(cancelResendOtp), findsNothing);
      });
    });
  });
}
