// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shared_themes/app_theme.dart';
import 'package:shared_themes/spaces.dart';
import 'package:shared_themes/text_themes.dart';
import 'package:shared_ui_components/buttons.dart';
import 'package:shared_ui_components/src/marketplace/payments/common/strings/strings.dart';
import 'package:shared_ui_components/src/marketplace/payments/common/utils.dart';
import 'package:shared_ui_components/src/marketplace/payments/common/widgets/get_help.dart';

class PaymentConfirmationFailed extends StatelessWidget {
  final Function checkAgain;

  const PaymentConfirmationFailed({
    Key? key,
    required this.checkAgain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          paymentConfirmationFailed,
          style: TextThemes.veryBoldSize28Text().copyWith(
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: Sizing.size18,
        ),
        Text(
          paymentConfirmationFailedInstructions,
          textAlign: TextAlign.center,
          style: TextThemes.normalSize16Text()
              .copyWith(color: textGreyColor, height: 1.6),
        ),
        SizedBox(
          height: Sizing.size32,
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: SILPrimaryButton(
            borderColor: Colors.transparent,
            text: checkAgainText,
            buttonColor: AppColors.consumerColors['primaryColor'],
            textColor: Colors.white,
            customRadius: 8,
            customPadding: EdgeInsets.symmetric(vertical: 18),
            onPressed: checkAgain as void Function()?,
          ),
        ),
        SizedBox(
          height: Sizing.size12,
        ),
        GestureDetector(
          onTap: () {
            getHelpBottomSheet(context);
          },
          child: Text(
            getHelpText,
            style: TextThemes.boldSize14Text().copyWith(
              decoration: TextDecoration.underline,
              color: Colors.blue,
            ),
          ),
        )
      ],
    );
  }
}
