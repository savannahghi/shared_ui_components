import 'package:flutter/material.dart';

import 'package:sil_ui_components/sil_loading.dart';
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
    required this.isActive,
    required this.onTapHandler,
    required this.title,
    required this.subtitle,
    required this.type,
  });

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
      onTap: () async {
        toggleProcessing();
        try {
          final bool response = await widget.onTapHandler(
            channel: widget.type,
            isAllowed: !widget.isActive,
            context: context,
          ) as bool;
          if (!response) {
            throw 'Error';
          }
          toggleProcessing();
        } catch (e) {
          toggleProcessing();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to change setting'),
            ),
          );
        }
      },
      child: SizedBox(
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
              child: isProcessing
                  ? const SILLoading(color: grey, type: SILLoadingType.Ripple)
                  : Container(
                      padding: const EdgeInsets.all(1),
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
    );
  }
}
