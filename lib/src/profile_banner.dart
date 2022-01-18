import 'package:flutter/material.dart';
import 'package:shared_ui_components/buttons.dart';
import 'package:shared_themes/spaces.dart';
import 'package:shared_themes/text_themes.dart';
import 'package:shared_ui_components/profile_avator.dart';
import 'package:shared_ui_components/src/app_strings.dart';

class SILProfileBanner extends StatelessWidget {
  const SILProfileBanner({
    required this.backgroundImagePath,
    required this.userPhotoUrl,
    required this.profileRoute,
    required this.userName,
    required this.primaryPhone,
    this.editable = false,
    this.height = 200.00,
  });

  final String backgroundImagePath;
  final bool editable;
  final double height;
  final String primaryPhone;
  final String profileRoute;
  final String userName;
  final String userPhotoUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(backgroundImagePath),
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(6),
          bottomRight: Radius.circular(6),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: <Color>[
                Theme.of(context).primaryColor.withOpacity(0.8),
                Theme.of(context).primaryColor.withOpacity(0.4),
              ], begin: Alignment.bottomLeft, end: Alignment.topRight),
            ),
            child: editable
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Opacity(
                        opacity: 0.75,
                        child: SILSecondaryButton(
                          onPressed: () {
                            Navigator.pushNamed(context, profileRoute);
                          },
                          text: 'Edit Profile Details',
                          borderColor: Colors.white,
                          textColor: Colors.white,
                          addBorder: true,
                        ),
                      ),
                    ),
                  )
                : null,
          ),
          Positioned(
            bottom: -60,
            left: 20,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 2,
                  color: Theme.of(context).primaryColor.withOpacity(0.6),
                ),
              ),
              child: SILProfileAvatar(
                  photoUrl: (userPhotoUrl == 'UNKNOWN')
                      ? bewellLogoNetworkUrl
                      : userPhotoUrl),
            ),
          ),
          Positioned(
            bottom: -45,
            left: 130,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  userName,
                  style: TextThemes.heavySize16Text(Colors.black),
                ),
                verySmallVerticalSizedBox,
                Text(
                  primaryPhone,
                  style: TextThemes.normalSize10Text(Colors.grey),
                ),
              ],
            ),
          ),
          Positioned(
            top: 50,
            left: 15,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
