import 'package:flutter/material.dart';
import 'package:shared_themes/spaces.dart';
import 'package:shared_themes/text_themes.dart';
import 'package:shared_ui_components/src/marketplace/payments/common/strings/strings.dart';
import 'package:shared_ui_components/src/marketplace/payments/common/utils.dart';

class SuccessfulPaymentSummary extends StatelessWidget {
  final bool isLoanPayment;

  const SuccessfulPaymentSummary({
    Key? key,
    this.isLoanPayment = false,
  }) : super(key: key);

  Widget summaryRow(String label, String amount, {required bool isPaid}) =>
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: TextThemes.boldSize14Text()
                      .copyWith(color: textGreyColor),
                ),
                const SizedBox(height: Sizing.size12),
                Text(
                  amount,
                  textAlign: TextAlign.center,
                  style: TextThemes.veryBoldSize20Text(),
                ),
              ],
            ),
            if (!isPaid)
              Text(
                '10th Oct, 2021',
                style:
                    TextThemes.boldSize14Text().copyWith(color: textGreyColor),
              ),
            if (isPaid)
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                decoration: const BoxDecoration(
                  color: Color(0xFFB4E7DB),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Text(
                  'Paid',
                  style: TextThemes.boldSize14Text().copyWith(
                    fontWeight: FontWeight.w400,
                    color: green,
                  ),
                ),
              )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          paymentSuccessful,
          style: TextThemes.veryBoldSize28Text().copyWith(
            fontWeight: FontWeight.w300,
            color: green,
          ),
        ),
        const SizedBox(
          height: Sizing.size18,
        ),
        Text(
          paymentSuccessfulInstructions,
          textAlign: TextAlign.center,
          style: TextThemes.normalSize14Text()
              .copyWith(color: textGreyColor, height: 1.6),
        ),
        const SizedBox(
          height: Sizing.size32,
        ),
        if (!isLoanPayment) ...<Widget>[
          Text(
            amountPaid,
            textAlign: TextAlign.center,
            style: TextThemes.normalSize14Text().copyWith(color: textGreyColor),
          ),
          const SizedBox(
            height: Sizing.size6,
          ),
          Text(
            'KES 12,500',
            textAlign: TextAlign.center,
            style:
                TextThemes.veryBoldSize20Text().copyWith(color: textGreyColor),
          ),
        ],
        if (isLoanPayment)
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  summary,
                  textAlign: TextAlign.center,
                  style: TextThemes.boldSize16Text(),
                ),
                const SizedBox(
                  height: Sizing.size16,
                ),
                summaryRow('First payment', 'KES 12,500', isPaid: true),
                summaryRow('Next payment', 'KES 12,500', isPaid: false),
              ],
            ),
          )
      ],
    );
  }
}
