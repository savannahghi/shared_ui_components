import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui_components/src/marketplace_widgets/marketplace_bottom_nav_bar.dart';
import 'package:shared_ui_components/src/widget_keys.dart';

void main() {
  group('MarketplaceBottomNavBar', () {
    testWidgets(
      'should render properly',
      (WidgetTester tester) async {
        const int totalSteps = 5;
        const int currentStep = 2;
        const String nextText = 'next';
        await tester.pumpWidget(
          MaterialApp(
            home: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 400,
                        ),
                        Container(
                          height: 400,
                        ),
                      ],
                    ),
                  ),
                ),
                const MarketplaceBottomNavBar(
                  totalSteps: totalSteps,
                  currentStep: currentStep,
                  nextText: nextText,
                )
              ],
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byKey(nextButtonKey), findsOneWidget);
        expect(find.byKey(backButtonKey), findsOneWidget);
        expect(find.byKey(progressIndicatorKey), findsOneWidget);
        expect(find.text(nextText), findsOneWidget);
      },
    );

    testWidgets(
      'should have a working next button when isNextActivated is true',
      (WidgetTester tester) async {
        const int totalSteps = 5;
        const int currentStep = 2;
        late String result = '0';
        await tester.pumpWidget(
          MaterialApp(
            home: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 400,
                        ),
                        Container(
                          height: 400,
                        ),
                      ],
                    ),
                  ),
                ),
                MarketplaceBottomNavBar(
                  totalSteps: totalSteps,
                  currentStep: currentStep,
                  isNextActivated: true,
                  onNextTapped: () => result = 'test',
                )
              ],
            ),
          ),
        );

        await tester.pumpAndSettle();

        final Finder nextButton = find.byKey(nextButtonKey);

        expect(nextButton, findsOneWidget);

        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        expect(result, isNot('0'));
        expect(result, equals('test'));
      },
    );

    testWidgets(
      'should have a working next button that is disabled when isNextActivated is false',
      (WidgetTester tester) async {
        const int totalSteps = 5;
        const int currentStep = 2;
        late String result = '0';
        await tester.pumpWidget(
          MaterialApp(
            home: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 400,
                        ),
                        Container(
                          height: 400,
                        ),
                      ],
                    ),
                  ),
                ),
                MarketplaceBottomNavBar(
                  totalSteps: totalSteps,
                  currentStep: currentStep,
                  onNextTapped: () => result = 'test',
                )
              ],
            ),
          ),
        );

        await tester.pumpAndSettle();

        final Finder nextButton = find.byKey(nextButtonKey);

        expect(nextButton, findsOneWidget);

        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        expect(result, equals('0'));
        expect(result, isNot('test'));
      },
    );

    testWidgets(
      'should have a working back button',
      (WidgetTester tester) async {
        const int totalSteps = 5;
        const int currentStep = 2;
        late String result = '0';
        await tester.pumpWidget(
          MaterialApp(
            home: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 400,
                        ),
                        Container(
                          height: 400,
                        ),
                      ],
                    ),
                  ),
                ),
                MarketplaceBottomNavBar(
                  totalSteps: totalSteps,
                  currentStep: currentStep,
                  onBackTapped: () => result = 'test',
                )
              ],
            ),
          ),
        );

        await tester.pumpAndSettle();

        final Finder backButton = find.byKey(backButtonKey);

        expect(backButton, findsOneWidget);

        await tester.tap(backButton);
        await tester.pumpAndSettle();

        expect(result, isNot('0'));
        expect(result, equals('test'));
      },
    );

    testWidgets(
      'should have a valid step counter',
      (WidgetTester tester) async {
        const int totalSteps = 5;
        const int currentStep = 2;
        final SemanticsHandle handle = tester.ensureSemantics();
        await tester.pumpWidget(
          MaterialApp(
            home: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 400,
                        ),
                        Container(
                          height: 400,
                        ),
                      ],
                    ),
                  ),
                ),
                const MarketplaceBottomNavBar(
                  totalSteps: totalSteps,
                  currentStep: currentStep,
                )
              ],
            ),
          ),
        );

        await tester.pumpAndSettle();

        final Finder progressIndicator = find.byKey(progressIndicatorKey);
        expect(progressIndicator, findsOneWidget);

        final double expectedProgress = (currentStep / totalSteps).toDouble();

        expect(
          tester.getSemantics(progressIndicator),
          matchesSemantics(
            value: expectedProgress.toString(),
            textDirection: TextDirection.ltr,
          ),
        );

        handle.dispose();
      },
    );
  });
}
