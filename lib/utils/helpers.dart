import 'package:flutter/foundation.dart';
import 'package:sil_ui_components/utils/constants.dart';

String formatPhoneNumber(
    {@required String? countryCode, @required String? phoneNumber}) {
  String? code = countryCode;
  String? phone = phoneNumber;
  if (!countryCode!.startsWith('+')) {
    code = '+$code';
  }
  if (code == '+1') {
    return '$code$phone';
  }
  if (phoneNumber!.startsWith('0')) {
    phone = phone!.substring(1);
  }
  return '$code$phone';
}

bool alignLabelWithHint(int? maxLines) => maxLines != null && maxLines > 1;

Country popValue(String name) {
  switch (name) {
    case 'kenya':
      return Country.kenya;
    case 'uganda':
      return Country.uganda;
    case 'tanzania':
      return Country.tanzania;
    default:
      return Country.us;
  }
}
