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
              child: SILCountryPicker(
                onChanged: (String val) {},
              ),
            ),
          );
        }),
      );
      await tester.pumpWidget(testWidget);
      final Finder countryPicker = find.byType(SILCountryPicker);
      final Finder detector = find.byType(GestureDetector);
      expect(countryPicker, findsOneWidget);
      expect(detector, findsOneWidget);
      expect(
          find.byKey(
            const Key('selectCountryKey'),
          ),
          findsOneWidget);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('selectCountryKey')));

      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsNWidgets(4));
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();
    });
  });
}
