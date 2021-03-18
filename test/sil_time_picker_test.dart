import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sil_ui_components/src/time_picker.dart';

void main() {
  testWidgets('sil time picker renders correctly', (WidgetTester tester) async {
    BuildContext? context;
    TextEditingController? controller;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SILTimePicker(
          context: context,
          controller: controller,
          onChanged: (String? _) {
            return '';
          },
          onSaved: (String? _) {
            return '';
          },
        ),
      ),
    ));
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.byType(GestureDetector), findsOneWidget);
    await tester.tap(find.byType(GestureDetector));
    await tester.pumpAndSettle();
  });
}
