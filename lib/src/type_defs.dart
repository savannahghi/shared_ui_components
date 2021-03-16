import 'package:flutter/material.dart';

/// callback that is passed to a form fields [onChanged] of [onValue]
typedef FormFieldCallback = dynamic Function(dynamic value);

typedef SettingsFunc = Future<void> Function(
    {@required bool value, @required BuildContext context});

///GenerateRetryOtpFunc is the method that will called to generate and send an otp
/// The signature should the one defined in sil_graphql_utils
typedef GenerateRetryOtpFunc = Future<String> Function({
  @required String phoneNumber,
  @required int step,
  @required dynamic client,
});
