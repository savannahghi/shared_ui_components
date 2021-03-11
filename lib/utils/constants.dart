final DateTime now = DateTime.now();
final int currentYear = now.year;
final int currentMonth = now.month;
final int currentDay = now.day;
final int oldestYear = currentYear - 122;
final DateTime eligibleYear =
    DateTime(currentYear - 18, currentMonth, currentDay);

// This value is subject to discussion
final int eligibleFutureYear = currentYear + 5;

class PhoneNoConstants {
  static const String allowPhoneComm = 'Please allow use of your phone number';
  static const String createAcc = 'Create account';
  static const String enterNo = 'Enter your phone number';
  static const String createAccDesc =
      'Use your phone number to create an account';
  static const String userExists =
      'User with that phone number exists. Please sign in';
  static const String verifyPhone = 'Verify phone number';
  static String verifyDesc(String phoneNo) {
    return 'We have sent a 6 digit code to $phoneNo. Enter the code below to proceed';
  }

  static const String sendCodeAgain = ' Send the code again ';
  static const String changeNo = 'Change number';
  static const String codeSent = 'Code was resent successfully to';
  static const String resendCancel = 'Resend cancelled';
  static const String viaText = 'via Text Message';
  static const String viaWhatsApp = 'via WhatsApp';
  static const String noAccount =
      'That phone number does not exist, please enter the number you registered with';
}

class TryNewFeatureStrings {
  static const String pageTitle = 'Try New Features settings';

  static const String title = 'Want to be on the edge side';

  static const String description =
      'Be the first to see whats next for Be.Well. Join the community and give us your feedback to help make Be.Well even better, together. The new features will be unstable and might introduce unwanted breakage.';

  static const String notice = 'You can always switch back anytime you want to';

  static const String tryFeaturesImgUrl = 'assets/images/try_features.jpg';
}

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
    'flag': 'assets/ke.png',
  },
  'uganda': <String, String>{
    'code': '+255',
    'initial': 'UG',
    'name': 'Uganda',
    'flag': 'assets/ug.png',
  },
  'tanzania': <String, String>{
    'code': '+256',
    'initial': 'TZ',
    'name': 'Tanzania',
    'flag': 'assets/tz.png',
  },
  'usa': <String, String>{
    'code': '+1',
    'initial': 'USA',
    'name': 'United States',
    'flag': 'assets/us.png',
  },
};
