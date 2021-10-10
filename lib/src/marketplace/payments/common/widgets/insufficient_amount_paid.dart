import 'package:flutter/material.dart';
import 'package:shared_themes/app_theme.dart';
import 'package:shared_themes/spaces.dart';
import 'package:shared_themes/text_themes.dart';
import 'package:shared_ui_components/buttons.dart';
import 'package:shared_ui_components/src/marketplace/payments/common/strings/strings.dart';
import 'package:shared_ui_components/src/marketplace/payments/common/utils.dart';

class InsufficientAmountPaid extends StatelessWidget {
  final Function payNowFunc;

  const InsufficientAmountPaid({
    Key? key,
    required this.payNowFunc,
  }) : super(key: key);

  Widget paymentRow(String label, String amount, {bool isBalance = false}) =>
      Container(
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.3)),
        )),
        padding: const EdgeInsets.only(bottom: 25),
        margin: const EdgeInsets.only(bottom: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              label,
              style: TextThemes.boldSize14Text().copyWith(color: textGreyColor),
            ),
            const SizedBox(height: Sizing.size12),
            Text(
              amount,
              textAlign: TextAlign.center,
              style: TextThemes.veryBoldSize20Text(
                  isBalance ? green : Colors.black),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          insufficientAmount,
          style: TextThemes.veryBoldSize28Text().copyWith(
            fontWeight: FontWeight.w100,
            color: Colors.red,
          ),
        ),
        const SizedBox(
          height: Sizing.size18,
        ),
        Text(
          insufficientAmountInstructions,
          textAlign: TextAlign.center,
          style: TextThemes.normalSize14Text()
              .copyWith(color: textGreyColor, height: 1.6),
        ),
        const SizedBox(
          height: Sizing.size32,
        ),
        const SizedBox(
          height: Sizing.size18,
        ),
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              paymentRow(expectedAmount, 'KES 12,500'),
              paymentRow(amountPaid, 'KES 10,500'),
              paymentRow(remainingAmount, 'KES 2,000', isBalance: true),
            ],
          ),
        ),
        const SizedBox(
          height: Sizing.size20,
        ),
        //------------
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: SILPrimaryButton(
            text: payNow,
            buttonColor: AppColors.consumerColors['primaryColor'],
            textColor: Colors.white,
            customRadius: 8,
            customPadding: const EdgeInsets.symmetric(vertical: 18),
            onPressed: payNowFunc as void Function()?,
          ),
        )
      ],
    );
  }
}
