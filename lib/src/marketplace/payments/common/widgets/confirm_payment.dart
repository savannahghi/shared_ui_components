import 'package:flutter/material.dart';
import 'package:shared_themes/spaces.dart';
import 'package:shared_themes/text_themes.dart';
import 'package:shared_ui_components/platform_loader.dart';
import 'package:shared_ui_components/src/marketplace/payments/common/strings/strings.dart';
import 'package:shared_ui_components/src/marketplace/payments/common/utils.dart';

class ConfirmPayment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          confirmingPayment,
          style: TextThemes.veryBoldSize28Text().copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: Sizing.size20,
        ),
        Text(
          confirmingPaymentInstructions,
          textAlign: TextAlign.center,
          style: TextThemes.normalSize14Text().copyWith(
            color: textGreyColor,
          ),
        ),
        const SizedBox(
          height: Sizing.size32,
        ),
        const SizedBox(
          height: Sizing.size12,
        ),
        const SILPlatformLoader(),
        const SizedBox(
          height: Sizing.size32,
        ),
        const SizedBox(
          height: Sizing.size32,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            'Back',
            style: TextThemes.normalSize14Text().copyWith(
              color: textGreyColor.withOpacity(0.5),
            ),
          ),
        )
      ],
    );
  }
}
