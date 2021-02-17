import 'package:flutter/material.dart';
import 'package:sil_dumb_widgets/utils/constants.dart';

class ProfileAvatar extends StatelessWidget {
  final String photoUrl;

  const ProfileAvatar({Key key, @required this.photoUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      child: CircleAvatar(
          backgroundImage: NetworkImage(photoUrl ?? bewellLogoNetworkUrl)),
    );
  }
}
