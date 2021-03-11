import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sil_ui_components/sil_country_picker.dart';

void main() {
  group('SilCountryPicker', () {
    testWidgets('should render SilCountryPicker ', (WidgetTester tester) async {
      final Widget testWidget = MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return Scaffold(
            body: SizedBox(
              child: SilCountryPicker(),
            ),
          );
        }),
      );
      await tester.pumpWidget(testWidget);
      final Finder countryPicker = find.byType(SilCountryPicker);
      final Finder detector = find.byType(GestureDetector);
      expect(countryPicker, findsOneWidget);
      expect(detector, findsOneWidget);

      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(10.0, 10.0));
      await tester.pumpAndSettle();
    });
  });
}
