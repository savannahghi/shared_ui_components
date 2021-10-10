import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_themes/spaces.dart';
import 'package:shared_themes/text_themes.dart';
import 'package:shared_ui_components/src/marketplace/payments/common/strings/strings.dart';
import 'package:shared_ui_components/src/marketplace/payments/common/utils.dart';

class MpesaManualInstructions extends StatelessWidget {
  final PaymentDetails paymentDetails;

  const MpesaManualInstructions({Key? key, required this.paymentDetails})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    const SizedBox size = SizedBox(
      height: Sizing.size12,
    );
    final TextStyle style =
        TextThemes.normalSize14Text().copyWith(color: textGreyColor);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          mpesaPayment,
          style: TextThemes.veryBoldSize22Text(),
        ),
        const SizedBox(
          height: Sizing.size18,
        ),
        Text(
          instructionsHeading,
          style: TextThemes.veryBoldSize14Text(),
        ),
        const SizedBox(
          height: Sizing.size12,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                goToMpesa,
                style: style,
              ),
              size,
              Text(
                lipaNaMpesa,
                style: style,
              ),
              size,
              Text(
                selectPaybillOption,
                style: style,
              ),
              size,
              Text(
                accountNo(paymentDetails.phoneNo),
                style: style,
              ),
              size,
              Text(
                businessNo,
                style: style,
              ),
              size,
              Text(
                amount(paymentDetails.amount),
                style: style,
              ),
              size,
              Text(
                mpesaPin,
                style: style,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: Sizing.size24,
        ),
        Text(
          nextStep,
          style: style,
        ),
      ],
    );
  }
}
