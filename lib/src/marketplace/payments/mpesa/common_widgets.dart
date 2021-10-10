import 'package:flutter/material.dart';
import 'package:shared_themes/text_themes.dart';
import 'package:shared_ui_components/src/marketplace/payments/common/utils.dart';

Widget stkPushInstructions(List<String> text) => Text.rich(
      TextSpan(
        style: TextThemes.normalSize14Text()
            .copyWith(height: 1.8, color: textGreyColor),
        children: <TextSpan>[
          TextSpan(
            text: text[0],
            style: TextThemes.normalSize14Text(),
          ),
          TextSpan(
            text: text[1],
            style: TextThemes.boldSize14Text(),
          ),
          TextSpan(
            text: text[2],
            style: TextThemes.normalSize14Text(),
          ),
          TextSpan(
            text: text[3],
            style: TextThemes.boldSize14Text(),
          ),
          TextSpan(
            text: text[4],
            style: TextThemes.normalSize14Text(),
          ),
          TextSpan(
            text: text[5],
            style: TextThemes.boldSize14Text(),
          ),
          TextSpan(
            text: text[6],
            style: TextThemes.normalSize14Text(),
          ),
        ],
      ),
    );
