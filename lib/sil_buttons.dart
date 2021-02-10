import 'package:flutter/material.dart';
import 'package:sil_themes/text_themes.dart';

class SILPrimaryButton extends StatelessWidget {
  const SILPrimaryButton(
      {this.buttonKey,
      @required this.onPressed,
      this.onLongPress,
      this.text,
      this.buttonColor,
      this.borderColor,
      this.textColor,
      this.customChild,
      this.customRadius,
      this.customPadding,
      this.customElevation})
      : assert(onPressed != null, text != null || customChild != null);

  final Color borderColor;
  final Color buttonColor;
  final Key buttonKey;
  final Widget customChild;
  final double customElevation;
  final EdgeInsets customPadding;
  final double customRadius;
  final Function onLongPress;
  final Function onPressed;
  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      key: buttonKey,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      elevation: customElevation ?? 0,
      onPressed: onPressed,
      onLongPress: onLongPress ?? () {},
      padding: customPadding ?? EdgeInsets.all(10),
      child: customChild ??
          Text(text ?? '',
              style: TextThemes.veryBoldSize15Text(textColor ?? Colors.white)),
      fillColor: buttonColor ?? Theme.of(context).accentColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(customRadius ?? 25.0),
        side: BorderSide(
            color: borderColor ?? Theme.of(context).accentColor,
            width: borderColor != null ? 1 : 0),
      ),
    );
  }
}

class SILSecondaryButton extends StatelessWidget {
  const SILSecondaryButton({
    this.buttonKey,
    @required this.onPressed,
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

  final bool addBorder;
  final Color borderColor;
  final Color buttonColor;
  final Key buttonKey;
  final Widget customChild;
  final double customElevation;
  final EdgeInsets customPadding;
  final double customRadius;
  final Function onPressed;
  final String text;
  final Color textColor;
  final Function onLongPress;

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      key: buttonKey,
      onPressed: onPressed,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      padding:
          customPadding ?? EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: customChild ??
          Text(
            text ?? '',
            style: TextThemes.veryBoldSize15Text(
                textColor ?? Theme.of(context).primaryColor),
          ),
      color: buttonColor ?? Theme.of(context).accentColor,
      borderSide: addBorder == true
          ? BorderSide(
              color: borderColor ?? Theme.of(context).accentColor, width: 1)
          : null,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(customRadius ?? 25.0)),
    );
  }
}

class SILNoBorderButton extends StatelessWidget {
  const SILNoBorderButton(
      {this.buttonKey,
      @required this.onPressed,
      @required this.text,
      this.onLongPress,
      this.textColor,
      this.customChild})
      : assert(onPressed != null && text != null);

  final Key buttonKey;
  final Widget customChild;
  final Function onLongPress;
  final Function onPressed;
  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      key: buttonKey,
      onPressed: onPressed,
      onLongPress: onLongPress ?? () {},
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: customChild ??
          Text(
            text ?? '',
            style: TextThemes.veryBoldSize15Text(
                textColor ?? Theme.of(context).primaryColor),
          ),
      textColor: textColor ?? Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
    );
  }
}

class SILIconButton extends StatelessWidget {
  const SILIconButton({Key key, @required this.icon, this.callback})
      : super(key: key);

  final Function callback;
  final int elevation = 0;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints(minWidth: 50, minHeight: 50),
      onPressed: callback,
      child: Container(
        height: 25,
        width: 25,
        child: Icon(icon, color: Colors.white, size: 25),
      ),
      shape: CircleBorder(),
      elevation: 0,
      fillColor: Theme.of(context).accentColor,
    );
  }
}
