import 'package:flutter/material.dart';
import 'package:shared_themes/app_theme.dart';
import 'package:shared_themes/spaces.dart';
import 'package:shared_themes/text_themes.dart';
import 'package:shared_ui_components/buttons.dart';
import 'package:shared_ui_components/src/marketplace/payments/common/strings/strings.dart';
import 'package:shared_ui_components/src/marketplace/payments/common/utils.dart';

class PendingSupportIssue extends StatelessWidget {
  final Function refresh;

  const PendingSupportIssue({Key? key, required this.refresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          holdOnText,
          style: TextThemes.veryBoldSize28Text().copyWith(
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(
          height: Sizing.size18,
        ),
        Text(
          holdOnInstructions,
          textAlign: TextAlign.center,
          style: TextThemes.normalSize16Text()
              .copyWith(color: textGreyColor, height: 1.6),
        ),
        const SizedBox(
          height: Sizing.size32,
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: SILPrimaryButton(
            borderColor: Colors.transparent,
            text: refreshText,
            buttonColor: AppColors.consumerColors['primaryColor'],
            textColor: Colors.white,
            customRadius: 8,
            customPadding: const EdgeInsets.symmetric(vertical: 18),
            onPressed: refresh as void Function()?,
          ),
        ),
        const SizedBox(
          height: Sizing.size12,
        ),
        GestureDetector(
          onTap: () {
            // go home
          },
          child: Text(
            goHome,
            style: TextThemes.boldSize14Text(Colors.grey.withOpacity(0.8)),
          ),
        )
      ],
    );
  }
}
