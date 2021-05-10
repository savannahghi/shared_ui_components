import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:rxdart/rxdart.dart';

import 'package:sil_themes/spaces.dart';
import 'package:sil_themes/text_themes.dart';
import 'package:sil_ui_components/sil_buttons.dart';
import 'package:sil_ui_components/sil_inputs.dart';
import 'package:sil_ui_components/src/animated_count.dart';
import 'package:sil_ui_components/src/app_strings.dart';
import 'package:sil_ui_components/src/constants.dart';
import 'package:sil_ui_components/src/helpers.dart';
import 'package:sil_ui_components/src/show_info_bottomsheet.dart';

class SILVerifyPhoneOtp extends StatefulWidget {
  const SILVerifyPhoneOtp({
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

  @override
  _SILVerifyPhoneOtpState createState() => _SILVerifyPhoneOtpState();
}

class _SILVerifyPhoneOtpState extends State<SILVerifyPhoneOtp>
    with SingleTickerProviderStateMixin {
  Animation<double>? animation;
  bool canResend = false;
  BehaviorSubject<bool> canResendOtp = BehaviorSubject<bool>.seeded(false);
  VerifyPhoneBehaviorSubject verifyPhoneBehaviorSubject =
      VerifyPhoneBehaviorSubject();
  String? otp;
  int resendTimeout = 60;
  TextEditingController textEditingController = TextEditingController();

  late AnimationController _controller;

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
    // explicitly set it to 90 to allow the user to cancel the bottomsheet then enter th otp
    resendTimeout = 90;
    _controller.value = 0;
    _controller.forward();
    canResendOtp.add(false);
  }

  void toggleLoading() {
    final bool loading = verifyPhoneBehaviorSubject.loading.valueWrapper!.value;
    verifyPhoneBehaviorSubject.loading.add(!loading);
  }

  @override
  Widget build(BuildContext context) {
    final bool isloading =
        verifyPhoneBehaviorSubject.loading.valueWrapper!.value;

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
          onTextChanged: (dynamic val) {},
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
        ),
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
            TextButton(
              onPressed: () {
                if (widget.changeNumberCallback != null) {
                  widget.changeNumberCallback!();
                } else {
                  Navigator.pop(context);
                }
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
