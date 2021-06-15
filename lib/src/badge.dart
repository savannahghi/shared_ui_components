import 'package:flutter/material.dart';
import 'package:shared_themes/colors.dart';
import 'package:shared_themes/spaces.dart';
import 'package:shared_themes/text_themes.dart';
import 'package:shared_ui_components/src/widget_keys.dart';

enum BadgeType { info, danger }

class SILBadge extends StatelessWidget {
  const SILBadge({required this.text, this.type = BadgeType.info});

  final String text;
  final BadgeType type;

  @override
  Widget build(BuildContext context) {
    return type == BadgeType.danger
        //error badge
        ? Container(
            key: dangerBadgeContainerKey,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(text, style: TextThemes.heavySize10Text(red)),
          )
        //info badge
        : Container(
            key: infoBadgeContainerKey,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              gradient: getAppGradient(context),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(text, style: TextThemes.heavySize10Text(white)),
          );
  }
}
