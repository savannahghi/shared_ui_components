import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sil_dumb_widgets/sil_badge.dart';

void main() {
  group('sil badge', () {
    final String badgeText = 'inbox';
    final BadgeType badgeInfo = BadgeType.info;
    final BadgeType badgeDanger = BadgeType.danger;

    testWidgets('should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: SILBadge(
          text: badgeText,
        ),
      ));

      expect(find.byType(SILBadge), findsOneWidget);
    });

    testWidgets('should display information badge',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: SILBadge(
          text: badgeText,
          type: badgeInfo,
        ),
      ));

      expect(find.byType(SILBadge), findsOneWidget);
      expect(find.byKey(Key('badge_info_container_key')), findsOneWidget);
    });

    testWidgets('should display danger badge', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: SILBadge(
          text: badgeText,
          type: badgeDanger,
        ),
      ));

      expect(find.byType(SILBadge), findsOneWidget);
      expect(find.byKey(Key('badge_danger_container_key')), findsOneWidget);
    });
  });
}
