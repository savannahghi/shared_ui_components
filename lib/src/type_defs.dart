import 'package:flutter/material.dart';

typedef SettingsFunc = Future<void> Function(
    {required bool value, required BuildContext context});

/// callback that is passed to a form fields [onChanged] of [onValue]
typedef FormFieldCallback = String Function(String? value);
typedef TextFieldCallback = void Function(String value);

typedef PhoneNumberFormatterFunc = String Function(
    {required String countryCode, required String phoneNumber});

typedef OnOTPReceivedNavigateCallback = void Function(String value);
