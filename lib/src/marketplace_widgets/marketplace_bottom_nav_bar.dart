import 'package:flutter/material.dart';

import 'package:misc_utilities/number_constants.dart';
import 'package:shared_themes/colors.dart';
import 'package:shared_themes/spaces.dart';
import 'package:shared_ui_components/src/widget_keys.dart';

/// [MarketplaceBottomNavBar] is dedicated to guiding the user in the buy cover process
///
/// [totalSteps] is a required field to determine the UI of the progress bar.
/// this is included in addition to [currentStep], which determines the current step
/// in the progress UI.
///
/// [backRoute] is required to give the widget the route that should be called
/// when the back arrow is pressed.
///
/// [nextText] is an optional string shown when navigating to the next screen
///
/// [isNextActivated] boolean determines if the nextButton with [nextText] should
/// be activated for tap activities. By default it is set to false
///
/// [onNextTapped] is the callback function triggered when [nextText] is tapped
/// [onBackTapped] is the callback function triggered when back button is tapped

class MarketplaceBottomNavBar extends StatelessWidget {
  const MarketplaceBottomNavBar({
    Key? key,
    required this.totalSteps,
    required this.currentStep,
    this.backRoute,
    this.nextText,
    this.isNextActivated = false,
    this.onNextTapped,
    this.onBackTapped,
  }) : super(key: key);

  final Function()? onNextTapped;
  final Function()? onBackTapped;
  final String? backRoute;
  final bool? isNextActivated;
  final String? nextText;
  final int totalSteps;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: number50,
      width: double.maxFinite,
      color: backgroundGreyColor,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // back button
          GestureDetector(
            key: backButtonKey,
            onTap: onBackTapped,
            child: Container(
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: secondaryNavButtonColor,
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back,
                  color: black,
                ),
              ),
            ),
          ),
          smallHorizontalSizedBox,
          // the progress indicator
          Expanded(
            child: LinearProgressIndicator(
              key: progressIndicatorKey,
              value: (currentStep / totalSteps).toDouble(),
              semanticsValue: (currentStep / totalSteps).toDouble().toString(),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(healthcloudPrimaryColor),
              backgroundColor: secondaryTextColor,
            ),
          ),

          smallHorizontalSizedBox,
          GestureDetector(
            key: nextButtonKey,
            onTap: isNextActivated! ? onNextTapped : null,
            child: Container(
              decoration: BoxDecoration(
                color: isNextActivated!
                    ? primaryNavButtonColor
                    : secondaryNavButtonColor,
                borderRadius: BorderRadius.circular(8),
              ),
              width: 50,
              child: Center(
                child: nextText == null
                    ? const Icon(
                        Icons.arrow_forward,
                        color: white,
                      )
                    : Text(
                        nextText!,
                        style: const TextStyle(
                          color: white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
