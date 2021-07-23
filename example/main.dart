import 'package:flutter/material.dart';
import 'package:shared_ui_components/src/buttons.dart';

void main() {
  runApp(AWidgetInYourApp());
}

class AWidgetInYourApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        // SILPrimaryButton is one among many other UI components provided to you by this pkg
        // For more arguments or customization options for this and other UI Components, check project source files (`./lib/src/`)
        child: SILPrimaryButton(
          buttonKey: const Key('your_button_key'),
          text: 'Button Text',
          borderColor: Colors.black, // your button's border color
          buttonColor: Colors.black, // your button's fill color
          textColor: Colors.white, // your button's text color
          customChild: const Icon(Icons.add, size: 30, color: Colors.white,), // Used when adding a custom child instead of a text widget
          onPressed: (){},
          onLongPress: () {},
        ),
      ),
    );
  }
}
