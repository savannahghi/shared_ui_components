import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_themes/text_themes.dart';
import 'package:shared_ui_components/src/marketplace/payments/common/strings/strings.dart';
import 'package:shared_ui_components/src/marketplace/payments/common/utils.dart';

class TransferDetails extends StatelessWidget {
  final BankTransferType transferType;
  final BankTransferDetails transferDetails;

  const TransferDetails({
    Key? key,
    required this.transferType,
    required this.transferDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          getTransferDetail(context, totalAmount, transferDetails.amount),
          getTransferDetail(context, accountName, transferDetails.accountName),
          getTransferDetail(context, accountNumber, transferDetails.accountNo),
          getTransferDetail(context, referenceNo, transferDetails.referenceNo),
          if (transferType == BankTransferType.equitel ||
              transferType == BankTransferType.rtgs ||
              transferType == BankTransferType.swift) ...<Widget>[
            getTransferDetail(context, phoneNo, transferDetails.phoneNo!),
            if (transferDetails.email != null)
              getTransferDetail(context, email, transferDetails.email!),
            getTransferDetail(context, address, transferDetails.address!),
          ],
          if (transferType == BankTransferType.swift)
            getTransferDetail(context, swift, transferDetails.swiftCode!),
        ],
      ),
    );
  }

  Container getTransferDetail(
      BuildContext context, String lable, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: bordrGreyColor.withOpacity(0.15),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  lable,
                  style: TextThemes.boldSize14Text(textGreyColorShade2),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    value,
                    style: TextThemes.veryBoldSize17Text(),
                  ),
                ),
                if (lable == referenceNo)
                  Text(
                    refDescription,
                    style: TextThemes.normalSize11Text(textGreyColorShade2),
                  )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: value)).then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$lable $copiedToClipBoard'),
                  ),
                );
              });
            },
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.copy,
                  size: 18,
                  color: Color(0xFF666666),
                ),
                Text(
                  copy,
                  style: TextThemes.normalSize12Text(textGreyColorShade2),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
