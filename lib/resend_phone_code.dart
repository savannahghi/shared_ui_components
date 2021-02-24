import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:sil_dumb_widgets/sil_snackbar.dart';
import 'package:sil_dumb_widgets/types/type_defs.dart';
import 'package:sil_themes/spaces.dart';
import 'package:sil_themes/text_themes.dart';

import 'sil_buttons.dart';
import 'utils/constants.dart';

class SILException implements Exception {
  final dynamic message;
  final dynamic cause;

  SILException({@required this.cause, @required this.message});
}

/// this is a phone otp resend widget
/// tell it to resend via authenticated(graph) or unauthenticated endpoint

enum ResendVia { graph, endpoint }

class ResendPhoneCode extends StatefulWidget {
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

  const ResendPhoneCode(
      {Key key,
      @required this.phoneNumber,
      @required this.resetTimer,
      @required this.loader,
      @required this.client,
      @required this.generateOtpFunc,
      @required this.retrySendOtpEndpoint,
      @required this.appWrapperContext,
      this.resendVia = ResendVia.endpoint})
      : super(key: key);
  @override
  _ResendPhoneCodeState createState() => _ResendPhoneCodeState();
}

class _ResendPhoneCodeState extends State<ResendPhoneCode>
    with SingleTickerProviderStateMixin {
  bool resending = false;
  bool hasErr = false;
  int step = 1;
  Function resendCode;

  @override
  void initState() {
    resendCode =
        widget.resendVia == ResendVia.endpoint ? endpointResend : graphResend;
    super.initState();
  }

  Future<void> endpointResend(BuildContext context) async {
    toggleResend();
    showErr(false);
    try {
      http.Response response = await http.Client().post(
        widget.retrySendOtpEndpoint(widget.appWrapperContext),
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
      showErr(true);
      showAlertSnackBar(context: context);
      throw SILException(cause: 'network_error', message: e.message);
    }
  }

  Future<void> graphResend(BuildContext context) async {
    toggleResend();
    showErr(false);
    try {
      // do the resend here
      dynamic otp = await widget.generateOtpFunc(
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
      showErr(true);
      showAlertSnackBar(context: context);
    }
  }

  void toggleResend() {
    setState(() {
      resending = !resending;
    });
  }

  void showErr(bool val) {
    setState(() {
      hasErr = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      vsync: this,
      duration: Duration(milliseconds: 200),
      child: Container(
        constraints: BoxConstraints(maxWidth: 500),
        child: Column(
          children: <Widget>[
            if (resending) widget.loader,
            if (!resending) ...<Widget>[
              ListTile(
                leading: Icon(Icons.message_outlined),
                title: Text(
                  PhoneNoConstants.viaText,
                  style: TextThemes.normalSize16Text(),
                ),
                onTap: () {
                  step = 2;
                  resendCode(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.chat),
                title: Text(
                  PhoneNoConstants.viaWhatsApp,
                  style: TextThemes.normalSize16Text(),
                ),
                onTap: () {
                  step = 1;
                  resendCode(context);
                },
              ),
            ],
            if (hasErr) ...<Widget>[
              Text('An error occurred'),
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

Future<String> showResendBottomSheet({
  @required BuildContext context,
  @required String phoneNo,
  @required Widget loader,
  @required Function resetTimer,
  @required GenerateRetryOtpFunc generateOtpFunc,
  @required dynamic appWrapperContext,
  @required dynamic client,
  @required Function retrySendOtpEndpoint,
}) async {
  dynamic res = await showModalBottomSheet<dynamic>(
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 50,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Resend code',
                      style: TextThemes.boldSize20Text(
                          Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Cancel',
                        style: TextThemes.boldSize14Text(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(color: Colors.grey.withOpacity(0.3)),
            )),
          ),
          // ---
          size15VerticalSizedBox,
          ResendPhoneCode(
              phoneNumber: phoneNo,
              resetTimer: resetTimer ?? () {},
              loader: loader,
              appWrapperContext: appWrapperContext,
              client: client,
              retrySendOtpEndpoint: retrySendOtpEndpoint,
              generateOtpFunc: generateOtpFunc),
          size15VerticalSizedBox
        ],
      );
    },
  );
  if (res.runtimeType == String) {
    showAlertSnackBar(
        context: context,
        message: '${PhoneNoConstants.codeSent} $phoneNo',
        type: SnackBarType.success);
    return res;
  }
  showAlertSnackBar(
      context: context,
      message: PhoneNoConstants.resendCancel,
      type: SnackBarType.info);
  return 'err';
}
