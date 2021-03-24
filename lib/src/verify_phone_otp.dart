import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import 'package:sil_themes/spaces.dart';
import 'package:sil_themes/text_themes.dart';
import 'package:sil_ui_components/sil_buttons.dart';
import 'package:sil_ui_components/sil_inputs.dart';
import 'package:sil_ui_components/src/animated_count.dart';
import 'package:sil_ui_components/src/constants.dart';
import 'package:sil_ui_components/src/helpers.dart';

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
    this.setValues,
  }) : super(key: key);

  final dynamic appWrapperContext;
  final dynamic client;
  final Function generateOtpFunc;
  final Widget loader;
  final String otp;
  final String phoneNo;
  /// endpoint
  final Function retrySendOtpEndpoint;

  final Function? setValues;
  final Function successCallBack;

  @override
  _SILVerifyPhoneOtpState createState() => _SILVerifyPhoneOtpState();
}

class _SILVerifyPhoneOtpState extends State<SILVerifyPhoneOtp>
    with SingleTickerProviderStateMixin {
  Animation<double>? animation;
  bool canResend = false;
  BehaviorSubject<bool> canResendOtp = BehaviorSubject<bool>.seeded(false);
  bool loading = false;
  String? otp;
  int resendTimeout = 30;
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
    resendTimeout = 30;
    _controller.value = 0;
    _controller.forward();
    canResendOtp.add(false);
  }

  void toggleLoading() {
    setState(() {
      loading = !loading;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            await HapticFeedback.vibrate();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Invalid Code'),
              ),
            );
            textEditingController.clear();
          },
        ),
        largeVerticalSizedBox,
        if (loading) ...<Widget>[
          mediumVerticalSizedBox,
          widget.loader,
        ],
        if (!loading) ...<Widget>[
          if (!canResend)
            AnimatedCount(
              count: resendTimeout,
              duration: const Duration(),
            ),
          if (canResend)
            SILSecondaryButton(
              buttonKey: const Key('resendOtpCode'),
              textColor: Theme.of(context).primaryColor,
              onPressed: () async {
                final String res = await showResendBottomSheet(
                  context: context,
                  phoneNo: widget.phoneNo,
                  loader: widget.loader,
                  resetTimer: restartTimer,
                  generateOtpFunc: widget.generateOtpFunc,
                  client: widget.client,
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
          if (widget.setValues != null)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
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
