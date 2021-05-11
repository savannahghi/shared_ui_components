import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sil_ui_components/src/bewell_select_input.dart';
import 'package:sil_ui_components/src/widget_keys.dart';

void main() {
  testWidgets('should render correctly', (WidgetTester tester) async {
    Type typeOf<T>() {
      return T;
    }

    const Key _formKey = Key('bewell_select_input');

    const List<String> routeOptions = <String>[
      'Capsules',
      'Oral',
      'Injection',
      'Sublingual',
      'Nasal',
      'ml',
      'mg'
    ];

    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Form(
          key: _formKey,
          child: BeWellSelectInput(
            onChanged: increment,
            options: routeOptions,
            value: 'Capsules',
            dropDownInputKey: selectInputDropdownKey,
          ),
        ),
      ),
    ));

    // verify UI renders
    expect(find.byKey(selectInputDropdownKey), findsOneWidget);
    expect(find.byType(DropdownButtonHideUnderline), findsOneWidget);
    expect(find.byType(typeOf<DropdownButton<String>>()), findsOneWidget);
    // open dropdown
    await tester.tap(find.text('Capsules'));
    await tester.pumpAndSettle();
    expect(counter, 1);
    //verify dropdown is open and change value
    expect(find.text('Oral'), findsWidgets);
    await tester.tap(find.text('Oral').first);
    await tester.pumpAndSettle();
    expect(counter, 2);
  });
}

int counter = 0;

void increment(String? v) {
  counter += 1;
  return;
}
