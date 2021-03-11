import 'package:flutter/material.dart';
import 'package:sil_ui_components/utils/constants.dart';

class ProfileAvatar extends StatelessWidget {
  final String? photoUrl;

  const ProfileAvatar({required this.photoUrl});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: CircleAvatar(
          backgroundImage: NetworkImage(photoUrl ?? bewellLogoNetworkUrl)),
    );
  }
}
