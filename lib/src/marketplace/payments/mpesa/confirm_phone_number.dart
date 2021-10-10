import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_themes/spaces.dart';
import 'package:shared_themes/text_themes.dart';
import 'package:shared_ui_components/inputs.dart';
import 'package:shared_ui_components/src/marketplace/payments/common/strings/strings.dart';
import 'package:shared_ui_components/src/marketplace/payments/common/utils.dart';
import 'package:shared_ui_components/src/marketplace/payments/mpesa/common_widgets.dart';

class ConfirmMPESANumber extends StatefulWidget {
  final PaymentDetails paymentDetails;
  final Function updater;

  const ConfirmMPESANumber({
    Key? key,
    required this.paymentDetails,
    required this.updater,
  }) : super(key: key);

  @override
  _ConfirmMPESANumberState createState() => _ConfirmMPESANumberState();
}

class _ConfirmMPESANumberState extends State<ConfirmMPESANumber> {
  late String phoneNo;

  @override
  void initState() {
    phoneNo = widget.paymentDetails.phoneNo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> receivePromptText =
        receiveSTKPush(phoneNo, widget.paymentDetails.amount);
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
          changeNumber,
          style: TextThemes.normalSize14Text().copyWith(color: textGreyColor),
        ),
        const SizedBox(
          height: Sizing.size24,
        ),
        Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SizedBox(
            height: 48,
            child: SILFormTextField(
              labelText: phoneNumberLabel,
              initialValue: widget.paymentDetails.phoneNo,
              borderColor: textGreyColor.withOpacity(0.3),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              validator: (dynamic value) {
                if (value != '') {
                  return phoneNumberValidationMsg;
                }
                return null;
              },
              onChanged: (dynamic value) {
                // <do-something-awesome-here>
              },
            ),
          ),
        ),
        const SizedBox(
          height: Sizing.size20,
        ),
        stkPushInstructions(receivePromptText),
      ],
    );
  }
}
