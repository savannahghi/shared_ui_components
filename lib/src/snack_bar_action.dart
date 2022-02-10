import 'package:flutter/material.dart';

import 'package:shared_themes/text_themes.dart';

/// A button for a [SnackBar], known as an "action".
///
/// Snack bar actions are always enabled. If you want to disable a snack bar
/// action, simply don't include it in the snack bar.
///
/// Snack bar actions can only be pressed once. Subsequent presses are ignored.
///
/// See also:
///
///  * [SnackBar]
///  * <https://material.io/design/components/snackbars.html>
class SILSnackBarAction extends StatefulWidget {
  /// Creates an action for a [SnackBar].
  ///
  /// The [label] and [onPressed] arguments must be non-null.
  const SILSnackBarAction({
    Key? key,
    this.textColor,
    this.disabledTextColor,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  /// The button disabled label color. This color is shown after the
  /// [SnackBarAction] is dismissed.
  final Color? disabledTextColor;

  /// The button label.
  final String label;

  /// The callback to be called when the button is pressed. Must not be null.
  ///
  /// This callback will be called at most once each time this action is
  /// displayed in a [SnackBar].
  final VoidCallback onPressed;

  /// The button label color. If not provided, defaults to
  /// [SnackBarThemeData.actionTextColor].
  final Color? textColor;

  @override
  State<SILSnackBarAction> createState() => _SILSnackBarActionState();
}

class _SILSnackBarActionState extends State<SILSnackBarAction> {
  bool _haveTriggeredAction = false;

  void _handlePressed() {
    if (_haveTriggeredAction) {
      return;
    }
    setState(() {
      _haveTriggeredAction = true;
    });
    widget.onPressed();
    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar(reason: SnackBarClosedReason.action);
  }

  @override
  Widget build(BuildContext context) {
    final SnackBarThemeData snackBarTheme = Theme.of(context).snackBarTheme;
    final Color? textColor = widget.textColor ?? snackBarTheme.actionTextColor;

    return GestureDetector(
      onTap: _haveTriggeredAction ? null : _handlePressed,
      child: Text(
        widget.label,
        style: TextThemes.boldSize14Text(textColor),
      ),
    );
  }
}
