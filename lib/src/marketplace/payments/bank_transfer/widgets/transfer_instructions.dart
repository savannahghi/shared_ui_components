import 'package:flutter/material.dart';
import 'package:shared_themes/app_theme.dart';
import 'package:shared_themes/spaces.dart';
import 'package:shared_themes/text_themes.dart';
import 'package:shared_ui_components/buttons.dart';
import 'package:shared_ui_components/src/marketplace/payments/bank_transfer/widgets/receive_instructions.dart';
import 'package:shared_ui_components/src/marketplace/payments/bank_transfer/widgets/transfer_details.dart';
import 'package:shared_ui_components/src/marketplace/payments/common/strings/strings.dart';
import 'package:shared_ui_components/src/marketplace/payments/common/utils.dart';

class BankTransferInstructions extends StatelessWidget {
  final BankTransferType transferType;
  final BankTransferDetails transferDetails;

  const BankTransferInstructions({
    Key? key,
    required this.transferType,
    required this.transferDetails,
  }) : super(key: key);

  Widget sendInstructions(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selectRecieveInstructionsMethod(context, transferType);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 35),
        decoration: BoxDecoration(
            color: lightGreen, borderRadius: BorderRadius.circular(24)),
        child: Text(
          sendInstructionsText,
          style: TextThemes.normalSize14Text(Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle style =
        TextThemes.normalSize15Text(Colors.black).copyWith(height: 1.5);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // send instructions button
        sendInstructions(context),
        largeVerticalSizedBox,
        // PesaLink instructions
        if (transferType == BankTransferType.pesaLink) ...<Widget>[
          Text(
            pesaLinkInstructions[0],
            style: style,
          ),
          mediumVerticalSizedBox,
          Text(
            pesaLinkInstructions[1],
            style: style,
          ),
          smallVerticalSizedBox,
          TransferDetails(
            transferDetails: transferDetails,
            transferType: transferType,
          ),
          mediumVerticalSizedBox,
          Text(
            pesaLinkInstructions[2],
            style: style,
          ),
          mediumVerticalSizedBox,
          Text(
            pesaLinkInstructions[3],
            style: style,
          ),
          mediumVerticalSizedBox,
        ],

        // swift & rtgs instructions
        if (transferType == BankTransferType.swift ||
            transferType == BankTransferType.rtgs) ...<Widget>[
          Text(
            swiftRTGSInstruction,
            style: style,
          ),
          smallVerticalSizedBox,
          TransferDetails(
            transferDetails: transferDetails,
            transferType: transferType,
          ),
        ],

        // equitel instructions
        if (transferType == BankTransferType.equitel) ...<Widget>[
          Text(
            equitelInstructions[0],
            style: style,
          ),
          smallVerticalSizedBox,
          Text(
            equitelInstructions[1],
            style: style,
          ),
          smallVerticalSizedBox,
          Text(
            equitelInstructions[2],
            style: style,
          ),
          smallVerticalSizedBox,
          Text(
            equitelInstructions[3],
            style: style,
          ),
          smallVerticalSizedBox,
          Text(
            equitelInstructions[4],
            style: style,
          ),
          smallVerticalSizedBox,
          Text(
            equitelInstructions[5],
            style: style,
          ),
          smallVerticalSizedBox,
          TransferDetails(
            transferDetails: transferDetails,
            transferType: transferType,
          ),
          smallVerticalSizedBox,
          Text(
            equitelInstructions[6],
            style: style,
          ),
          smallVerticalSizedBox,
          Text(
            equitelInstructions[7],
            style: style,
          ),
          smallVerticalSizedBox,
        ],

        mediumVerticalSizedBox,
        Text(
          checkPayment,
          style: style.copyWith(color: AppColors.consumerColors['accentColor']),
        ),
        mediumVerticalSizedBox,
        SizedBox(
          width: double.infinity,
          child: SILPrimaryButton(
            text: continueText,
            buttonColor: AppColors.consumerColors['primaryColor'],
            textColor: Colors.white,
            customRadius: 8,
            customPadding: const EdgeInsets.symmetric(vertical: 18),
            onPressed: () {
              // check payment here
            },
          ),
        ),
        mediumVerticalSizedBox,
      ],
    );
  }
}
