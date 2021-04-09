import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sil_misc/sil_responsive_widget.dart';
import 'package:sil_themes/spaces.dart';
import 'package:sil_themes/text_themes.dart';
import 'package:sil_ui_components/src/constants.dart';

class SILComingSoonPage extends StatelessWidget {
  final String title;
  final String? svgPath;
  final String? imagePath;
  final String description;
  final String comingSoonText;
  final bool showAppbar;
  final PreferredSizeWidget? appBar;
  final bool showBottomNavigationBar;
  final Widget? bottomNavigationBar;

  SILComingSoonPage(
      {Key? key,
      required this.title,
      required this.description,
      required this.comingSoonText,
      this.svgPath,
      this.imagePath,
      this.showAppbar = false,
      this.appBar,
      this.showBottomNavigationBar = false,
      this.bottomNavigationBar})
      : assert(() {
          if (showAppbar && appBar == null) {
            throw Exception('appBar should not be null if showAppBar is true');
          }
          return true;
        }()),
        assert(() {
          if (showBottomNavigationBar && appBar == null) {
            throw Exception(
                'bottomNavigationBar should not be null if showBottomNavigationBar is true');
          }
          return true;
        }()),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: this.appBar,
      bottomNavigationBar: this.bottomNavigationBar,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SILResponsiveWidget.preferredPaddingOnStretchedScreens(
                context: context)),
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            if (!SILResponsiveWidget.isSmallScreenAndOnLandscape(
                context: context))
              if (svgPath != null)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SvgPicture.asset(
                    svgPath!,
                    height: 200,
                  ),
                ),
            if (!SILResponsiveWidget.isSmallScreenAndOnLandscape(
                context: context))
              if (imagePath != null)
                Padding(
                  padding: SILResponsiveWidget.isLargeScreen(context)
                      ? const EdgeInsets.all(20.0)
                      : const EdgeInsets.all(10.0),
                  child: Image(
                    image: AssetImage(imagePath!),
                  ),
                ),
            size15VerticalSizedBox,
            Column(
              children: <Widget>[
                if (!SILResponsiveWidget.isSmallScreenAndOnLandscape(
                    context: context))
                  Text(
                    title,
                    style: TextThemes.heavySize20Text(),
                  ),
                smallVerticalSizedBox,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextThemes.normalSize16Text(Colors.grey),
                  ),
                ),
                smallVerticalSizedBox,
              ],
            ),
            smallVerticalSizedBox,
            ComingSoonCard(feature: this.title),
            mediumVerticalSizedBox,
          ],
        ),
      ),
    );
  }
}

class ComingSoonCard extends StatelessWidget {
  const ComingSoonCard({Key? key, required this.feature}) : super(key: key);

  final String feature;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: whiteColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            offset: const Offset(0.0, 1.0),
            blurRadius: 6.0,
          )
        ],
      ),
      child: Column(
        children: <Widget>[
          smallVerticalSizedBox,
          Text.rich(
            TextSpan(
                text:
                    '$feature is still under development. This feature will be available soon.',
                style: TextThemes.normalSize16Text(greyTextColor)),
            textAlign: TextAlign.center,
          ),
          mediumVerticalSizedBox,
        ],
      ),
    );
  }
}
