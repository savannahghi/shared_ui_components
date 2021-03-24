import 'package:flutter/widgets.dart';

final DateTime now = DateTime.now();
final int currentYear = now.year;
final int currentMonth = now.month;
final int currentDay = now.day;
final int oldestYear = currentYear - 122;
final DateTime eligibleYear =
    DateTime(currentYear - 18, currentMonth, currentDay);

// This value is subject to discussion
final int eligibleFutureYear = currentYear + 5;

const String allowPhoneComm = 'Please allow use of your phone number';
const String createAcc = 'Create account';
const String enterNo = 'Enter your phone number';
const String createAccDesc = 'Use your phone number to create an account';
const String userExists = 'User with that phone number exists. Please sign in';
const String verifyPhone = 'Verify phone number';
String verifyDesc(String phoneNo) {
  return 'We have sent a 6 digit code to $phoneNo. Enter the code below to proceed';
}

const String sendCodeAgain = ' Send the code again ';
const String changeNo = 'Change number';
const String codeSent = 'Code was resent successfully to';
const String resendCancel = 'Resend cancelled';
const String viaText = 'via Text Message';
const String viaWhatsApp = 'via WhatsApp';
const String noAccount =
    'That phone number does not exist, please enter the number you registered with';

const String tryFeaturesPageTitle = 'Try New Features settings';

const String tryFeaturesTitle = 'Want to be on the edge side';

const String tryFeaturesDescription =
    'Be the first to see whats next for Be.Well. Join the community and give us your feedback to help make Be.Well even better, together. The new features will be unstable and might introduce unwanted breakage.';

const String tryFeaturesNotice =
    'You can always switch back anytime you want to';

const String tryFeaturesImgUrl =
    'packages/sil_ui_components/assets/try_features.jpg';

final Map<String, String> requestHeaders = <String, String>{
  'Accept': 'application/json',
  'Content-Type': 'application/json',
};

const String bewellLogoNetworkUrl =
    'https://assets.healthcloud.co.ke/bewell_logo.png';

enum Country { kenya, uganda, tanzania, us }

Map<String, Map<String, String>> supportedCountries =
    <String, Map<String, String>>{
  'kenya': <String, String>{
    'code': '+254',
    'initial': 'KE',
    'name': 'Kenya',
    'flag': 'packages/sil_ui_components/assets/ke.png',
  },
  'uganda': <String, String>{
    'code': '+255',
    'initial': 'UG',
    'name': 'Uganda',
    'flag': 'packages/sil_ui_components/assets/ug.png',
  },
  'tanzania': <String, String>{
    'code': '+256',
    'initial': 'TZ',
    'name': 'Tanzania',
    'flag': 'packages/sil_ui_components/assets/tz.png',
  },
  'usa': <String, String>{
    'code': '+1',
    'initial': 'USA',
    'name': 'United States',
    'flag': 'packages/sil_ui_components/assets/us.png',
  },
};

const Duration snackBarTransitionDuration = Duration(milliseconds: 250);
const Duration snackBarDisplayDuration = Duration(milliseconds: 4000);
const Curve snackBarHeightCurve = Curves.fastOutSlowIn;
const Curve snackBarFadeInCurve =
    Interval(0.45, 1.0, curve: Curves.fastOutSlowIn);
const Curve snackBarFadeOutCurve =
    Interval(0.72, 1.0, curve: Curves.fastOutSlowIn);

/// holds sill snackbar types
enum SnackBarType {
  success,
  danger,
  warning,
  info,
}
