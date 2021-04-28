import 'dart:convert';

import 'package:http/http.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sil_themes/spaces.dart';
import 'package:sil_themes/text_themes.dart';
import 'package:sil_ui_components/sil_resend_phone_code.dart';
import 'package:sil_ui_components/src/app_strings.dart';
import 'package:sil_ui_components/src/constants.dart';
import 'package:sil_ui_components/src/show_info_bottomsheet.dart';
import 'package:sil_ui_components/src/type_defs.dart';

bool alignLabelWithHint(int? maxLines) => maxLines != null && maxLines > 1;

Country popValue(String name) {
  switch (name) {
    case 'Kenya':
      return Country.kenya;
    case 'Uganda':
      return Country.uganda;
    case 'Tanzania':
      return Country.tanzania;
    default:
      return Country.us;
  }
}

Map<String, String>? getCountry(Country country) {
  switch (country) {
    case Country.kenya:
      return supportedCountries['kenya'];
    case Country.uganda:
      return supportedCountries['uganda'];
    case Country.tanzania:
      return supportedCountries['tanzania'];
    default:
      return supportedCountries['usa'];
  }
}

dynamic selectCountryModalBottomSheet(BuildContext context) {
  return showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SizedBox(
          child: Wrap(
            children: <Widget>[
              for (Map<String, String> country in supportedCountries.values)
                ListTile(
                  leading: Image.asset(
                    country['flag']!,
                    height: 25,
                  ),
                  title: Text(country['name']!),
                  onTap: () {
                    Navigator.of(context).pop(popValue(country['name']!));
                  },
                ),
            ],
          ),
        );
      });
}

Future<String> showResendBottomSheet({
  required BuildContext context,
  required String phoneNo,
  required Widget loader,
  required Function? resetTimer,
  required Function generateOtpFunc,
  required dynamic appWrapperContext,
  required dynamic client,
  required Function retrySendOtpEndpoint,
  final Client? httpClient,
}) async {
  final dynamic res = await showModalBottomSheet<dynamic>(
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(color: Colors.grey.withOpacity(0.3)),
            )),
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
                        key: cancelResendOtp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ---
          size15VerticalSizedBox,
          SILResendPhoneCode(
              phoneNumber: phoneNo,
              resetTimer: resetTimer ?? () {},
              loader: loader,
              appWrapperContext: appWrapperContext,
              client: client,
              retrySendOtpEndpoint: retrySendOtpEndpoint,
              httpClient: httpClient,
              generateOtpFunc: generateOtpFunc),
          size15VerticalSizedBox
        ],
      );
    },
  );
  if (res.runtimeType == String) {
    await showFeedbackBottomSheet(
      context: context,
      modalContent: '$codeSent $phoneNo',
      imageAssetPath: infoIconUrl,
    );
    return res as Future<String>;
  }

  await showFeedbackBottomSheet(
    context: context,
    modalContent: resendCancel,
    imageAssetPath: errorIconUrl,
  );
  return 'err';
}

/// [titleCase] returns a title cased sentence
String titleCase(String sentence) {
  return sentence
      .toLowerCase()
      .split(' ')
      .map((String e) => e.trim())
      .map((String word) => toBeginningOfSentenceCase(word))
      .join(' ');
}

/// [useEndpointResend] send a resend otp request via REST endpoint. This function should only be used in the context
/// of [SILResendPhoneCode] widget. It's extracted here for testability
Future<void> useEndpointResend(
    {required BuildContext context,
    required dynamic appWrapperContext,
    required String phoneNumber,
    required int step,
    required Function retrySendOtpEndpoint,
    required Function toggleResend,
    required Function showErr,
    required Function resetTimer,
    required OnOTPReceivedNavigateCallback onOTPCallback,
    Client? httpClient}) async {
  final Client _client = httpClient ?? Client();

  toggleResend();
  showErr(val: false);
  try {
    final Response response = await _client.post(
      Uri.parse(retrySendOtpEndpoint(appWrapperContext).toString()),
      body: json.encode(<String, dynamic>{
        'phoneNumber': phoneNumber,
        'retryStep': step,
      }),
      headers: requestHeaders,
    );

    // reset the timer
    resetTimer();

    // return the new otp
    // Navigator.pop(context, json.decode(response.body)['otp']  );
    final Map<String, dynamic> body =
        json.decode(response.body) as Map<String, dynamic>;

    onOTPCallback(body['otp'] as String);
    toggleResend();
  } catch (e) {
    toggleResend();
    showErr(val: true);
  }
}

Future<void> useGraphResend({
  required BuildContext context,
  required dynamic appWrapperContext,
  required String phoneNumber,
  required int step,
  required Function toggleResend,
  required Function showErr,
  required Function resetTimer,
  required Function generateOtpFunc,
  required dynamic client,
  required OnOTPReceivedNavigateCallback onOTPCallback,
}) async {
  toggleResend();
  showErr(val: false);
  try {
    // do the resend here
    final dynamic otp = await generateOtpFunc(
        client: client, phoneNumber: phoneNumber, step: step);

    if (otp == 'Error') {
      throw 'Could not regenerate otp';
    } else {
      // reset the timer
      resetTimer();

      // return the new otp
      onOTPCallback(otp as String);
      toggleResend();
    }
  } catch (e) {
    toggleResend();
    showErr(val: true);
  }
}
