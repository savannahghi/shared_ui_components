import 'package:flutter/material.dart';
import 'package:sil_dumb_widgets/sil_loading.dart';
import 'package:sil_dumb_widgets/types/type_defs.dart';
import 'package:sil_themes/colors.dart';
import 'package:sil_themes/spaces.dart';
import 'package:sil_themes/text_themes.dart';
import 'package:sil_dumb_widgets/utils/constants.dart';

class TryNewFeatures extends StatefulWidget {
  final SettingsFunc settingsFunc;
  final bool canExperiment;

  const TryNewFeatures(
      {Key key, @required this.settingsFunc, @required this.canExperiment})
      : super(key: key);
  @override
  _TryNewFeaturesState createState() => _TryNewFeaturesState();
}

class _TryNewFeaturesState extends State<TryNewFeatures> {
  bool isProcessing = false;
  Widget tryNewFeaturesBuilder() {
    return Column(
      children: <Widget>[
        SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: Icon(Icons.arrow_back_outlined),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        Column(
          children: <Widget>[
            smallVerticalSizedBox,
            Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                  color: greyCardBackground, shape: BoxShape.circle),
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image(
                    image: AssetImage(TryNewFeatureStrings.tryFeaturesImgUrl),
                  )),
            ),
            mediumVerticalSizedBox,
            Column(
              children: <Widget>[
                Text(
                  TryNewFeatureStrings.title,
                  textAlign: TextAlign.center,
                  style: TextThemes.heavySize20Text(),
                ),
                smallVerticalSizedBox,
                Text(
                  TryNewFeatureStrings.description,
                  textAlign: TextAlign.center,
                  style:
                      TextThemes.normalSize13Text(grey).copyWith(height: 1.6),
                ),
                smallVerticalSizedBox,
                smallVerticalSizedBox,
              ],
            ),
            if (isProcessing)
              SILLoading(color: grey, type: SILLoadingType.Ripple),
            if (!isProcessing)
              Switch.adaptive(
                  onChanged: (bool value) async {
                    setState(() {
                      isProcessing = true;
                    });

                    await widget.settingsFunc(value: value, context: context);

                    setState(() {
                      isProcessing = false;
                    });
                  },
                  value: widget.canExperiment),
            smallVerticalSizedBox,
            Text(TryNewFeatureStrings.notice),
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
