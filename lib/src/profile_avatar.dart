import 'package:flutter/material.dart';
import 'package:shared_ui_components/src/constants.dart';

class SILProfileAvatar extends StatelessWidget {
  const SILProfileAvatar({required this.photoUrl});

  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 100,
      width: 100,
      child: CircleAvatar(
        backgroundImage: AssetImage(bewellLogoNetworkUrl),
      ),
    );
  }
}
