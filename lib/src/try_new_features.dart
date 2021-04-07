import 'package:flutter/material.dart';
import 'package:sil_misc/sil_enums.dart';
import 'package:sil_misc/sil_number_constants.dart';
import 'package:sil_misc/sil_responsive_widget.dart';

import 'package:sil_themes/colors.dart';
import 'package:sil_themes/spaces.dart';
import 'package:sil_themes/text_themes.dart';
import 'package:sil_ui_components/sil_fancy_loading.dart';
import 'package:sil_ui_components/src/constants.dart';
import 'package:sil_ui_components/src/type_defs.dart';

class SILTryNewFeaturesWidget extends StatefulWidget {
  const SILTryNewFeaturesWidget(
      {Key? key, required this.settingsFunc, required this.canExperiment})
      : super(key: key);

  final bool? canExperiment;
  final SettingsFunc? settingsFunc;

  @override
  _SILTryNewFeaturesWidgetState createState() =>
      _SILTryNewFeaturesWidgetState();
}

class _SILTryNewFeaturesWidgetState extends State<SILTryNewFeaturesWidget> {
  bool isProcessing = false;

  Widget tryNewFeaturesBuilder() {
    return Column(
      children: <Widget>[
        // back button
        if (SILResponsiveWidget.deviceType(context) == DeviceScreensType.Mobile)
          SafeArea(
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back_outlined),
                ),
              ],
            ),
          ),

        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SILResponsiveWidget.deviceType(context) ==
                    DeviceScreensType.Tablet
                ? number30
                : SILResponsiveWidget.preferredPaddingOnStretchedScreens(
                    context: context),
          ),
          child: Column(
            children: <Widget>[
              smallVerticalSizedBox,
              if (!SILResponsiveWidget.isSmallScreenAndOnLandscape(
                  context: context))
                Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image(
                      height: (SILResponsiveWidget.deviceType(context) !=
                              DeviceScreensType.Mobile)
                          ? number250
                          : number200,
                      width: (SILResponsiveWidget.deviceType(context) !=
                              DeviceScreensType.Mobile)
                          ? number250
                          : number200,
                      image: const AssetImage(tryFeaturesImgUrl),
                    )),
              mediumVerticalSizedBox,
              Column(
                children: <Widget>[
                  Text(
                    tryFeaturesTitle,
                    textAlign: TextAlign.center,
                    style: TextThemes.heavySize20Text(),
                  ),
                  smallVerticalSizedBox,
                  Text(
                    tryFeaturesDescription,
                    textAlign: TextAlign.center,
                    style:
                        TextThemes.normalSize13Text(grey).copyWith(height: 1.6),
                  ),
                  smallVerticalSizedBox,
                  smallVerticalSizedBox,
                ],
              ),
              if (isProcessing)
                const SILFancyLoading(
                    color: grey, type: SILFancyLoadingType.ripple),
              if (!isProcessing)
                Switch.adaptive(
                    onChanged: (bool value) async {
                      setState(() {
                        isProcessing = true;
                      });

                      await widget.settingsFunc!(
                          value: value, context: context);

                      setState(() {
                        isProcessing = false;
                      });
                    },
                    value: widget.canExperiment!),
              smallVerticalSizedBox,
              const Text(
                tryFeaturesNotice,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return tryNewFeaturesBuilder();
  }
}
