import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sil_ui_components/sil_loader.dart';

void main() {
  group('sil loader', () {
    testWidgets('should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SILLoader()));

      expect(find.byType(SILLoader), findsOneWidget);
    });

    testWidgets('should display cupertino indicator for IOS',
        (WidgetTester tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      await tester.pumpWidget(const MaterialApp(home: SILLoader()));

      expect(find.byType(SILLoader), findsOneWidget);
      expect(find.byKey(const Key('InboxCupertinoThemeKey')), findsOneWidget);
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('should display circular indicator for android',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SILLoader()));
      expect(find.byType(SILLoader), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
