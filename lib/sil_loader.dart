import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sil_ui_components/utils/widget_keys.dart';
import 'package:sil_themes/colors.dart';

class SILLoader extends StatelessWidget {
  final Color color;
  const SILLoader({this.color = grey});
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
