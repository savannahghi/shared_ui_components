import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sil_ui_components/sil_comms_setting.dart';

void main() {
  test('comms enums', () {
    const CommunicationType email = CommunicationType.allowEmail;
    expect(email.toShortString(), 'allowEmail');
  });

  testWidgets(
    'render communication_setting_widget',
    (WidgetTester tester) async {
      final Widget testWidget = MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return Scaffold(
            body: CommunicationSettingItem(
              isActive: true,
              onTapHandler: () {},
              subtitle: 'subtitle',
              title: 'title',
              type: CommunicationType.allowEmail,
            ),
          );
        }),
      );
      await tester.pumpWidget(testWidget);

      await tester.pumpAndSettle();

      expect(find.byType(GestureDetector), findsOneWidget);
      final Element elm = tester.element(find.byType(GestureDetector));
      final GestureDetector elmW = elm.widget as GestureDetector;

      expect(elmW, isA<GestureDetector>());

      expect(() => elmW.onTap!(), returnsNormally);
    },
  );
}
