import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_themes/spaces.dart';
import 'package:shared_themes/text_themes.dart';
import 'package:shared_ui_components/src/marketplace/payments/common/strings/strings.dart';
import 'package:shared_ui_components/src/marketplace/payments/common/utils.dart';

class SelectCards extends StatelessWidget {
  const SelectCards({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        getTransferType(
          pesaLinkTitle,
          pesaLinkDesc,
          () {},
        ),
        getTransferType(
          rtgsTitle,
          rtgsDesc,
          () {},
        ),
        getTransferType(
          equitelTitle,
          equitelDesc,
          () {},
        ),
        getTransferType(
          swiftTitle,
          swiftDesc,
          () {},
        ),
      ],
    );
  }

  Widget getTransferType(String title, String message, void Function()? onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            border: Border.all(color: bordrGreyColor, width: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextThemes.veryBoldSize16Text(),
                    ),
                    const SizedBox(
                      height: Sizing.size8,
                    ),
                    Text(
                      message,
                      style: TextThemes.boldSize14Text(textGreyColorShade2),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 40,
                color: Color(0xFFB5B5B5),
              )
            ],
          ),
        ),
      ),
    );
  }
}
