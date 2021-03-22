import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:sil_ui_components/sil_country_picker.dart';
import 'package:sil_ui_components/sil_fancy_loading.dart';
import 'package:sil_ui_components/sil_inputs.dart';
import 'package:sil_themes/text_themes.dart';
import 'package:sil_ui_components/src/widget_keys.dart';

void main() {
  group('SILPhoneNumberField', () {
    testWidgets('should render SILCheckbox ', (WidgetTester tester) async {
      const Key silCheckBoxKey = Key('sil_checkbox_key');
      bool counter = false;
      final Widget testWidget = MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return Scaffold(
              body: Container(
            child: SILCheckbox(
              key: silCheckBoxKey,
              context: context,
              text: 'x',
              value: false,
              onChanged: (dynamic value) {
                counter = !counter;
              },
            ),
          ));
        }),
      );
      await tester.pumpWidget(testWidget);

      await tester.pumpAndSettle();

      // verify SILCheckbox renders correctly
      expect(find.text('x'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.byKey(silCheckBoxKey), findsOneWidget);
      expect(tester.getSize(find.byType(Checkbox)), const Size(48.0, 48.0));

      await tester.tap(find.byKey(silCheckBoxKey));
      await tester.pump();

      expect(counter, true);

      await tester.tap(find.byKey(silCheckBoxKey));
      await tester.pump();

      expect(counter, false);
    });

    testWidgets('should render SILRadio when rightAligned is false',
        (WidgetTester tester) async {
      int counter = 0;
      const bool value = false;
      const Key silRadioKey = Key('sil_radio_key');
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return Scaffold(
              body: Container(
            child: SILRadio(
              radioKey: silRadioKey,
              context: context,
              text: 'x',
              value: value,
              onChanged: (dynamic value) {
                counter = counter + 1;
              },
              groupValue: 'null',
            ),
          ));
        }),
      ));

      await tester.pumpAndSettle();

      // verify SILRadio renders correctly
      expect(find.byKey(silRadioKey), findsOneWidget);
      expect(find.text('x'), findsOneWidget);
      expect(find.byType(Radio), findsOneWidget);

      // tap checkbox
      await tester.tap(find.byKey(silRadioKey));
      await tester.pumpAndSettle();
      expect(counter, 1);
    });

    testWidgets('should render SILRadio when rightAligned is true',
        (WidgetTester tester) async {
      const bool value = false;
      int counter = 0;
      const Key silRadioKey = Key('sil_radio_key');
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return Scaffold(
              body: Container(
            child: SILRadio(
              radioKey: silRadioKey,
              context: context,
              text: 'x',
              value: value,
              rightAligned: true,
              onChanged: (dynamic value) {
                counter = counter + 1;
              },
              groupValue: 'null',
            ),
          ));
        }),
      ));

      await tester.pumpAndSettle();

      // verify SILRadio renders correctly
      expect(find.byKey(silRadioKey), findsOneWidget);
      expect(find.text('x'), findsOneWidget);
      expect(find.byType(Radio), findsOneWidget);

      // tap checkbox
      await tester.tap(find.byKey(silRadioKey));
      await tester.pumpAndSettle();
      expect(counter, 1);
    });

    testWidgets('should render SILPhoneInput ', (WidgetTester tester) async {
      final Queue<int> phoneNumberInputController = Queue<int>();
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return Scaffold(
              body: SizedBox(
            child: SILPhoneInput(
              inputController: phoneNumberInputController,
              labelText: 'x',
              labelStyle: TextThemes.boldSize16Text(),
              onChanged: (dynamic value) {
                phoneNumberInputController.add(1);
              },
            ),
          ));
        }),
      ));

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('countrySelectedKey')), findsOneWidget);

      expect(find.text('+254'), findsOneWidget);

      // enter a valid KE phone number value
      await tester.tap(find.byKey(textFormFieldKey));
      await tester.enterText(find.byKey(textFormFieldKey), '0712345678');
      await tester.pumpAndSettle();

      expect(find.byType(SILCountryPicker), findsOneWidget);
      await tester.tap(find.byType(SILCountryPicker));
      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsNWidgets(4));
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      // confirm phone number was entered
      expect(find.text('0712345678'), findsOneWidget);
      await tester.pumpAndSettle();

      // enter a valid US phone number value
      await tester.tap(find.byKey(textFormFieldKey));
      await tester.enterText(find.byKey(textFormFieldKey), '728101710');
      await tester.pumpAndSettle();

      // confirm phone number was entered
      expect(find.text('728101710'), findsOneWidget);
      expect(find.text('+254'), findsOneWidget);
      await tester.pumpAndSettle();
    });
  });

  group('SILFormTextField', () {
    testWidgets('should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return Material(child: SILFormTextField(context: context));
        }),
      ));

      await tester.pumpAndSettle();

      final Finder textFormField = find.byType(TextFormField);
      expect(textFormField, findsOneWidget);
      await tester.showKeyboard(find.byType(TextFormField));
      await tester.enterText(find.byType(TextFormField), 'text');
      await tester.pumpAndSettle();
    });

    testWidgets('should test SILFormTextField', (WidgetTester tester) async {
      final GlobalKey<FormState> key = GlobalKey<FormState>();
      bool valid = false;
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return Material(
            child: Column(
              children: <Widget>[
                Form(
                  key: key,
                  child: SILFormTextField(
                      onChanged: (String _) {},
                      context: context,
                      validator: (dynamic val) {
                        if (val == '') {
                          return '';
                        }
                        return null;
                      }),
                ),
                MaterialButton(onPressed: () {
                  if (key.currentState!.validate()) {
                    valid = false;
                  }
                  valid = true;
                })
              ],
            ),
          );
        }),
      ));

      await tester.pumpAndSettle();

      final Finder textFormField = find.byType(TextFormField);
      expect(textFormField, findsOneWidget);
      await tester.pumpAndSettle();
      await tester.enterText(textFormField, 'text');
      await tester.pumpAndSettle();
      await tester.tap(find.byType(MaterialButton));
      await tester.pumpAndSettle();
      expect(valid, true);
    });

    testWidgets('should render correctly with tap action',
        (WidgetTester tester) async {
      bool isActionTapped = false;

      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return Material(
              child: SILFormTextField(
                  context: context,
                  onTap: () {
                    isActionTapped = true;
                  }));
        }),
      ));

      await tester.pumpAndSettle();

      final Finder textFormField = find.byType(TextFormField);
      expect(textFormField, findsOneWidget);

      await tester.tap(textFormField);
      await tester.pumpAndSettle();
      expect(isActionTapped, true);
    });
  });

  group('SILFancyLoading', () {
    testWidgets('should show default loading indicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Center(
          child: SILFancyLoading(
            color: Colors.greenAccent,
            size: 100,
          ),
        ),
      ));

      expect(find.byKey(cubeGridKey), findsOneWidget);
    });

    testWidgets('should show folding cube loading indicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Center(
          child: SILFancyLoading(
            color: Colors.greenAccent,
            type: SILFancyLoadingType.foldingCube,
            size: 100,
          ),
        ),
      ));

      expect(find.byKey(foldingCubeKey), findsOneWidget);
    });

    testWidgets('should show chasing dots loading indicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Center(
          child: SILFancyLoading(
            color: Colors.greenAccent,
            type: SILFancyLoadingType.chasingDots,
            size: 100,
          ),
        ),
      ));

      expect(find.byKey(chasingDotsKey), findsOneWidget);
    });

    testWidgets('should show ripple loading indicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Center(
          child: SILFancyLoading(
            color: Colors.greenAccent,
            type: SILFancyLoadingType.ripple,
            size: 100,
          ),
        ),
      ));

      expect(find.byKey(rippleKey), findsOneWidget);
    });

    testWidgets('should show ripple loading indicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Center(
          child: SILFancyLoading(
            color: Colors.greenAccent,
            size: 100,
          ),
        ),
      ));

      expect(find.byKey(cubeGridKey), findsOneWidget);
    });
  });

  group('SILSelectOptionField', () {
    testWidgets('SILSelectOptionField', (WidgetTester tester) async {
      Type typeOf<T>() {
        return T;
      }

      const String _selectedGender = 'Male';
      const Key formKey = Key('select_option_field');
      final List<String> options = <String>[
        'Male',
        'Female',
        'Unknown',
        'Other'
      ];

      await tester.pumpWidget(
        MaterialApp(home: Builder(builder: (BuildContext context) {
          return Scaffold(
              body: Form(
                  key: formKey,
                  child: SILSelectOptionField(
                      dropDownInputKey: silSelectOptionField,
                      hintText: 'Select gender',
                      value: _selectedGender,
                      options: options,
                      onSaved: (dynamic value) {},
                      onChanged: (dynamic val) {})));
        })),
      );

      expect(find.byKey(formKey), findsOneWidget);

      expect(find.byKey(silSelectOptionField), findsOneWidget);
      expect(find.byType(DropdownButtonHideUnderline), findsOneWidget);
      expect(find.byType(typeOf<DropdownButton<String>>()), findsOneWidget);
    });

    testWidgets('SILDatePicker', (WidgetTester tester) async {
      const Key formKey = Key('select_option_field');
      final TextEditingController datePickerController =
          TextEditingController();
      await tester.pumpWidget(
        MaterialApp(home: Builder(builder: (BuildContext context) {
          return Scaffold(
              body: Form(
                  key: formKey,
                  child: SILDatePickerField(
                      gestureDateKey: silDatePickerField,
                      context: context,
                      hintText: 'Enter dob',
                      allowEligibleDate: true,
                      controller: datePickerController,
                      keyboardType: TextInputType.datetime,
                      onChanged: (dynamic val) {})));
        })),
      );

      expect(find.byKey(formKey), findsOneWidget);
      expect(find.byKey(silDatePickerField), findsOneWidget);

      await tester.tap(find.byKey(silDatePickerField));
      await tester.pumpAndSettle();

      await tester.tap(find.text('12'));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
    });
  });

  group('SILPinCodeTextField', () {
    testWidgets('should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return Material(
              child: SILPinCodeTextField(
            maxLength: null,
            onDone: (String val) {},
            onTextChanged: (String val) {},
          ));
        }),
      ));

      await tester.pumpAndSettle();
      expect(find.byType(SILPinCodeTextField), findsOneWidget);

      await tester.showKeyboard(find.byType(SILPinCodeTextField));
      await tester.enterText(find.byType(SILPinCodeTextField), '1234');
      await tester.pumpAndSettle();

      final Finder pinCodeTextField = find.byType(PinCodeTextField);
      expect(pinCodeTextField, findsOneWidget);
    });
  });

  group('SILDatePickerField', () {
    final TextEditingController controller = TextEditingController();
    const Key datePickerKey = Key('date_piker');

    testWidgets('should render ios date picker', (WidgetTester tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return Material(
              child: SILDatePickerField(
                  context: context,
                  controller: controller,
                  gestureDateKey: datePickerKey,
                  onChanged: (dynamic val) {}));
        }),
      ));

      expect(find.byKey(datePickerKey), findsOneWidget);
      await tester.tap(find.byKey(datePickerKey));
      await tester.pumpAndSettle();
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(CupertinoDatePicker), findsWidgets);
      await tester.tap(find.text('January'));
      await tester.pumpAndSettle();

      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('should render ios date picker with allowed current year',
        (WidgetTester tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return Material(
              child: SILDatePickerField(
                  context: context,
                  controller: controller,
                  gestureDateKey: datePickerKey,
                  allowCurrentYear: true,
                  allowEligibleDate: true,
                  allowFutureYears: true,
                  onChanged: (dynamic val) {}));
        }),
      ));

      expect(find.byKey(datePickerKey), findsOneWidget);
      await tester.tap(find.byKey(datePickerKey));
      await tester.pumpAndSettle();
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(CupertinoDatePicker), findsWidgets);

      await tester.tap(find.text('January'));
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('should render android date picker',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return Material(
              child: SILDatePickerField(
                  context: context,
                  controller: controller,
                  gestureDateKey: datePickerKey,
                  onChanged: (dynamic val) {}));
        }),
      ));

      expect(find.byKey(datePickerKey), findsOneWidget);
      await tester.tap(find.byKey(datePickerKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text('15'));
    });

    testWidgets('should render android date picker with allowed current year',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return Material(
              child: SILDatePickerField(
                  context: context,
                  controller: controller,
                  gestureDateKey: datePickerKey,
                  onChanged: (dynamic val) {},
                  allowCurrentYear: true));
        }),
      ));

      expect(find.byKey(datePickerKey), findsOneWidget);
      await tester.tap(find.byKey(datePickerKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text('15'));
      await tester.pumpAndSettle();
    });
  });
}
