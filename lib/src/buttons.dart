import 'package:flutter/material.dart';

import 'package:shared_themes/colors.dart';
import 'package:shared_themes/text_themes.dart';
import 'package:shared_ui_components/src/constants.dart';

typedef OnPressed = Function(String val);

class SILPrimaryButton extends StatelessWidget {
  const SILPrimaryButton({
    this.buttonKey,
    this.onPressed,
    this.onLongPress,
    this.text,
    this.buttonColor,
    this.borderColor,
    this.textColor,
    this.customChild,
    this.customRadius,
    this.customPadding,
    this.customElevation,
  });

  final Color? borderColor;
  final Color? buttonColor;
  final Key? buttonKey;
  final Widget? customChild;
  final double? customElevation;
  final EdgeInsets? customPadding;
  final double? customRadius;
  final Function? onLongPress;
  final void Function()? onPressed;
  final String? text;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      key: buttonKey,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      elevation: customElevation ?? 0,
      onPressed: onPressed,
      onLongPress: () {
        onLongPress!();
      },
      padding: customPadding ?? const EdgeInsets.all(10),
      fillColor: buttonColor ?? accentColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(customRadius ?? 25.0),
        side: BorderSide(
            color: borderColor ?? accentColor,
            width: borderColor != null ? 1 : 0),
      ),
      child: customChild ??
          Text(text ?? '',
              style: TextThemes.veryBoldSize15Text(textColor ?? Colors.white)),
    );
  }
}

class SILSecondaryButton extends StatelessWidget {
  const SILSecondaryButton({
    this.buttonKey,
    required this.onPressed,
    this.text,
    this.buttonColor,
    this.textColor,
    this.customChild,
    this.customRadius,
    this.customPadding,
    this.borderColor,
    this.addBorder = false,
    this.onLongPress,
    this.customElevation,
  }) : assert(onPressed != null, text != null || customChild != null);
  final bool? addBorder;
  final Color? borderColor;
  final Color? buttonColor;
  final Key? buttonKey;
  final Widget? customChild;
  final double? customElevation;
  final EdgeInsets? customPadding;
  final double? customRadius;
  final Function? onLongPress;
  final Function? onPressed;
  final String? text;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: buttonKey,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        primary: Colors.transparent,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: borderColor ?? healthcloudAccentColor),
            borderRadius: BorderRadius.circular(customRadius ?? 25)),
      ),
      onPressed: () => onPressed!(),
      child: customChild ??
          Text(
            text ?? '',
            style: TextThemes.veryBoldSize15Text(
                textColor ?? Theme.of(context).primaryColor),
          ),
    );
  }
}

class SILNoBorderButton extends StatelessWidget {
  const SILNoBorderButton(
      {this.buttonKey,
      required this.onPressed,
      required this.text,
      this.onLongPress,
      this.textColor,
      this.customChild})
      : assert(onPressed != null && text != null);
  final Key? buttonKey;
  final Widget? customChild;
  final Function? onLongPress;
  final Function? onPressed;
  final String? text;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      key: buttonKey,
      onPressed: () {
        onPressed!();
      },
      onLongPress: () {
        if (onLongPress != null) {
          onLongPress!();
        }
      },
      child: customChild ??
          Text(
            text ?? '',
            style: TextThemes.veryBoldSize15Text(
                textColor ?? Theme.of(context).primaryColor),
          ),
    );
  }
}

class SILIconButton extends StatelessWidget {
  const SILIconButton({Key? key, required this.icon, this.callback})
      : super(key: key);
  final Function? callback;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: const BoxConstraints(minWidth: 50, minHeight: 50),
      onPressed: () {
        callback!();
      },
      shape: const CircleBorder(),
      elevation: 0,
      fillColor: accentColor,
      child: SizedBox(
        height: 25,
        width: 25,
        child: Icon(icon, color: Colors.white, size: 25),
      ),
    );
  }
}
