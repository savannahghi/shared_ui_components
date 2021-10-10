import 'package:flutter/material.dart';
import 'package:shared_themes/spaces.dart';
import 'package:shared_themes/text_themes.dart';
import 'package:shared_ui_components/src/marketplace/payments/bank_transfer/widgets/select_card.dart';
import 'package:shared_ui_components/src/marketplace/payments/bank_transfer/widgets/transfer_instructions.dart';
import 'package:shared_ui_components/src/marketplace/payments/common/utils.dart';

class BankTransfer extends StatelessWidget {
  final String title;
  final String message;

  final BankTransferType transferType;

  final BankTransferDetails? transferDetails;

  const BankTransfer({
    Key? key,
    required this.title,
    required this.message,
    required this.transferType,
    this.transferDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextThemes.veryBoldSize28Text(),
        ),
        const SizedBox(
          height: Sizing.size12,
        ),
        Text(
          message,
          style: TextThemes.normalSize16Text().copyWith(color: textGreyColor),
        ),
        const SizedBox(
          height: Sizing.size24,
        ),
        if (transferType == BankTransferType.base) const SelectCards(),
        if (transferType != BankTransferType.base)
          BankTransferInstructions(
            transferType: transferType,
            transferDetails: transferDetails!,
          ),
      ],
    );
  }
}
