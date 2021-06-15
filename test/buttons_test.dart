import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui_components/buttons.dart';

void main() {
  group('SILPrimaryButton', () {
    testWidgets('should render correctly', (WidgetTester tester) async {
      bool isActionTapped = false;
      bool isLongPressed = false;
      const Key buttonKey = Key('button_key');

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Center(
            child: Builder(builder: (BuildContext context) {
              return SILPrimaryButton(
                  buttonKey: buttonKey,
                  onPressed: () {
                    isActionTapped = true;
                  },
                  onLongPress: () {
                    isLongPressed = true;
                  });
            }),
          ),
        ),
      ));

      expect(find.byType(RawMaterialButton), findsOneWidget);

      await tester.tap(find.byKey(buttonKey));
      await tester.pumpAndSettle();
      expect(isActionTapped, true);

      await tester.longPress(find.byKey(buttonKey));
      await tester.pumpAndSettle();
      expect(isLongPressed, true);
    });

    testWidgets('should show assertion error', (WidgetTester tester) async {
      expect(() => SILPrimaryButton(onPressed: null), throwsAssertionError);
    });
  });

  group('SILSecondaryButton', () {
    testWidgets('should render correctly', (WidgetTester tester) async {
      bool isActionTapped = false;
      const Key buttonKey = Key('button_key');

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Center(
            child: Builder(builder: (BuildContext context) {
              return SILSecondaryButton(
                buttonKey: buttonKey,
                onPressed: () {
                  isActionTapped = true;
                },
              );
            }),
          ),
        ),
      ));

      expect(find.byType(ElevatedButton), findsOneWidget);

      await tester.tap(find.byKey(buttonKey));
      await tester.pumpAndSettle();
      expect(isActionTapped, true);
    });

    testWidgets('should show assertion error', (WidgetTester tester) async {
      expect(() => SILSecondaryButton(onPressed: null), throwsAssertionError);
    });
  });

  group('SILNoBorderButton', () {
    testWidgets('should render correctly', (WidgetTester tester) async {
      bool isActionTapped = false;
      bool isLongPressed = false;

      const Key buttonKey = Key('button_key');

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Center(
            child: Builder(builder: (BuildContext context) {
              return SILNoBorderButton(
                  buttonKey: buttonKey,
                  onPressed: () {
                    isActionTapped = true;
                  },
                  onLongPress: () {
                    isLongPressed = true;
                  },
                  text: 'Next');
            }),
          ),
        ),
      ));

      expect(find.byType(TextButton), findsOneWidget);

      await tester.tap(find.byKey(buttonKey));
      await tester.pumpAndSettle();
      expect(isActionTapped, true);

      await tester.longPress(find.byKey(buttonKey));
      await tester.pumpAndSettle();
      expect(isLongPressed, true);
    });

    testWidgets('should show assertion error', (WidgetTester tester) async {
      expect(() => SILNoBorderButton(onPressed: null, text: null),
          throwsAssertionError);
    });
  });

  testWidgets('SILIconButton should render correctly',
      (WidgetTester tester) async {
    bool isActionTapped = false;
    const Key buttonKey = Key('button_key');

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Builder(builder: (BuildContext context) {
            return SILIconButton(
                key: buttonKey,
                callback: () {
                  isActionTapped = true;
                },
                icon: null);
          }),
        ),
      ),
    ));

    expect(find.byType(RawMaterialButton), findsOneWidget);

    await tester.tap(find.byKey(buttonKey));
    await tester.pumpAndSettle();
    expect(isActionTapped, true);
  });
}
