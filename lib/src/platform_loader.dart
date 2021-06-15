import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_themes/colors.dart';
import 'package:shared_ui_components/src/widget_keys.dart';

class SILPlatformLoader extends StatelessWidget {
  const SILPlatformLoader({this.color = grey});

  final Color color;

  @override
  Widget build(BuildContext context) {
    final TargetPlatform _platform = Theme.of(context).platform;
    Brightness brightness = Brightness.light;
    if (color != grey) {
      brightness = Brightness.dark;
    }
    return Center(
      child: _platform == TargetPlatform.iOS
          ? CupertinoTheme(
              key: iosLoaderThemeKey,
              data: CupertinoTheme.of(context).copyWith(brightness: brightness),
              child: const CupertinoActivityIndicator(radius: 16),
            )
          : CircularProgressIndicator(strokeWidth: 2, backgroundColor: color),
    );
  }
}
