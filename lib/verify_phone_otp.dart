import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sil_dumb_widgets/sil_snackbar.dart';
import 'package:sil_dumb_widgets/types/type_defs.dart';
import 'package:sil_themes/spaces.dart';
import 'package:sil_themes/text_themes.dart';

import 'animated_count.dart';
import 'resend_phone_code.dart';
import 'sil_buttons.dart';
import 'sil_inputs.dart';
import 'utils/constants.dart';

class VerifyPhoneOtp extends StatefulWidget {
  final String phoneNo;
  final String otp;
  final Function setValues;
  final Function successCallBack;
  final Widget loader;
  final GenerateRetryOtpFunc generateOtpFunc;
  final dynamic client;
  final dynamic appWrapperContext;
  final BuildContext context;

  /// endpoint
  final Function retrySendOtpEndpoint;

  const VerifyPhoneOtp({
    Key key,
    @required this.phoneNo,
    @required this.otp,
    @required this.successCallBack,
    @required this.loader,
    @required this.generateOtpFunc,
    @required this.client,
    @required this.retrySendOtpEndpoint,
    @required this.appWrapperContext,
    @required this.context,
    this.setValues,
  }) : super(key: key);
  @override
  _VerifyPhoneOtpState createState() => _VerifyPhoneOtpState();
}

class _VerifyPhoneOtpState extends State<VerifyPhoneOtp>
    with SingleTickerProviderStateMixin {
  TextEditingController textEditingController = TextEditingController();
  bool loading = false;
  BehaviorSubject<bool> canResendOtp = BehaviorSubject<bool>.seeded(false);
  int resendTimeout = 30;
  Animation<double> animation;
  AnimationController _controller;
  String otp;
  bool canResend = false;

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
              resendTimeout = int.parse(animation.value.toStringAsFixed(0));
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

  @override
  void didChangeDependencies() {
    canResendOtp.listen((bool value) {
      setState(() {
        canResend = value;
      });
    });
    super.didChangeDependencies();
  }

  void toggleLoading() {
    setState(() {
      loading = !loading;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            showAlertSnackBar(context: context, message: 'Invalid code');
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
              duration: Duration(seconds: 0),
            ),
          if (canResend)
            SILSecondaryButton(
              textColor: Theme.of(context).primaryColor,
              onPressed: () async {
                String res = await showResendBottomSheet(
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
              text: PhoneNoConstants.sendCodeAgain,
            ),
          size15VerticalSizedBox,
          if (widget.setValues != null)
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                PhoneNoConstants.changeNo,
                style: TextThemes.normalSize16Text(Colors.blue),
              ),
            ),
        ],
        largeVerticalSizedBox
      ],
    );
  }
}
