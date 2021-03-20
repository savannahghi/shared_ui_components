import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:sil_themes/spaces.dart';
import 'package:sil_themes/text_themes.dart';
import 'package:sil_ui_components/src/type_defs.dart';
import 'package:sil_misc/sil_exception.dart';

import 'buttons.dart';
import 'constants.dart';

/// this is a phone otp resend widget
/// tell it to resend via authenticated(graph) or unauthenticated endpoint
enum ResendVia { graph, endpoint }

class SILResendPhoneCode extends StatefulWidget {
  final String phoneNumber;
  final Function resetTimer;
  final ResendVia resendVia;
  final Widget loader;
  final dynamic client;
  final dynamic appWrapperContext;

  /// [GenerateRetryOtpFunc] will be called to generate a new otp
  final GenerateRetryOtpFunc generateOtpFunc;

  /// endpoint
  final Function retrySendOtpEndpoint;

  const SILResendPhoneCode(
      {required this.phoneNumber,
      required this.resetTimer,
      required this.loader,
      required this.client,
      required this.generateOtpFunc,
      required this.retrySendOtpEndpoint,
      required this.appWrapperContext,
      this.resendVia = ResendVia.endpoint});
  @override
  _SILResendPhoneCodeState createState() => _SILResendPhoneCodeState();
}

class _SILResendPhoneCodeState extends State<SILResendPhoneCode>
    with SingleTickerProviderStateMixin {
  bool resending = false;
  bool hasErr = false;
  int step = 1;
  late Function resendCode;

  @override
  void initState() {
    resendCode =
        widget.resendVia == ResendVia.endpoint ? endpointResend : graphResend;
    super.initState();
  }

  Future<void> endpointResend(BuildContext context) async {
    toggleResend();
    showErr(val: false);
    try {
      final http.Response response = await http.Client().post(
        widget.retrySendOtpEndpoint(widget.appWrapperContext) as Uri,
        body: json.encode(<String, dynamic>{
          'phoneNumber': widget.phoneNumber,
          'retryStep': step,
        }),
        headers: requestHeaders,
      );

      // reset the timer
      widget.resetTimer();

      // return the new otp
      Navigator.pop(context, json.decode(response.body)['otp']);
      toggleResend();
    } catch (e) {
      toggleResend();
      showErr(val: true);
      throw SILException(cause: 'network_error', message: e.toString());
    }
  }

  Future<void> graphResend(BuildContext context) async {
    toggleResend();
    showErr(val: false);
    try {
      // do the resend here
      final dynamic otp = await widget.generateOtpFunc(
          client: widget.client, phoneNumber: widget.phoneNumber, step: step);

      if (otp == 'Error') {
        throw 'Could not regenerate otp';
      } else {
        // reset the timer
        widget.resetTimer();

        // return the new otp
        Navigator.pop(context, otp);
        toggleResend();
      }
    } catch (e) {
      toggleResend();
      showErr(val: true);
    }
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
              const Text('An error occurred'),
              size15VerticalSizedBox,
              SILSecondaryButton(
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
