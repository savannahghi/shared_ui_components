import 'package:flutter/material.dart';

import 'package:http/http.dart';

import 'package:shared_themes/spaces.dart';
import 'package:shared_themes/text_themes.dart';
import 'package:shared_ui_components/src/helpers.dart';
import 'package:shared_ui_components/src/widget_keys.dart';

import 'buttons.dart';
import 'constants.dart';

/// This is a phone otp resend widget
/// Resend via authenticated(graph) or unauthenticated endpoint
enum ResendVia { graph, endpoint }

/// Used to resend a verification code
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

  /// Widget used on loading state
  final Widget loader;

  /// Phone number to send otp to
  final String phoneNumber;

  /// Resend via option (graph or endpoint)
  final ResendVia resendVia;
  final Function resetTimer;
  final Function onOtpCallback;
  final Client? httpClient;

  /// Endpoint
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

  /// Resend Verfification code using endpoint
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

  /// Resend Verfification code using graph
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
              /// Resend via Text
              ListTile(
                key: resendViaText,
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

              /// Resend via Whatsapp
              ListTile(
                key: sendViaWhatsappKey,
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
                errorOccurredText,
                key: errorOccurred,
              ),
              size15VerticalSizedBox,
              SILSecondaryButton(
                buttonKey: hasErrorResendBtnKey,
                onPressed: () {
                  resendCode(context);
                },
                text: retryText,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
