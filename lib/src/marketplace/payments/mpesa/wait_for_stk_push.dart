import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_themes/app_theme.dart';
import 'package:shared_themes/spaces.dart';
import 'package:shared_themes/text_themes.dart';
import 'package:shared_ui_components/buttons.dart';
import 'package:shared_ui_components/platform_loader.dart';
import 'package:shared_ui_components/src/marketplace/payments/common/strings/strings.dart';
import 'package:shared_ui_components/src/marketplace/payments/common/utils.dart';
import 'package:shared_ui_components/src/marketplace/payments/mpesa/common_widgets.dart';

class WaitForSTKPush extends StatelessWidget {
  final PaymentDetails paymentDetails;
  final bool timedOut;
  final Function showManualInstructions;

  const WaitForSTKPush({
    Key? key,
    required this.paymentDetails,
    required this.showManualInstructions,
    this.timedOut = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> waitForPromptText =
        waitForSTKPush(paymentDetails.phoneNo, paymentDetails.amount);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          mpesaPayment,
          style: TextThemes.veryBoldSize22Text(),
        ),
        const SizedBox(
          height: Sizing.size12,
        ),
        stkPushInstructions(waitForPromptText),
        const SizedBox(
          height: Sizing.size18,
        ),
        Center(
          child: timedOut
              ? Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      child: SILPrimaryButton(
                        text: didNotReceivePrompt,
                        buttonColor: AppColors.consumerColors['primaryColor'],
                        textColor: Colors.white,
                        customRadius: 8,
                        customPadding: const EdgeInsets.symmetric(vertical: 18),
                        onPressed: showManualInstructions as void Function()?,
                      ),
                    ),
                  ],
                )
              : const SILPlatformLoader(),
        ),
      ],
    );
  }
}
