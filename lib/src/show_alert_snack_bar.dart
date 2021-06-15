import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_themes/constants.dart';
import 'package:shared_themes/text_themes.dart';

import 'package:shared_ui_components/src/constants.dart';
import 'package:shared_ui_components/src/snack_bar.dart';
import 'package:shared_ui_components/src/snack_bar_action.dart';

/// used to show the custom [SilSnackBar]
/// takes an optional title and message
/// also takes an optional action of type [SILSnackBarAction]
/// also takes an optional [SnackBarType]
void showAlertSnackBar({
  required BuildContext context,
  required String title,
  String? message,
  SILSnackBarAction? action,
  SnackBarType? type,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SILSnackBar(
        type: type ?? SnackBarType.info,
        onAction: action,
        title: title,
        content: Text(
          message ?? UserFeedBackTexts.getErrorMessage(),
          textAlign: TextAlign.start,
          style: TextThemes.normalSize12Text().copyWith(height: 1.3),
        ),
        duration: const Duration(seconds: kShortSnackBarDuration),
      ),
    );
  return;
}
