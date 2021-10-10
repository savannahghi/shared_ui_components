import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:shared_themes/text_themes.dart';
import 'package:shared_ui_components/country_picker.dart';
import 'package:shared_ui_components/fancy_loading.dart';
import 'package:shared_ui_components/inputs.dart';
import 'package:shared_ui_components/src/constants.dart';
import 'package:shared_ui_components/src/widget_keys.dart';

void main() {
  final DateTime now = DateTime.now();
  final int thisYear = now.year;
  final int nextFourYears = thisYear + 4;
  final int eligibleYear = thisYear - 18;
  group('SILPhoneNumberField', () {
    testWidgets('should render SILCheckbox when a child widget is passed',
        (WidgetTester tester) async {
      const Key silCheckBoxKey = Key('sil_checkbox_key');

      bool counter = false;
      bool onTap = false;
      const String checkBoxActionText = 'Action';
      final Widget testWidget = MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: SILCheckbox(
                checkboxKey: silCheckBoxKey,
                text: '',
                value: true,
                onChanged: (bool? value) {
                  counter = value!;
                },
                onTap: () {
                  onTap = true;
                },
                child: RichText(
                  text: TextSpan(
                    text: '',
                    style: Theme.of(context).textTheme.bodyText1,
                    children: <TextSpan>[
                      TextSpan(
                        text: checkBoxActionText,
                        style: const TextStyle(color: Colors.white),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // navigate to desired screen
                            onTap = true;
                          },
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await tester.pumpAndSettle();

      // verify SILCheckbox renders correctly
      expect(find.byType(RichText), findsOneWidget);
      expect(
          find.byWidgetPredicate((Widget widget) =>
              widget is RichText &&
              widget.text.toPlainText().startsWith(checkBoxActionText)),
          findsOneWidget);

      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.byKey(silCheckBoxKey), findsOneWidget);
      expect(tester.getSize(find.byType(Checkbox)), const Size(48.0, 48.0));

      await tester.tap(find.byKey(silCheckBoxKey));
      await tester.pump();

      expect(counter, false);

      await tester.tap(find.byWidgetPredicate((Widget widget) =>
          widget is RichText &&
          widget.text.toPlainText().startsWith(checkBoxActionText)));
      await tester.pumpAndSettle();

      expect(onTap, true);
    });

    testWidgets('should render SILCheckbox when no child widget is passed',
        (WidgetTester tester) async {
      const Key silCheckBoxKey = Key('sil_checkbox_key');

      bool counter = false;
      const String checkBoxActionText = 'Action';
      final Widget testWidget = MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: SILCheckbox(
                checkboxKey: silCheckBoxKey,
                text: checkBoxActionText,
                value: counter,
                onChanged: (bool? value) {
                  counter = value!;
                },
              ),
            );
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await tester.pumpAndSettle();

      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.byKey(silCheckBoxKey), findsOneWidget);
      expect(tester.getSize(find.byType(Checkbox)), const Size(48.0, 48.0));
      expect(find.text(checkBoxActionText), findsOneWidget);

      await tester.tap(find.byKey(silCheckBoxKey));
      await tester.pump();

      expect(counter, true);
    });

    testWidgets('should render SILRadio when rightAligned is false',
        (WidgetTester tester) async {
      bool isSelected = false;

      const Key silRadioKey = Key('sil_radio_key');

      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return Scaffold(
            body: SILRadio<bool>(
              radioButtonKey: silRadioKey,
              text: 'x',
              value: true,
              onChanged: (bool? value) {
                isSelected = value!;
              },
              groupValue: null,
            ),
          );
        }),
      ));

      // verify SILRadio renders correctly
      expect(find.byKey(silRadioKey), findsOneWidget);
      expect(find.text('x'), findsOneWidget);

      // tap checkbox
      await tester.tap(find.byKey(silRadioKey));
      await tester.pump();

      expect(isSelected, true);
    });

    testWidgets('should render SILRadio when rightAligned is true',
        (WidgetTester tester) async {
      bool value = false;

      const Key silRadioKey = Key('sil_radio_key');
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: SILRadio<bool>(
                radioButtonKey: silRadioKey,
                text: 'x',
                value: true,
                rightAligned: true,
                onChanged: (bool? v) => value = v!,
                groupValue: null,
              ),
            );
          },
        ),
      ));

      await tester.pumpAndSettle();

      // verify SILRadio renders correctly
      expect(find.byKey(silRadioKey), findsOneWidget);
      expect(find.text('x'), findsOneWidget);

      // tap checkbox
      await tester.tap(find.byKey(silRadioKey));
      await tester.pumpAndSettle();
      expect(value, true);
    });

    testWidgets('should render SILPhoneInput ', (WidgetTester tester) async {
      String formatPhoneNumber(
          {required String countryCode, required String phoneNumber}) {
        if (!countryCode.startsWith('+')) {
          return '+$countryCode';
        }
        if (countryCode == '+1') {
          return '$countryCode$phoneNumber';
        }
        if (phoneNumber.startsWith('0')) {
          return phoneNumber.substring(1);
        }
        return '$countryCode$phoneNumber';
      }

      final TextEditingController phoneNumberInputController =
          TextEditingController();
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return Scaffold(
              body: SizedBox(
            child: SILPhoneInput(
              autoValidate: true,
              inputController: phoneNumberInputController,
              labelText: 'x',
              labelStyle: TextThemes.boldSize16Text(),
              onChanged: (String? value) {},
              phoneNumberFormatter: formatPhoneNumber,
            ),
          ));
        }),
      ));

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('countrySelectedKey')), findsOneWidget);

      expect(find.text('+254'), findsOneWidget);

      await tester.tap(find.byKey(textFormFieldKey));
      await tester.enterText(find.byKey(textFormFieldKey), '0712345678');
      await tester.pumpAndSettle();

      expect(find.byType(SILCountryPicker), findsOneWidget);
      await tester.tap(find.byType(SILCountryPicker));
      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsNWidgets(6));
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

  testWidgets('should render show error message if number is short  ',
      (WidgetTester tester) async {
    String formatPhoneNumber(
        {required String countryCode, required String phoneNumber}) {
      if (!countryCode.startsWith('+')) {
        return '+$countryCode';
      }
      if (countryCode == '+1') {
        return '$countryCode$phoneNumber';
      }
      if (phoneNumber.startsWith('0')) {
        return phoneNumber.substring(1);
      }
      return '$countryCode$phoneNumber';
    }

    final TextEditingController phoneNumberInputController =
        TextEditingController();
    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (BuildContext context) {
        return Scaffold(
            body: SizedBox(
          child: SILPhoneInput(
            autoValidate: true,
            inputController: phoneNumberInputController,
            labelText: 'x',
            labelStyle: TextThemes.boldSize16Text(),
            onChanged: (String? value) {},
            phoneNumberFormatter: formatPhoneNumber,
          ),
        ));
      }),
    ));

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('countrySelectedKey')), findsOneWidget);

    expect(find.text('+254'), findsOneWidget);

    // enter a valid KE phone number value
    await tester.tap(find.byKey(textFormFieldKey));
    await tester.enterText(find.byKey(textFormFieldKey), '075678');
    await tester.pumpAndSettle();

    expect(find.text(validPhoneNumberText), findsOneWidget);
  });

  testWidgets('should render show error message if number is invalid  ',
      (WidgetTester tester) async {
    String formatPhoneNumber(
        {required String countryCode, required String phoneNumber}) {
      if (!countryCode.startsWith('+')) {
        return '+$countryCode';
      }
      if (countryCode == '+1') {
        return '$countryCode$phoneNumber';
      }
      if (phoneNumber.startsWith('0')) {
        return phoneNumber.substring(1);
      }
      return '$countryCode$phoneNumber';
    }

    final TextEditingController phoneNumberInputController =
        TextEditingController();
    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (BuildContext context) {
        return Scaffold(
            body: SizedBox(
          child: SILPhoneInput(
            autoValidate: true,
            inputController: phoneNumberInputController,
            labelText: 'x',
            labelStyle: TextThemes.boldSize16Text(),
            onChanged: (String? value) {},
            phoneNumberFormatter: formatPhoneNumber,
          ),
        ));
      }),
    ));

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('countrySelectedKey')), findsOneWidget);

    expect(find.text('+254'), findsOneWidget);

    // enter a valid KE phone number value
    await tester.tap(find.byKey(textFormFieldKey));
    await tester.enterText(find.byKey(textFormFieldKey), '12345678911');
    await tester.pumpAndSettle();

    expect(find.text(validPhoneNumberText), findsOneWidget);
  });

  group('SILFormTextField', () {
    testWidgets('should render correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return const Material(child: SILFormTextField());
        }),
      ));

      await tester.pumpAndSettle();

      final Finder textFormField = find.byType(TextFormField);
      expect(textFormField, findsOneWidget);
      await tester.showKeyboard(find.byType(TextFormField));
      await tester.enterText(find.byType(TextFormField), 'text');
      await tester.pumpAndSettle();
    });

    testWidgets(
        'should render correctly when SILFormTextField is looked up '
        'using a key', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return const Material(
              child: SILFormTextField(
            key: Key('some-key'),
          ));
        }),
      ));

      await tester.pump();

      final Finder textFormField = find.byKey(const Key('some-key'));

      expect(textFormField, findsOneWidget);

      await tester.showKeyboard(textFormField);
      await tester.enterText(textFormField, 'text');
      await tester.pumpAndSettle();

      expect(find.text('text'), findsOneWidget);
    });

    testWidgets('should test SILFormTextField', (WidgetTester tester) async {
      final GlobalKey<FormState> key = GlobalKey<FormState>();
      bool valid = false;
      bool _called = false;
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return Material(
            child: Column(
              children: <Widget>[
                Form(
                  key: key,
                  child: SILFormTextField(
                    onChanged: (String value) {},
                    validator: (dynamic val) {
                      if (val == '') {
                        return '';
                      }
                      return null;
                    },
                    onFieldSubmit: (String value) {
                      _called = true;
                    },
                  ),
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

      await tester.showKeyboard(find.byType(TextField));
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(_called, true);
    });

    testWidgets('should render correctly with tap action',
        (WidgetTester tester) async {
      bool isActionTapped = false;

      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return Material(child: SILFormTextField(onTap: () {
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

    testWidgets(
        'should throw assertion error if both controller and initialValue'
        ' are not null', (WidgetTester tester) async {
      final TextEditingController controller = TextEditingController();

      Future<void> pump() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SILFormTextField(
                controller: controller,
                initialValue: '',
              ),
            ),
          ),
        );
      }

      expect(pump(), throwsAssertionError);
    });

    testWidgets('should have grey fill color if form is not enabled',
        (WidgetTester tester) async {
      const Key fieldKey = Key('field-key');
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SILFormTextField(
              enabled: false,
              fieldKey: fieldKey,
              initialValue: '',
            ),
          ),
        ),
      );

      final TextField formField =
          tester.widget<TextField>(find.byType(TextField));
      expect(formField.decoration?.fillColor, Colors.grey[200]);
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

      await tester.tap(find.text('Select gender'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Female').last);
      await tester.pumpAndSettle();
    });

    testWidgets('should not be tappable if field is disabled',
        (WidgetTester tester) async {
      int counter = 0;

      const String value = 'John';
      final List<String> options = <String>['John', 'Jane', 'Doe'];
      const Key key = Key('drop-down-input');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SILSelectOptionField(
              disabled: true,
              dropDownInputKey: key,
              value: value,
              options: options,
              onChanged: (String? value) => counter++,
            ),
          ),
        ),
      );

      final Finder dropDownFinder = find.byKey(key);
      final DropdownButton<String> dropDownBtn =
          tester.widget<DropdownButton<String>>(dropDownFinder);
      expect(dropDownBtn.onChanged, isNull);
      await tester.tap(dropDownFinder);
      await tester.pump();
      expect(counter, 0);

      final Finder secondOption =
          find.byKey(ValueKey<String>(options[1]), skipOffstage: false);
      expect(secondOption, findsOneWidget);
      await tester.tap(secondOption);
      await tester.pump();
      expect(counter, 0);
    });
  });

  testWidgets('SILDatePicker', (WidgetTester tester) async {
    const Key formKey = Key('select_option_field');
    final TextEditingController datePickerController = TextEditingController();
    await tester.pumpWidget(
      MaterialApp(home: Builder(builder: (BuildContext context) {
        return Scaffold(
            body: Form(
                key: formKey,
                child: SILDatePickerField(
                    gestureDateKey: silDatePickerField,
                    hintText: 'Enter dob',
                    allowEligibleDate: true,
                    controller: datePickerController,
                    keyboardType: TextInputType.datetime,
                    onChanged: (dynamic val) {
                      datePickerController.text;
                    })));
      })),
    );

    expect(find.byKey(formKey), findsOneWidget);
    expect(find.byKey(silDatePickerField), findsOneWidget);

    await tester.tap(find.byKey(silDatePickerField));
    await tester.pumpAndSettle();

    expect(find.text(eligibleYear.toString()), findsOneWidget);

    await tester.tap(find.text(eligibleYear.toString()));
    await tester.pumpAndSettle();

    expect(find.text(currentDay.toString()), findsOneWidget);
    await tester.tap(find.text(currentDay.toString()));

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(
        datePickerController.text,
        DateFormat('d MMM yyyy')
            .format(DateTime(eligibleYear, currentMonth, currentDay)));
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
      final DateFormat formatter = DateFormat('MMMM');
      final String _month = formatter.format(now);
      const Key materialKey = Key('material_key');

      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return Material(
              key: materialKey,
              child: SILDatePickerField(
                  controller: controller,
                  gestureDateKey: datePickerKey,
                  onChanged: (dynamic val) {
                    controller.text;
                  }));
        }),
      ));

      expect(find.byKey(datePickerKey), findsOneWidget);
      await tester.tap(find.byKey(datePickerKey));
      await tester.pumpAndSettle();
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(CupertinoDatePicker), findsOneWidget);

      expect(find.text(_month), findsOneWidget);
      await tester.drag(find.text(_month), const Offset(0, 70.0));

      await tester.pumpAndSettle();

      await tester.tap(find.byKey(datePickerKey));
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
                  controller: controller,
                  gestureDateKey: datePickerKey,
                  allowCurrentYear: true,
                  onChanged: (dynamic val) {
                    controller.text;
                  }));
        }),
      ));

      expect(find.byKey(datePickerKey), findsOneWidget);
      await tester.tap(find.byKey(datePickerKey));
      await tester.pumpAndSettle();
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(CupertinoDatePicker), findsWidgets);

      expect(find.text(thisYear.toString()), findsOneWidget);
      expect(find.text(nextFourYears.toString()), findsNothing);

      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('should render android date picker',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return Material(
              child: SILDatePickerField(
                  controller: controller,
                  gestureDateKey: datePickerKey,
                  onChanged: (dynamic val) {}));
        }),
      ));

      expect(find.byKey(datePickerKey), findsOneWidget);
      await tester.tap(find.byKey(datePickerKey));
      await tester.pumpAndSettle();

      await tester.tap(find.text(eligibleYear.toString()));
      expect(find.text(eligibleYear.toString()), findsOneWidget);
    });

    testWidgets('should render android date picker with allowed Future years',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return Material(
              child: SILDatePickerField(
                  controller: controller,
                  gestureDateKey: datePickerKey,
                  onChanged: (dynamic val) {
                    controller.text;
                  },
                  allowFutureYears: true));
        }),
      ));

      expect(find.byKey(datePickerKey), findsOneWidget);
      await tester.tap(find.byKey(datePickerKey));
      await tester.pumpAndSettle();

      expect(find.text(eligibleYear.toString()), findsOneWidget);

      await tester.tap(find.text(eligibleYear.toString()));
      await tester.pumpAndSettle();

      expect(find.text('3'), findsOneWidget);
      await tester.tap(find.text('3'));

      expect(find.text('OK'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(
          controller.text,
          DateFormat('d MMM yyyy')
              .format(DateTime(eligibleYear, currentMonth, 3)));
    });

    testWidgets('should render android date picker with allowed current years',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (BuildContext context) {
          return Material(
              child: SILDatePickerField(
                  controller: controller,
                  gestureDateKey: datePickerKey,
                  onChanged: (dynamic val) {
                    controller.text;
                  },
                  allowCurrentYear: true));
        }),
      ));

      expect(find.byKey(datePickerKey), findsOneWidget);
      await tester.tap(find.byKey(datePickerKey));
      await tester.pumpAndSettle();

      expect(find.text(thisYear.toString()), findsOneWidget);

      await tester.tap(find.text(thisYear.toString()));
      await tester.pumpAndSettle();

      expect(find.text(currentDay.toString()), findsOneWidget);
      await tester.tap(find.text(currentDay.toString()));

      expect(find.text('OK'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(
          controller.text,
          DateFormat('d MMM yyyy')
              .format(DateTime(thisYear, currentMonth, currentDay)));
    });
  });
}
