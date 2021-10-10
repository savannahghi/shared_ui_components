import 'package:flutter/material.dart';
import 'package:shared_themes/text_themes.dart';
import 'package:shared_ui_components/src/marketplace/payments/common/strings/strings.dart';
import 'package:shared_ui_components/src/marketplace/payments/common/utils.dart';

void selectRecieveInstructionsMethod(
    BuildContext context, BankTransferType transferType) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Text(
                  receiveInstructionsTitle,
                  style: TextThemes.veryBoldSize20Text().copyWith(height: 1.5),
                ),
              ),
              ListTile(
                trailing: const Icon(Icons.chevron_right),
                title: Text(
                  viaWhatsApp,
                  style: TextThemes.boldSize16Text(),
                ),
                onTap: () {
                  // send instructions via whatsApp
                },
              ),
              ListTile(
                trailing: const Icon(Icons.chevron_right),
                title: Text(
                  viaText,
                  style: TextThemes.boldSize16Text(),
                ),
                onTap: () {
                  // send instructions via text
                },
              ),
            ],
          ),
        );
      });
}
