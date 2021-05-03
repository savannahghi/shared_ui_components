import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sil_ui_components/src/time_picker.dart';

void main() {
  testWidgets('sil time picker renders correctly', (WidgetTester tester) async {
    final TextEditingController controller = TextEditingController();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SILTimePicker(
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

    await tester.tap(find.text(''));
  });
  group('SILTimePicker', () {
    final TextEditingController controller = TextEditingController();

    testWidgets('should render ios time picker', (WidgetTester tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      String currentHour = TimeOfDay.now().hour.toString();
      // check if current time in [hour] is > than 12 then return [hour]
      // in am/pm formart
      if (TimeOfDay.now().hour > 12) {
        currentHour = TimeOfDay.now().hourOfPeriod.toString();
      }
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return Material(
              child: SILTimePicker(
                  labelText: 'time',
                  controller: controller,
                  onChanged: (String? _) {
                    return controller.text;
                  },
                  onSaved: (String? _) {
                    return controller.text;
                  }));
        }),
      ));

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('time'), findsOneWidget);
      await tester.tap(find.text('time'));
      await tester.pumpAndSettle();

      expect(find.byType(Container), findsWidgets);
      expect(find.byType(CupertinoDatePicker), findsOneWidget);

      await tester.drag(
        find.text(currentHour),
        const Offset(0.0, 70.0),
      );
      expect(find.text(currentHour), findsOneWidget);

      await tester.tap(find.text(currentHour));
      await tester.pumpAndSettle();

      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('should render ios time picker change',
        (WidgetTester tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      String currentHour = TimeOfDay.now().hour.toString();
      // check if current time in [hour] is > than 12 then return [hour]
      // in am/pm formart
      if (TimeOfDay.now().hour > 12) {
        currentHour = TimeOfDay.now().hourOfPeriod.toString();
      }
      await tester.pumpWidget(Container(
        key: const Key('timeContainer'),
        child: MaterialApp(
          home: Builder(builder: (BuildContext context) {
            return Material(
                child: SILTimePicker(
                    labelText: 'time',
                    controller: controller,
                    onChanged: (String? _) {
                      return controller.text;
                    },
                    onSaved: (String? _) {
                      return controller.text;
                    }));
          }),
        ),
      ));

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('time'), findsOneWidget);
      await tester.tap(find.text('time'));
      await tester.pumpAndSettle();

      expect(find.byType(Container), findsWidgets);
      expect(find.byType(CupertinoDatePicker), findsOneWidget);

      await tester.drag(find.text(currentHour), const Offset(0.0, 32.0),
          touchSlopY: 0);
      expect(find.text(currentHour), findsOneWidget);

      await tester.tap(find.text(currentHour));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('timeContainer')));
      await tester.pumpAndSettle();

      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('should render android time picker',
        (WidgetTester tester) async {
      String currentHour = TimeOfDay.now().hour.toString();
      // check if current time in [hour] is > than 12 then return [hour]
      // in am/pm formart
      if (TimeOfDay.now().hour > 12) {
        currentHour = TimeOfDay.now().hourOfPeriod.toString();
      }

      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return Material(
              child: SILTimePicker(
            labelText: 'time',
            controller: controller,
            onChanged: (String? _) {
              return '';
            },
            onSaved: (String? _) {
              return '';
            },
          ));
        }),
      ));

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('time'), findsOneWidget);
      await tester.tap(find.text('time'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(currentHour).first);
      await tester.pumpAndSettle();
      expect(find.text(currentHour), findsOneWidget);
    });

    testWidgets('should render android time picker changed',
        (WidgetTester tester) async {
      String currentHour = TimeOfDay.now().hour.toString();
      // check if current time in [hour] is > than 12 then return [hour]
      // in am/pm formart
      if (TimeOfDay.now().hour > 12) {
        currentHour = TimeOfDay.now().hourOfPeriod.toString();
      }

      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return Material(
              child: SILTimePicker(
            labelText: 'time',
            controller: controller,
            onChanged: (String? _) {
              return controller.text;
            },
            onSaved: (String? _) {
              return controller.text;
            },
          ));
        }),
      ));

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('time'), findsOneWidget);
      await tester.tap(find.text('time'));
      await tester.pumpAndSettle();
      expect(find.text(currentHour), findsOneWidget);
      expect(find.byType(Directionality), findsOneWidget);

      final Offset center = tester
          .getCenter(find.byKey(const ValueKey<String>('time-picker-dial')));
      await tester.tapAt(Offset(center.dx - 10.0, center.dy));

      expect(find.text('OK'), findsOneWidget);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.text(currentHour), findsNothing);
    });
  });
}
