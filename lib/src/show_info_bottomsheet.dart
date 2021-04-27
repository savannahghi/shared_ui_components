import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sil_themes/spaces.dart';
import 'package:sil_themes/text_themes.dart';
import 'package:sil_ui_components/src/app_strings.dart';

Future<dynamic> showFeedbackBottomSheet({
  required BuildContext context,
  required String modalContent,
  required String imageAssetPath,
}) async {
  return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          key: infoBottomSheetKey,
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            constraints: const BoxConstraints(
              maxWidth: 420,
            ),
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            margin: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          child: SvgPicture.asset(
                            imageAssetPath,
                            height: 34.0,
                            width: 34.0,
                          ),
                        ),
                        mediumHorizontalSizedBox,
                        Flexible(
                            child: Text(
                          modalContent,
                          style: TextThemes.normalSize14Text(),
                        )),
                      ],
                    ),
                  ),
                  smallHorizontalSizedBox,
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Image(
                        key: Key('pop_bottomsheet'),
                        image: AssetImage(closeIconUrl),
                        color: Colors.black54,
                        height: 16.0,
                        width: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
