// ignore_for_file: always_specify_types

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_themes/app_theme.dart';
import 'package:shared_themes/spaces.dart';
import 'package:shared_themes/text_themes.dart';
import 'package:shared_ui_components/buttons.dart';
import 'package:shared_ui_components/inputs.dart';
import 'package:shared_ui_components/src/marketplace/payments/common/strings/strings.dart';
import 'package:shared_ui_components/src/marketplace/payments/common/utils.dart';

void getHelpBottomSheet(BuildContext context) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  selectIssue,
                  style: TextThemes.veryBoldSize20Text().copyWith(height: 1.5),
                ),
                GetHelp()
              ],
            ),
          ),
        );
      });
}

class GetHelp extends StatefulWidget {
  @override
  State<GetHelp> createState() => _GetHelpState();
}

class _GetHelpState extends State<GetHelp> {
  final GlobalKey<FormFieldState> _formKey = GlobalKey<FormFieldState>();
  HelpType helpType = HelpType.none;
  String? message;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          ListTile(
            title: const Text(unableToPay),
            leading: Radio<HelpType>(
              value: HelpType.unableToPay,
              groupValue: helpType,
              onChanged: (HelpType? value) {
                setState(() {
                  helpType = value!;
                });
              },
              activeColor: Colors.green,
            ),
          ),
          ListTile(
            title: const Text(paymentNotConfirmed),
            leading: Radio<HelpType>(
              value: HelpType.paymentNotConfirmed,
              groupValue: helpType,
              onChanged: (HelpType? value) {
                setState(() {
                  helpType = value!;
                });
              },
              activeColor: Colors.green,
            ),
          ),
          ListTile(
            title: const Text(other),
            leading: Radio<HelpType>(
              value: HelpType.other,
              groupValue: helpType,
              onChanged: (HelpType? value) {
                setState(() {
                  helpType = value!;
                });
              },
              activeColor: Colors.green,
            ),
          ),
          mediumVerticalSizedBox,
          SILFormTextField(
            labelText: issueLable,
            borderColor: Colors.grey,
            maxLines: 3,
            onChanged: (dynamic value) {
              message = value as String;
            },
          ),
          mediumVerticalSizedBox,
          SizedBox(
            width: double.infinity,
            child: SILPrimaryButton(
              text: getHelp,
              buttonColor: AppColors.consumerColors['primaryColor'],
              textColor: Colors.white,
              customRadius: 8,
              customPadding: const EdgeInsets.symmetric(vertical: 18),
              onPressed: () {
                //----
              },
            ),
          )
        ],
      ),
    );
  }
}
