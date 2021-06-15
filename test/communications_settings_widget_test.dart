import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui_components/communications_settings.dart';

void main() {
  bool response() {
    return true;
  }

  test('communications enum should convert to a short string correctly', () {
    expect(CommunicationType.allowEmail.toShortString(), 'allowEmail');
    expect(CommunicationType.allowPush.toShortString(), 'allowPush');
    expect(CommunicationType.allowTextSMS.toShortString(), 'allowTextSMS');
    expect(CommunicationType.allowWhatsApp.toShortString(), 'allowWhatsApp');
  });

  testWidgets(
    'render communication_setting_widget correctly when is active is true',
    (WidgetTester tester) async {
      final Widget testWidget = MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return Scaffold(
            body: CommunicationSettingItem(
              isActive: true,
              onTapHandler: ({
                CommunicationType? channel,
                bool? isAllowed,
                BuildContext? context,
              }) {
                return response();
              },
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

      expect(find.byType(ScaffoldMessenger), findsOneWidget);
    },
  );

  testWidgets(
      'render communication_setting_widget correctly when is active is false',
      (WidgetTester tester) async {
    final Widget testWidget = MaterialApp(
      home: Builder(builder: (BuildContext context) {
        return Scaffold(
          body: CommunicationSettingItem(
            isActive: false,
            onTapHandler: (BuildContext context) {
              return response();
            },
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

    expect(find.byType(ScaffoldMessenger), findsOneWidget);
  });

  testWidgets('render communication_setting_widget correctly ',
      (WidgetTester tester) async {
    final Widget testWidget = MaterialApp(
      home: Builder(builder: (BuildContext context) {
        return Scaffold(
          body: CommunicationSettingItem(
            isActive: true,
            onTapHandler: (BuildContext context) {},
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

    expect(find.text('title'), findsOneWidget);
    expect(find.text('subtitle'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);
  });
}
