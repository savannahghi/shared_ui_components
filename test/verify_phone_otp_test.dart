import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui_components/inputs.dart';
import 'package:shared_ui_components/resend_phone_code.dart';
import 'package:shared_ui_components/verify_phone_otp.dart';
import 'package:shared_ui_components/src/app_strings.dart';
import 'package:shared_ui_components/src/widget_keys.dart';

import 'mocks.dart';

void main() {
  group('VerifyPhoneOtp', () {
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
                body: VerifyPhoneOtp(
                  appWrapperContext: 'AppContext',
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

        // get the state
        final State<StatefulWidget> testState = tester.allStates.singleWhere(
            (State<StatefulWidget> element) =>
                element.toString() == verifyOTPState);

        // check if it is null
        expect(testState, isNotNull);

        // call the method
        final VerifyPhoneOtpState verifyPhoneOtpState =
            testState as VerifyPhoneOtpState;
        verifyPhoneOtpState.codeUpdated();

        // assert that is was called
        expect(() => verifyPhoneOtpState.codeUpdated(), returnsNormally);

        // expect(find.text('$codeSent 0712345678'), findsOneWidget);
      });
    });

    testWidgets('should render VerifyPhoneOtp when otp is correct ',
        (WidgetTester tester) async {
      final Widget testWidget = MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: VerifyPhoneOtp(
                appWrapperContext: 'AppContext',
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

    testWidgets('should render VerifyPhoneOtp when otp is wrong ',
        (WidgetTester tester) async {
      final Widget testWidget = MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: VerifyPhoneOtp(
                appWrapperContext: 'AppContext',
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
          body: VerifyPhoneOtp(
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
              body: VerifyPhoneOtp(
                appWrapperContext: 'AppContext',
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
              body: VerifyPhoneOtp(
                appWrapperContext: 'AppContext',
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
              body: VerifyPhoneOtp(
                appWrapperContext: 'AppContext',
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

    testWidgets('should resend OTP successfully', (WidgetTester tester) async {
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
                body: VerifyPhoneOtp(
                  appWrapperContext: 'AppContext',
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
