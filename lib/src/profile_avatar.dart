import 'package:flutter/material.dart';
import 'package:sil_ui_components/src/constants.dart';

class SILProfileAvatar extends StatelessWidget {
  final String? photoUrl;

  const SILProfileAvatar({required this.photoUrl});
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
