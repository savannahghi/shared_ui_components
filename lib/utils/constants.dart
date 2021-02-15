import 'package:flutter/material.dart';

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
  static final String allowPhoneComm = 'Please allow use of your phone number';
  static final String createAcc = 'Create account';
  static final String enterNo = 'Enter your phone number';
  static final String createAccDesc =
      'Use your phone number to create an account';
  static final String userExists =
      'User with that phone number exists. Please sign in';
  static final String verifyPhone = 'Verify phone number';
  static String verifyDesc(String phoneNo) {
    return 'We have sent a 6 digit code to $phoneNo. Enter the code below to proceed';
  }

  static final String sendCodeAgain = ' Send the code again ';
  static final String changeNo = 'Change number';
  static final String codeSent = 'Code was resent successfully to';
  static final String resendCancel = 'Resend cancelled';
  static final String viaText = 'via Text Message';
  static final String viaWhatsapp = 'via WhatsApp';
  static final String noAccount =
      'That phone number does not exist, please enter the number you registered with';
}

class TryNewFeatutesStrings {
  static final String pageTitle = 'Try New Features settings';

  static final String title = 'Want to be on the edge side';

  static final String description =
      'Be the first to see whats next for Be.Well. Join the community and give us your feedback to help make Be.Well even better, together. The new features will be unstable and might introduce unwanted breakage.';

  static final String notice = 'You can always switch back anytime you want to';

  static final String tryFeaturesImgUrl = 'assets/images/try_features.jpg';
}

///GenerateRetryOtpFunc is the method that will called to generate and send an otp
/// The signature should the one defined in sil_graphql_utils
typedef GenerateRetryOtpFunc = Future<String> Function({
  @required String phoneNumber,
  @required int step,
  @required dynamic client,
});

final Map<String, String> requestHeaders = <String, String>{
  'Accept': 'application/json',
  'Content-Type': 'application/json',
};
