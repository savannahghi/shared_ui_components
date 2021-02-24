import 'dart:collection';

import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:sil_themes/text_themes.dart';

import '../lib/sil_inputs.dart';
import '../lib/sil_loading.dart';
import '../lib/utils/widget_keys.dart';

void main() {
  group('SILPhoneNumberField', () {
    testWidgets('should render SILPhoneNumberField',
        (WidgetTester tester) async {
      const Key silPhoneInputKey = Key('sil_phone_input_key');
      const Key formKey = Key('form_key');
      final TextEditingController silPhoneInputController =
          TextEditingController();
      String selectedPhoneNumberFormat = '+254';

      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return Scaffold(
            body: Container(
              child: Form(
                key: formKey,
                child: SILPhoneNumberField(
                    phoneInputKey: silPhoneInputKey,
                    context: context,
                    controller: silPhoneInputController,
                    labelText: 'x',
                    onCountryPicked: (dynamic value) {
                      selectedPhoneNumberFormat = value.phoneCode;
                    }),
              ),
            ),
          );
        }),
      ));

      await tester.pumpAndSettle();

      // verify UI rendered correctly
      expect(find.byKey(formKey), findsOneWidget);
      expect(find.byKey(silPhoneInputKey), findsOneWidget);
      expect(find.text('x'), findsOneWidget);
      expect(find.text(selectedPhoneNumberFormat), findsOneWidget);
      expect(find.byType(CountryPickerDropdown), findsOneWidget);

      // selecting a country
      await tester.tap(find.byType(CountryPickerDropdown));
      await tester.pumpAndSettle();
      // (todo):adan confirm add country functionality

      // entering a phone number value
      await tester.tap(find.byKey(silPhoneInputKey));
      await tester.enterText(find.byKey(silPhoneInputKey), '0712345678');
      await tester.pumpAndSettle();

      // confirm phone number was entered
      expect(find.text('0712345678'), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('should render SILCheckbox ', (WidgetTester tester) async {
      const Key silCheckBoxKey = Key('sil_checkbox_key');
      int counter = 0;
      Widget testWidget = MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return Scaffold(
              body: Container(
            child: SILCheckbox(
              key: silCheckBoxKey,
              context: context,
              text: 'x',
              value: false,
              onChanged: (dynamic value) {
                counter = counter + 1;
              },
            ),
          ));
        }),
      );
      await tester.pumpWidget(testWidget);

      await tester.pumpAndSettle();

      // verify SILCheckbox renders correctly
      expect(find.byKey(silCheckBoxKey), findsOneWidget);
      expect(find.text('x'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
      expect(tester.getSize(find.byType(Checkbox)), const Size(48.0, 48.0));

      // tap checkbox
      await tester.tap(find.byKey(silCheckBoxKey));
      await tester.pumpAndSettle();
      expect(counter, 1);
    });

    testWidgets('should render SILRadio when rightAligned is false',
        (WidgetTester tester) async {
      int counter = 0;
      bool value = false;
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
      bool value = false;
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
      Queue<int> phoneNumberInputController = Queue<int>();
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return Scaffold(
              body: Container(
            child: SILPhoneInput(
              inputController: phoneNumberInputController,
              labelText: 'x',
              labelStyle: TextThemes.boldSize16Text(),
              hintText: 'y',
              context: context,
              onChanged: (dynamic value) {
                phoneNumberInputController.add(1);
              },
            ),
          ));
        }),
      ));

      await tester.pumpAndSettle();

      // verify ui rendered correctly
      expect(find.text('x'), findsOneWidget);
      expect(find.text('+254'), findsOneWidget);
      expect(find.byType(SILPhoneInput), findsOneWidget);
      expect(find.byType(CountryPickerDropdown), findsOneWidget);
      expect(find.byKey(textFormFieldKey), findsOneWidget);

      // selecting a country opens dropdown
      await tester.tap(find.byType(CountryPickerDropdown));
      await tester.pumpAndSettle();
      // (todo):adan confirm add country functionality

      // enter a valid KE phone number value
      await tester.tap(find.byKey(textFormFieldKey));
      await tester.enterText(find.byKey(textFormFieldKey), '0712345678');
      await tester.pumpAndSettle();

      // confirm phone number was entered
      expect(find.text('0712345678'), findsOneWidget);
      await tester.pumpAndSettle();

      // enter a valid US phone number value
      await tester.tap(find.byKey(textFormFieldKey));
      await tester.enterText(find.byKey(textFormFieldKey), '+12025550163');
      await tester.pumpAndSettle();

      // confirm phone number was entered
      expect(find.text('+12025550163'), findsOneWidget);
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

      Finder textFormField = find.byType(TextFormField);
      expect(textFormField, findsOneWidget);
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

      Finder textFormField = find.byType(TextFormField);
      expect(textFormField, findsOneWidget);

      await tester.tap(textFormField);
      await tester.pumpAndSettle();
      expect(isActionTapped, true);
    });
  });

  group('Row SILPhoneNumberField', () {
    testWidgets('should render correctly with initial value',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return Material(
              child: SILPhoneNumberField(
                  context: context,
                  controller: null,
                  initialValue: 'KE',
                  // ignore: non_constant_identifier_names
                  onCountryPicked: (dynamic Country) {}));
        }),
      ));

      await tester.pumpAndSettle();

      Finder containerWidget = find.byType(Container);
      expect(containerWidget, findsOneWidget);
    });
  });

  group('SILLoading', () {
    testWidgets('should show default loading indicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Center(
          child: SILLoading(
            color: Colors.greenAccent,
            size: 100,
          ),
        ),
      ));

      expect(find.byKey(cubeGridKey), findsOneWidget);
    });

    testWidgets('should show folding cube loading indicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Center(
          child: SILLoading(
            color: Colors.greenAccent,
            type: SILLoadingType.FoldingCube,
            size: 100,
          ),
        ),
      ));

      expect(find.byKey(foldingCubeKey), findsOneWidget);
    });

    testWidgets('should show chasing dots loading indicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Center(
          child: SILLoading(
            color: Colors.greenAccent,
            type: SILLoadingType.ChasingDots,
            size: 100,
          ),
        ),
      ));

      expect(find.byKey(chasingDotsKey), findsOneWidget);
    });

    testWidgets('should show ripple loading indicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Center(
          child: SILLoading(
            color: Colors.greenAccent,
            type: SILLoadingType.Ripple,
            size: 100,
          ),
        ),
      ));

      expect(find.byKey(rippleKey), findsOneWidget);
    });

    testWidgets('should show ripple loading indicator',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Center(
          child: SILLoading(
            color: Colors.greenAccent,
            type: null,
            size: 100,
          ),
        ),
      ));

      expect(find.byKey(cubeGridKey), findsOneWidget);
    });
  });

  group('SILSelectOptionField', () {
    testWidgets('SILSelectOptionField', (WidgetTester tester) async {
      String _selectedGender;
      final Key formKey = Key('select_option_field');
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
                    context: context,
                    hintText: 'Select gender',
                    value: _selectedGender,
                    options: options,
                    validator: (dynamic value) {
                      if (value.isEmpty || value == null) {
                        return 'required';
                      }
                      return null;
                    },
                    onSaved: (dynamic value) {},
                  )));
        })),
      );

      expect(find.byKey(formKey), findsOneWidget);
      expect(find.byKey(silSelectOptionField), findsOneWidget);
      expect(find.byType(DropdownButtonHideUnderline), findsOneWidget);

      //select gender
      await tester.tap(find.text('Female'));
      await tester.pumpAndSettle();
      //Todo: natasha investigate why it is duplicating
      expect(find.text('Female'), findsWidgets);
    });

    testWidgets('SILDatePicker', (WidgetTester tester) async {
      final Key formKey = Key('select_option_field');
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
                  )));
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
            onDone: null,
          ));
        }),
      ));

      await tester.pumpAndSettle();

      Finder pinCodeTextField = find.byType(PinCodeTextField);
      expect(pinCodeTextField, findsOneWidget);
    });
  });

  group('SILDatePickerField', () {
    TextEditingController controller;
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
          ));
        }),
      ));

      expect(find.byKey(datePickerKey), findsOneWidget);
      await tester.tap(find.byKey(datePickerKey));
      await tester.pumpAndSettle();
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(CupertinoDatePicker), findsWidgets);
      debugDefaultTargetPlatformOverride = null;
      await tester.tap(find.text('January'));
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
                  allowFutureYears: true));
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
          ));
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
                  allowCurrentYear: true));
        }),
      ));

      expect(find.byKey(datePickerKey), findsOneWidget);
      await tester.tap(find.byKey(datePickerKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text('15'));
    });
  });
}
