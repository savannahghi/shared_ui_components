import 'package:flutter/material.dart';

import 'package:http/http.dart';

import 'package:sil_themes/spaces.dart';
import 'package:sil_themes/text_themes.dart';
import 'package:sil_ui_components/src/helpers.dart';

import 'buttons.dart';
import 'constants.dart';

/// this is a phone otp resend widget
/// tell it to resend via authenticated(graph) or unauthenticated endpoint
enum ResendVia { graph, endpoint }

class SILResendPhoneCode extends StatefulWidget {
  const SILResendPhoneCode(
      {required this.phoneNumber,
      required this.resetTimer,
      required this.loader,
      required this.client,
      required this.generateOtpFunc,
      required this.retrySendOtpEndpoint,
      required this.appWrapperContext,
      this.onOtpCallback = Navigator.pop,
      this.resendVia = ResendVia.endpoint,
      this.httpClient});

  final dynamic appWrapperContext;
  final dynamic client;
  final Function generateOtpFunc;
  final Widget loader;
  final String phoneNumber;
  final ResendVia resendVia;
  final Function resetTimer;
  final Function onOtpCallback;
  final Client? httpClient;

  /// endpoint
  final Function retrySendOtpEndpoint;

  @override
  _SILResendPhoneCodeState createState() => _SILResendPhoneCodeState();
}

class _SILResendPhoneCodeState extends State<SILResendPhoneCode>
    with SingleTickerProviderStateMixin {
  bool hasErr = false;
  late Function resendCode;
  bool resending = false;
  int step = 1;

  @override
  void initState() {
    resendCode =
        widget.resendVia == ResendVia.endpoint ? endpointResend : graphResend;
    super.initState();
  }

  Future<void> endpointResend(BuildContext context) async {
    return useEndpointResend(
      appWrapperContext: widget.appWrapperContext,
      context: context,
      onOTPCallback: (String value) {
        widget.onOtpCallback(context, value);
      },
      phoneNumber: widget.phoneNumber,
      resetTimer: widget.resetTimer,
      retrySendOtpEndpoint: widget.retrySendOtpEndpoint,
      showErr: showErr,
      step: step,
      toggleResend: toggleResend,
      httpClient: widget.httpClient,
    );
  }

  Future<void> graphResend(BuildContext context) async {
    return useGraphResend(
      appWrapperContext: widget.appWrapperContext,
      context: context,
      onOTPCallback: (String value) {
        widget.onOtpCallback(context, value);
      },
      phoneNumber: widget.phoneNumber,
      resetTimer: widget.resetTimer,
      showErr: showErr,
      step: step,
      toggleResend: toggleResend,
      client: widget.client,
      generateOtpFunc: widget.generateOtpFunc,
    );
  }

  void toggleResend() {
    setState(() {
      resending = !resending;
    });
  }

  void showErr({bool? val}) {
    setState(() {
      hasErr = val!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          children: <Widget>[
            if (resending) widget.loader,
            if (!resending) ...<Widget>[
              ListTile(
                key: const Key('send_via_text_msg'),
                leading: const Icon(Icons.message_outlined),
                title: Text(
                  viaText,
                  style: TextThemes.normalSize16Text(),
                ),
                onTap: () {
                  step = 2;
                  resendCode(context);
                },
              ),
              ListTile(
                key: const Key('send_via_whatsapp_msg'),
                leading: const Icon(Icons.chat),
                title: Text(
                  viaWhatsApp,
                  style: TextThemes.normalSize16Text(),
                ),
                onTap: () {
                  step = 1;
                  resendCode(context);
                },
              ),
            ],
            if (hasErr) ...<Widget>[
              const Text(
                'An error occurred',
                key: Key('has_error'),
              ),
              size15VerticalSizedBox,
              SILSecondaryButton(
                buttonKey: const Key('has_error_resend_btn'),
                onPressed: () {
                  resendCode(context);
                },
                text: ' Retry ',
              ),
            ]
          ],
        ),
      ),
    );
  }
}
