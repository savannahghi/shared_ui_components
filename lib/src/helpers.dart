import 'package:flutter/material.dart';
import 'package:sil_themes/spaces.dart';
import 'package:sil_themes/text_themes.dart';
import 'package:sil_ui_components/sil_resend_phone_code.dart';
import 'package:sil_ui_components/src/constants.dart';
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

// tood :retire this in favor of the one defined in dart utils
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

// todo: this should be retired in favor in sil_misc
Future<String> showResendBottomSheet({
  required BuildContext context,
  required String phoneNo,
  required Widget loader,
  required Function? resetTimer,
  required GenerateRetryOtpFunc generateOtpFunc,
  required dynamic appWrapperContext,
  required dynamic client,
  required Function retrySendOtpEndpoint,
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
              generateOtpFunc: generateOtpFunc),
          size15VerticalSizedBox
        ],
      );
    },
  );
  if (res.runtimeType == String) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$codeSent $phoneNo'),
      ),
    );
    return res as Future<String>;
  }
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(resendCancel),
    ),
  );
  return 'err';
}
