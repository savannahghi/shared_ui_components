import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'package:shared_themes/spaces.dart';
import 'package:shared_themes/text_themes.dart';
import 'package:shared_ui_components/buttons.dart';
import 'package:shared_ui_components/inputs.dart';
import 'package:shared_ui_components/src/animated_count.dart';
import 'package:shared_ui_components/src/app_strings.dart';
import 'package:shared_ui_components/src/constants.dart';
import 'package:shared_ui_components/src/helpers.dart';
import 'package:shared_ui_components/src/show_info_bottomsheet.dart';
import 'package:shared_ui_components/src/widget_keys.dart';

class VerifyPhoneOtp extends StatefulWidget {
  const VerifyPhoneOtp({
    Key? key,
    required this.phoneNo,
    required this.otp,
    required this.successCallBack,
    required this.loader,
    required this.generateOtpFunc,
    required this.client,
    required this.retrySendOtpEndpoint,
    required this.appWrapperContext,
    this.changeNumberCallback,
    this.httpClient,
    this.retryContactVerificationOTP,
  }) : super(key: key);

  final dynamic appWrapperContext;
  final dynamic client;
  final Client? httpClient;
  final Function generateOtpFunc;
  final Widget loader;
  final String otp;
  final String phoneNo;

  /// endpoint
  final Function retrySendOtpEndpoint;

  final Function? changeNumberCallback;
  final Function successCallBack;

  final Function? retryContactVerificationOTP;

  @override
  VerifyPhoneOtpState createState() => VerifyPhoneOtpState();
}

class VerifyPhoneOtpState extends State<VerifyPhoneOtp>
    with SingleTickerProviderStateMixin, CodeAutoFill {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return verifyOTPState;
  }

  Animation<double>? animation;
  bool canResend = false;
  BehaviorSubject<bool> canResendOtp = BehaviorSubject<bool>.seeded(false);
  VerifyPhoneBehaviorSubject verifyPhoneBehaviorSubject =
      VerifyPhoneBehaviorSubject();
  String? otp;
  String testCode = '123456';
  int resendTimeout = 60;
  TextEditingController textEditingController = TextEditingController();

  late AnimationController _controller;

  @override
  void codeUpdated() {
    setState(() {
      // update the controller with the detected code
      textEditingController.text = code ?? testCode;
    });
  }

  @override
  void didChangeDependencies() {
    canResendOtp.listen((bool value) {
      setState(() {
        canResend = value;
      });
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    otp = widget.otp;

    // listen for otp code sent via sms
    listenForCode();
    _controller =
        AnimationController(duration: const Duration(seconds: 30), vsync: this);
    animation = Tween<double>(begin: resendTimeout.toDouble(), end: 0)
        .animate(_controller)
          ..addListener(() {
            if (resendTimeout == 0) {
              canResendOtp.add(true);
            }
            setState(() {
              resendTimeout = int.parse(animation!.value.toStringAsFixed(0));
            });
          });
    _controller.forward();
    super.initState();
  }

  void restartTimer() {
    // explicitly set it to 90 to allow the user to cancel the bottomsheet then enter the otp
    resendTimeout = 90;
    _controller.value = 0;
    _controller.forward();
    canResendOtp.add(false);
  }

  void toggleLoading() {
    final bool loading = verifyPhoneBehaviorSubject.loading.valueOrNull!;
    verifyPhoneBehaviorSubject.loading.add(!loading);
  }

  @override
  Widget build(BuildContext context) {
    final bool isloading = verifyPhoneBehaviorSubject.loading.valueOrNull!;

    return Column(
      children: <Widget>[
        smallVerticalSizedBox,
        SILPinCodeTextField(
            controller: textEditingController,
            autoFocus: true,
            maxLength: 6,
            pinBoxWidth: 40,
            pinBoxHeight: 48,
            wrapAlignment: WrapAlignment.spaceAround,
            onDone: (String v) async {
              if (v == otp) {
                toggleLoading();
                widget.successCallBack(otp: otp, toggleLoading: toggleLoading);
                toggleLoading();
                return;
              }
              showFeedbackBottomSheet(
                context: context,
                modalContent: wrongPINText,
                imageAssetPath: errorIconUrl,
              );
              textEditingController.clear();
              await HapticFeedback.vibrate();
            },
            onTextChanged: (String v) async {
              if (v.length == 6) {
                if (v == otp) {
                  toggleLoading();
                  Future<void>.delayed(const Duration(seconds: 3), () {
                    widget.successCallBack(
                        otp: otp, toggleLoading: toggleLoading);
                    toggleLoading();
                  });
                  return;
                }
              }
            }),
        largeVerticalSizedBox,
        if (isloading == true) ...<Widget>[
          mediumVerticalSizedBox,
          widget.loader,
        ],
        if (isloading == false) ...<Widget>[
          if (!canResend)
            AnimatedCount(
              count: resendTimeout,
              duration: const Duration(),
            ),
          if (canResend)
            SILSecondaryButton(
              buttonKey: resendOtp,
              textColor: Theme.of(context).primaryColor,
              onPressed: () async {
                if (widget.retryContactVerificationOTP != null) {
                  restartTimer();
                  widget.retryContactVerificationOTP!();
                  return;
                }
                final String res = await showResendBottomSheet(
                  context: context,
                  phoneNo: widget.phoneNo,
                  loader: widget.loader,
                  resetTimer: restartTimer,
                  generateOtpFunc: widget.generateOtpFunc,
                  client: widget.client,
                  httpClient: widget.httpClient,
                  retrySendOtpEndpoint: widget.retrySendOtpEndpoint,
                  appWrapperContext: widget.appWrapperContext,
                );
                if (res != 'err') {
                  otp = res;
                }
              },
              text: sendCodeAgain,
            ),
          size15VerticalSizedBox,
          if (widget.changeNumberCallback != null)
            TextButton(
              onPressed: () {
                widget.changeNumberCallback!();
              },
              child: Text(
                changeNo,
                style: TextThemes.normalSize16Text(Colors.blue),
              ),
            ),
        ],
        largeVerticalSizedBox
      ],
    );
  }
}

class VerifyPhoneBehaviorSubject {
  static final VerifyPhoneBehaviorSubject _singleton =
      VerifyPhoneBehaviorSubject._internal();

  factory VerifyPhoneBehaviorSubject() {
    return _singleton;
  }

  VerifyPhoneBehaviorSubject._internal();

  BehaviorSubject<bool> loading = BehaviorSubject<bool>.seeded(false);
}
