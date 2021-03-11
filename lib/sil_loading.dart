import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'utils/widget_keys.dart';

enum SILLoadingType { CubeGrid, FoldingCube, ChasingDots, Ripple }

class SILLoading extends StatelessWidget {
  final SILLoadingType type;
  final Color? color;
  final double size;

  const SILLoading(
      {@required this.color,
      this.type = SILLoadingType.CubeGrid,
      this.size = 50});

  @override
  Widget build(BuildContext context) {
    switch (this.type) {
      case SILLoadingType.CubeGrid:
        return SpinKitCubeGrid(
          key: cubeGridKey,
          color: this.color,
          size: this.size,
        );
      case SILLoadingType.FoldingCube:
        return SpinKitFadingCube(
          key: foldingCubeKey,
          color: this.color,
          size: this.size,
        );
      case SILLoadingType.ChasingDots:
        return SpinKitChasingDots(
          key: chasingDotsKey,
          color: this.color,
          size: this.size,
        );
      case SILLoadingType.Ripple:
        return SpinKitRipple(
          key: rippleKey,
          color: this.color,
          size: this.size,
        );

      default:
        return SpinKitCubeGrid(
          key: cubeGridKey,
          color: this.color,
          size: this.size,
        );
    }
  }
}
