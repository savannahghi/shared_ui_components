import 'package:flutter/material.dart';

import 'package:sil_themes/colors.dart';
import 'package:sil_themes/spaces.dart';
import 'package:sil_themes/text_themes.dart';
import 'package:sil_ui_components/sil_fancy_loading.dart';
import 'package:sil_ui_components/src/constants.dart';
import 'package:sil_ui_components/src/type_defs.dart';

class SILTryNewFeaturesWidget extends StatefulWidget {
  final SettingsFunc? settingsFunc;
  final bool? canExperiment;

  const SILTryNewFeaturesWidget(
      {Key? key, required this.settingsFunc, required this.canExperiment})
      : super(key: key);
  @override
  _SILTryNewFeaturesWidgetState createState() =>
      _SILTryNewFeaturesWidgetState();
}

class _SILTryNewFeaturesWidgetState extends State<SILTryNewFeaturesWidget> {
  bool isProcessing = false;
  Widget tryNewFeaturesBuilder() {
    return Column(
      children: <Widget>[
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
        Column(
          children: <Widget>[
            smallVerticalSizedBox,
            Container(
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                  color: Colors.grey, shape: BoxShape.circle),
              child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Image(
                    image: AssetImage(tryFeaturesImgUrl),
                  )),
            ),
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

                    await widget.settingsFunc!(value: value, context: context);

                    setState(() {
                      isProcessing = false;
                    });
                  },
                  value: widget.canExperiment!),
            smallVerticalSizedBox,
            const Text(tryFeaturesNotice),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return tryNewFeaturesBuilder();
  }
}
