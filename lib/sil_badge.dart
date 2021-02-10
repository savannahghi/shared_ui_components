import 'package:flutter/material.dart';
import 'package:sil_themes/colors.dart';
import 'package:sil_themes/spaces.dart';
import 'package:sil_themes/text_themes.dart';

enum BadgeType {
  info,
  danger,
}

class SILBadge extends StatelessWidget {
  final String text;
  final BadgeType type;

  SILBadge({
    @required this.text,
    this.type = BadgeType.info,
  });

  @override
  Widget build(BuildContext context) {
    return type == BadgeType.danger
        //error badge
        ? Container(
            key: Key('badge_danger_container_key'),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(text, style: TextThemes.heavySize10Text(red)),
            decoration: BoxDecoration(
              color: red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(25),
            ))
        //info badge
        : Container(
            key: Key('badge_info_container_key'),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(text, style: TextThemes.heavySize10Text(white)),
            decoration: BoxDecoration(
              gradient: getAppGradient(context),
              borderRadius: BorderRadius.circular(25),
            ),
          );
  }
}
