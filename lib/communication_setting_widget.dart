import 'package:flutter/material.dart';

import 'package:sil_dumb_widgets/sil_loading.dart';
import 'package:sil_dumb_widgets/sil_snackbar.dart';
import 'package:sil_themes/colors.dart';
import 'package:sil_themes/spaces.dart';
import 'package:sil_themes/text_themes.dart';

enum CommunicationType { allowEmail, allowTextSMS, allowWhatsApp, allowPush }

extension CommunicationTypeExtension on CommunicationType {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

class CommunicationSettingItem extends StatefulWidget {
  const CommunicationSettingItem({
    Key key,
    @required this.isActive,
    @required this.onTapHandler,
    @required this.title,
    @required this.subtitle,
    @required this.type,
  }) : super(key: key);

  final bool isActive;
  final Function onTapHandler;
  final String subtitle;
  final String title;
  final CommunicationType type;

  @override
  _CommunicationSettingItemState createState() =>
      _CommunicationSettingItemState();
}

class _CommunicationSettingItemState extends State<CommunicationSettingItem> {
  bool isProcessing = false;

  void toggleProcessing() {
    setState(() {
      isProcessing = !isProcessing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.title, style: TextThemes.heavySize18Text()),
                  size15VerticalSizedBox,
                  Text(
                    widget.subtitle,
                    style: TextThemes.boldSize15Text(Colors.grey),
                  )
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: isProcessing
                  ? SILLoading(color: grey, type: SILLoadingType.Ripple)
                  : Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.isActive ? Colors.green : Colors.white,
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.5),
                            width: widget.isActive ? 0 : 3.0),
                      ),
                      child: Icon(Icons.check,
                          color: widget.isActive
                              ? Colors.white
                              : Colors.grey.withOpacity(0.5),
                          size: 20),
                    ),
            ),
          ],
        ),
      ),
      onTap: () async {
        toggleProcessing();
        try {
          bool response = await widget.onTapHandler(
            channel: widget.type,
            isAllowed: !widget.isActive,
            context: context,
          );
          if (!response) {
            throw 'Error';
          }
          toggleProcessing();
        } catch (e) {
          toggleProcessing();
          showAlertSnackBar(
              context: context, message: 'Failed to change setting');
        }
      },
    );
  }
}
