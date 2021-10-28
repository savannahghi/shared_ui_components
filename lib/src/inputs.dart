import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:misc_utilities/misc.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:shared_themes/colors.dart';
import 'package:shared_themes/text_themes.dart';
import 'package:shared_ui_components/country_picker.dart';
import 'package:shared_ui_components/src/helpers.dart';
import 'package:shared_ui_components/src/type_defs.dart';

import 'constants.dart';
import 'widget_keys.dart';

/// SILPhoneInput generic phone number input field
///
/// It expects the follow required arguments:
/// [inputController] keeps a log of interactions with the input FormField
/// [onChanged] function called when the value changes
/// [context] the buildContext of where the field is been used in the widget TriggeredEvent
/// [labelText] the label for the field
/// [smallHorizontalSizedBox] sizing information for the input
/// [labelStyle] how to style the field
///
/// example
///
/// ```dart
/// SILPhoneInput(
///   inputController: phoneNumberInputController,
///   enableController: null,
///   smallHorizontalSizedBox: smallVerticalSizedBox,
///   labelStyle: TextThemes.boldSize16Text(),
///   labelText: 'Phone number',
///   hintText: 'Enter your phone number',
///   context: context,
///   onChanged: (dynamic val) {
///     this.phoneNumberInputController.add(1); // how the inputController is updated
///     phoneNumber = val;
///   },
/// ),
/// ```
///
///

class SILPhoneInput extends FormField<String> {
  SILPhoneInput({
    required TextEditingController? inputController,
    required FormFieldSetter<String> onChanged,
    required String? labelText,
    required TextStyle? labelStyle,
    required PhoneNumberFormatterFunc phoneNumberFormatter,
    bool? enabled,
    bool? autoFocus,
    String? initialValue = '',
    bool autoValidate = false,
  }) : super(
          enabled: enabled ?? true,
          autovalidateMode: autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          validator: (String? value) {
            final PhoneInputBehaviorSubject phoneInputBehaviorSubject =
                PhoneInputBehaviorSubject();

            final String countryCode =
                phoneInputBehaviorSubject.countryCode.valueOrNull!;

            if (value != null) {
              if (value.isEmpty) {
                return phoneNumberRequiredText;
              }

              final List<int> validLengths = <int>[9, 10];

              if (!validLengths.contains(value.length)) {
                return validPhoneNumberText;
              }

              String phone;

              if (value.startsWith('0')) {
                phone = value.substring(1);
              } else {
                phone = value;
              }

              if (!validatePhoneNumber('$countryCode$phone')) {
                return validPhoneNumberText;
              }
              if (countryCode == '+254' &&
                  !validateKenyanNumber('$countryCode$phone')) {
                return validPhoneNumberText;
              }
            }
          },
          initialValue: inputController != null
              ? inputController.text
              : (initialValue ?? ''),
          builder: (FormFieldState<String> state) {
            final PhoneInputBehaviorSubject phoneInputBehaviorSubject =
                PhoneInputBehaviorSubject();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[350]!),
                      color: Colors.grey.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        height: 54,
                        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                        decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(color: Colors.grey[350]!)),
                        ),
                        child: SILCountryPicker(
                          onChanged: (String value) {
                            phoneInputBehaviorSubject.countryCode.add(value);
                            onChanged(
                              phoneNumberFormatter(
                                countryCode: phoneInputBehaviorSubject
                                    .countryCode.valueOrNull!,
                                phoneNumber: phoneInputBehaviorSubject
                                    .phoneNumber.valueOrNull!,
                              ),
                            );
                          },
                        ),
                      ),
                      Flexible(
                        child: SizedBox(
                          height: 54,
                          child: Center(
                            child: TextFormField(
                              autofocus: autoFocus ?? false,
                              key: textFormFieldKey,
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                labelText: labelText,
                                labelStyle: labelStyle,
                                border: InputBorder.none,
                                fillColor: Colors.transparent,
                                contentPadding:
                                    const EdgeInsets.fromLTRB(15, 0, 15, 15),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (String value) {
                                state.didChange(value);
                                inputController?.text = value;
                                phoneInputBehaviorSubject.phoneNumber
                                    .add(value);
                                onChanged(
                                  phoneNumberFormatter(
                                    countryCode: phoneInputBehaviorSubject
                                        .countryCode.valueOrNull!,
                                    phoneNumber: value,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 10),
                    child: Text(
                      state.errorText.toString(),
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                else
                  Container()
              ],
            );
          },
        );
}

/// [SILFormTextField] customized [TextFormField]
/// Example
/// ```dart
///    SILFormTextField(
///     context: context,
///    labelText: 'First name',
///    hintText: 'Enter the patient\'s first name',
///    validator: (dynamic value) {
///    if (value.isEmpty) {
///      return ' First name is required';
///    }
///    return null;
///   },
///   onChanged: (dynamic value) {
///   <do-something-awesome-here>
///   },
///  onSaved: (dynamic value) {
///     <do-something-awesome-here>
/// })
/// ```
/// Every other property here is the normal one except the following:
///   1. [isSearchField] is used to make the input box expanded in height
///       to fit the needs of `patient identification search`
///   2. [isSearchFieldSmall] is used to make the input field smaller than normal
///       so it can look like a nice search box
///   3. [autoFocus] - if this value is set to true, the input is automatically
///       focused the moment the UI containing that widget is rendered
///   4. [context] is used when applying the active and focused colors depending
///       on the provided context. For example getting colors from [Theme.of(context)]
class SILFormTextField extends StatelessWidget {
  /// When a [controller] is specified, [initialValue] must be null (the
  /// default).
  const SILFormTextField({
    Key? key,
    this.enabled,
    this.controller,
    this.onSaved,
    this.onTap,
    this.labelText,
    this.hintText,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.onFieldSubmit,
    this.focusNode,
    this.keyboardType,
    this.formatters,
    this.maxLines,
    this.maxLength,
    this.textStyle,
    this.suffixIcon,
    this.isSearchField,
    this.obscureText,
    this.autoValidate = false,
    this.isSearchFieldSmall,
    this.autoFocus,
    this.inputFormatters,
    this.prefixIcon,
    this.textInputAction,
    this.customFillColor,
    this.hintColor,
    this.hintTextColor,
    this.borderColor,
    this.textFieldBackgroundColor,
    this.decoration,
    this.fieldKey,
  })  : assert(initialValue == null || controller == null,
            'When a controller is specified, initialValue must be null'),
        super(key: key);

  final bool? autoFocus;
  final bool? autoValidate;
  final Color? borderColor;
  final TextEditingController? controller;
  final Color? customFillColor;
  final InputDecoration? decoration;
  final bool? enabled;
  final Key? fieldKey;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? formatters;
  final Color? hintColor;
  final String? hintText;
  final Color? hintTextColor;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final bool? isSearchField;
  final bool? isSearchFieldSmall;
  final TextInputType? keyboardType;
  final String? labelText;
  final int? maxLength;
  final int? maxLines;
  final bool? obscureText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmit;
  final FormFieldSetter<String>? onSaved;
  final Function? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? textFieldBackgroundColor;
  final TextInputAction? textInputAction;
  final TextStyle? textStyle;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: fieldKey,
      enabled: enabled ?? true,
      maxLines: maxLines,
      maxLength: maxLength,
      autovalidateMode: autoValidate == true
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      initialValue: initialValue,
      decoration: decoration ??
          InputDecoration(
            filled: true,
            fillColor: (enabled != null && !enabled!)
                ? Colors.grey[200]
                : customFillColor ?? white,
            alignLabelWithHint: alignLabelWithHint(maxLines),
            contentPadding: isSearchField == true
                ? const EdgeInsets.all(20)
                : EdgeInsets.symmetric(
                    vertical: isSearchFieldSmall == true ? 10 : 15,
                    horizontal: 15),
            labelText: labelText,
            hintText: hintText,
            hintStyle: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(color: hintColor ?? grey, fontSize: 16),
            suffix: suffixIcon,
            prefixIcon: prefixIcon,
            labelStyle: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: grey, fontSize: 16),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: customFillColor ?? borderColor ?? Colors.white24),
              borderRadius: BorderRadius.all(
                  Radius.circular(isSearchField == true ? 1 : 5)),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: grey),
              borderRadius: BorderRadius.all(
                  Radius.circular(isSearchField == true ? 1 : 5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: healthcloudAccentColor),
              borderRadius: BorderRadius.all(
                  Radius.circular(isSearchField == true ? 1 : 5)),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: red),
              borderRadius: BorderRadius.all(
                  Radius.circular(isSearchField == true ? 1 : 5)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: red),
              borderRadius: BorderRadius.all(
                  Radius.circular(isSearchField == true ? 1 : 5)),
            ),
            focusColor: healthcloudAccentColor,
          ),
      cursorColor: healthcloudAccentColor,
      autofocus: autoFocus ?? false,
      style: textStyle ??
          Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: black, fontSize: 16),
      onFieldSubmitted: onFieldSubmit,
      textInputAction: textInputAction ?? TextInputAction.done,
      textAlignVertical: TextAlignVertical.center,
      validator:
          validator != null ? (String? value) => validator!(value) : null,
      onChanged: onChanged,
      onSaved: onSaved,
      onTap: onTap != null ? () => onTap!() : null,
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType ?? TextInputType.text,
      inputFormatters: inputFormatters,
    );
  }
}

/// Date picker format
const String datePickerFormat = 'dd MMM, yyyy';

/// [SILDatePickerField] customized for date selection.
/// Example
/// ```dart
///SILDatePickerField(
///   context: context,
///   allowCurrentYear: true,
///   labelText: 'Diagnosis date',
///   hintText: 'Select Diagnosis date',
///   controller: diagnosisDateController,
///   keyboardType: TextInputType.dateTime,
///   onChanged: (dynamic value) {
///     <do-something-awesome-here>
///   },
///   validator: (dynamic value) {
///   if (value.isEmpty || value == null) {
///   return 'Please select diagnosis date';
///   }
///   return null;
///   },
///   onSaved: (dynamic value) {
///     <do-something-awesome-here>
///   },
/// ),
/// ```
/// - This widget used an [AbsorbPointer] widget so as to make it easier to access
///   when doing hit testing
/// - This widget also wraps the [SILFormTextField()] widget above so that the selector
///   can also act as an input
///
///
/// The properties in this widget are the normal material date picker fields
/// with a few tweaks and customizations namely:
///   1. [allowCurrentYear] allows the date picker widget to alow dates to include
///       the current year that can be gotten from [DateTime().now.year]
///   2. [allowFutureYears] allows the date picker to accept date selection of
///       future dates
///   3. [allowEligibleDate] - allows selection of dates up to the eligible year
///      which is defined in [lib/shared/constants/date_time/date_time_constants.dart]
///
class SILDatePickerField extends StatelessWidget {
  /// To set the initial value of the field, set the text property of the
  /// [controller]. E.g:
  ///
  /// ```dart
  /// TextEditingController controller = TextEditingController();
  /// controller.text = '11 May 2012';
  ///
  /// SILDatePickerField(
  ///   controller: controller,
  /// )
  /// ```
  const SILDatePickerField({
    required this.controller,
    this.onChanged,
    this.gestureDateKey,
    this.textFieldDateKey,
    this.onSaved,
    this.labelText,
    this.hintText,
    this.focusNode,
    this.keyboardType,
    this.validator,
    this.suffixIcon,
    this.enabled,
    this.allowCurrentYear = false,
    this.allowFutureYears = false,
    this.allowEligibleDate = false,
    this.customEligibleYear,
  });

  final bool allowCurrentYear;
  final bool allowEligibleDate;
  final bool allowFutureYears;
  final TextEditingController controller;
  final bool? enabled;
  final FocusNode? focusNode;
  final Key? gestureDateKey;
  final String? hintText;
  final TextInputType? keyboardType;
  final String? labelText;
  final FormFieldSetter<String>? onChanged;
  final FormFieldSetter<String>? onSaved;
  final Icon? suffixIcon;
  final Key? textFieldDateKey;
  final FormFieldValidator<String>? validator;
  final DateTime? customEligibleYear;

  DateTime getLastDate() {
    if (allowCurrentYear && !allowFutureYears) {
      return DateTime(currentYear, currentMonth, currentDay);
    }
    if (allowFutureYears) {
      return DateTime(eligibleFutureYear);
    }
    if (allowEligibleDate) {
      return customEligibleYear ?? eligibleYear;
    }
    return DateTime(eligibleFutureYear);
  }

  // a material design date picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate;
    final TargetPlatform platform = Theme.of(context).platform;
    if (platform == TargetPlatform.iOS) {
      await showModalBottomSheet(
          context: context,
          builder: (BuildContext builder) {
            return SizedBox(
              height: MediaQuery.of(context).copyWith().size.height / 3,
              child: CupertinoDatePicker(
                initialDateTime: allowCurrentYear
                    ? DateTime(currentYear, currentMonth, currentDay)
                    : eligibleYear,
                onDateTimeChanged: (DateTime newDate) {
                  selectedDate = newDate;
                },
                minimumDate: DateTime(oldestYear, currentMonth, currentDay),
                minimumYear: oldestYear,
                maximumDate: getLastDate(),
                maximumYear: getLastDate().year,
                mode: CupertinoDatePickerMode.date,
              ),
            );
          });
    } else {
      selectedDate = await showDatePicker(
        context: context,
        initialDatePickerMode: DatePickerMode.year,
        initialDate: allowCurrentYear
            ? DateTime(currentYear, currentMonth, currentDay)
            : eligibleYear,
        firstDate: DateTime(oldestYear),
        lastDate: getLastDate(),
        builder: (BuildContext? context, Widget? child) {
          return Theme(
            data: Theme.of(context!).copyWith(
              primaryColor: healthcloudAccentColor,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: SizedBox(
                height: 700,
                width: 400,
                child: child,
              ),
            ),
          );
        },
      );
    }

    if (selectedDate != null) {
      final String date = _convertDateToString(selectedDate!);
      controller.value = controller.value.copyWith(
        text: date,
      );

      if (onChanged != null) onChanged!(date);
    }
  }

  String _convertDateToString(DateTime datePicked) {
    return DateFormat(datePickerFormat).format(datePicked);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: gestureDateKey,
      onTap: () async {
        await _selectDate(context);
      },
      child: AbsorbPointer(
        child: SILFormTextField(
          key: textFieldDateKey,
          suffixIcon: suffixIcon,
          labelText: labelText,
          hintText: hintText,
          focusNode: focusNode,
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          onSaved: onSaved,
          enabled: enabled ?? true,
        ),
      ),
    );
  }
}

/// [SILSelectOptionField] customized for selection options.
///
/// This widget can be used in dropdown buttons and select option fields
///
/// EXAMPLE:
/// ```dart
///  SILSelectOptionField(
///    hintText: 'Select gender',
///    context: context,
///    value: _selectedGender,
///    focusNode: _gender,
///    options: ['Male', 'Female', 'Unknown', 'Other'],
///    validator: (dynamic value) {
///       if (value.isEmpty || value == null) {
///       return 'Next of kin gender is required';
///       }
///      return null;
///     },
///    onChanged: (dynamic value) {},
///    onSaved: (dynamic value) {},
///  ),
/// ```
class SILSelectOptionField extends StatelessWidget {
  const SILSelectOptionField({
    this.onSaved,
    required this.options,
    this.value,
    required this.dropDownInputKey,
    this.hintText,
    this.onChanged,
    this.color,
    this.retainOptionCase = true,
    bool? disabled,
  }) : this.disabled = disabled ?? false;

  final Color? color;
  final bool disabled;
  final Key dropDownInputKey;
  final String? hintText;
  final FormFieldSetter<String>? onChanged;
  final FormFieldSetter<String>? onSaved;
  final List<String> options;

  /// whether to retain the format of the dropdown options. This will prevent
  /// options like `National ID` from being formatted to `National id`
  final bool retainOptionCase;

  final String? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: disabled ? Colors.grey[200] : white),
      child: InputDecorator(
        decoration: InputDecoration(
          fillColor: white,
          focusColor: healthcloudAccentColor,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          enabledBorder: disabled
              ? null
              : OutlineInputBorder(
                  borderSide: BorderSide(color: color ?? grey),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: healthcloudAccentColor),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[200]!),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            key: dropDownInputKey,
            dropdownColor: white,
            hint: hintText != null
                ? Text(
                    hintText!,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.grey, fontSize: 16),
                  )
                : null,
            value: value,
            items: options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                key: ValueKey<String>(value),
                value: value,
                child: Text(retainOptionCase ? value : titleCase(value)),
              );
            }).toList(),
            onChanged: disabled ? null : onChanged,
            isDense: true,
          ),
        ),
      ),
    );
  }
}

/// [SILCheckbox] customized for checkboxes
/// Example
///   ```dart
///   SILCheckbox(
///     context: context,
///     value: hasNausea,
///     text: 'Has nausea',
///     onChanged: (dynamic value) {
///       <do-something-awesome-here>
///     },
///   ),
///   ```
class SILCheckbox extends StatelessWidget {
  const SILCheckbox({
    required this.value,
    required this.text,
    required this.onChanged,
    this.onTap,
    this.child,
    this.checkboxKey,
  });

  final Key? checkboxKey;
  final Widget? child;
  final ValueChanged<bool?>? onChanged;
  final Function? onTap;
  final String? text;
  final bool? value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Checkbox(
          key: checkboxKey,
          activeColor: healthcloudAccentColor,
          materialTapTargetSize: MaterialTapTargetSize.padded,
          value: value,
          onChanged: onChanged,
        ),
        Expanded(
          child: child ??
              Text(
                text ?? '',
                style: Theme.of(context).textTheme.bodyText1,
              ),
        )
      ],
    );
  }
}

/// [SILRadio] customized for radio options
///
/// For easier readability and uniformity of the widget behavior,
/// a type **MUST** be provided
///
/// Example:
/// ```dart
///   SILRadio<bool>(
///     context: context,
///     value: true,
///     text: 'Weight Gain',
///     groupValue: 'Gain',
///     onChanged: (bool value) {
///       <do-something-awesome-here>
///     },
///   ),
/// ```
class SILRadio<T> extends StatelessWidget {
  const SILRadio({
    required this.value,
    required this.text,
    required this.onChanged,
    required this.groupValue,
    this.radioButtonKey,
    this.rightAligned = false,
    this.radioContainerKey,
  });

  /// The currently selected value for a group of radio buttons.
  ///
  /// This radio button is considered selected if its [value] matches the
  /// [groupValue].
  final T? groupValue;

  /// Called when the user selects this radio button.
  ///
  /// The radio button passes [value] as a parameter to this callback. The radio
  /// button does not actually change state until the parent widget rebuilds the
  /// radio button with the new [groupValue].
  ///
  /// If null, the radio button will be displayed as disabled.
  ///
  /// The provided callback will not be invoked if this radio button is already
  /// selected.
  final ValueChanged<T?>? onChanged;

  /// The key that will be assigned to the radio button
  ///
  /// This will be useful in interactions when testing
  final Key? radioButtonKey;

  /// The key of the encompassing Row widget
  final Key? radioContainerKey;

  /// Whether to align the radio button to the right
  ///
  /// If true, the widget will place the text before the [Radio] button
  ///
  /// If false, it will place the [Radio] button before the text
  final bool rightAligned;

  final String? text;

  /// The value represented by this radio button.
  final T value;

  @override
  Widget build(BuildContext context) {
    MainAxisAlignment alignment = MainAxisAlignment.start;
    if (rightAligned) {
      alignment = MainAxisAlignment.spaceBetween;
    }
    final Widget textWidget = Text(
      text!,
      style: TextThemes.boldSize14Text(Colors.black54),
    );

    return Row(
      key: radioContainerKey,
      mainAxisAlignment: alignment,
      children: <Widget>[
        if (rightAligned) textWidget,
        Radio<T>(
          key: radioButtonKey,
          groupValue: groupValue,
          activeColor: Theme.of(context).primaryColor,
          materialTapTargetSize: MaterialTapTargetSize.padded,
          value: value,
          onChanged: onChanged,
        ),
        if (!rightAligned) textWidget
      ],
    );
  }
}

// ignore: prefer_function_declarations_over_variables
PinBoxDecoration customRoundedPinBoxDecoration = (
  Color borderColor,
  Color pinBoxColor, {
  double borderWidth = 1.0,
  double? radius,
}) {
  return BoxDecoration(
      border: Border.all(
        color: borderColor,
        width: borderWidth,
      ),
      color: pinBoxColor,
      borderRadius: const BorderRadius.all(Radius.circular(8)));
};

class SILPinCodeTextField extends StatelessWidget {
  const SILPinCodeTextField({
    Key? key,
    required this.maxLength,
    required this.onDone,
    this.onTextChanged,
    this.autoFocus = false,
    this.wrapAlignment = WrapAlignment.spaceBetween,
    this.pinBoxHeight = 50.0,
    this.pinBoxWidth = 50.0,
    this.controller,
    this.keyboardType = TextInputType.number,
    this.focusNode,
  }) : super(key: key);

  final bool? autoFocus;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final int? maxLength;
  final Function onDone;
  final Function? onTextChanged;
  final double? pinBoxHeight;
  final double? pinBoxWidth;
  final WrapAlignment? wrapAlignment;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
        controller: controller,
        autofocus: autoFocus!,
        hideCharacter: true,
        highlight: true,
        focusNode: focusNode,
        highlightColor: Colors.blue,
        defaultBorderColor: Theme.of(context).primaryColor,
        hasTextBorderColor: Theme.of(context).accentColor,
        maxLength: maxLength ?? 4,
        maskCharacter: '⚫',
        pinBoxWidth: pinBoxWidth!,
        pinBoxHeight: pinBoxHeight!,
        wrapAlignment: wrapAlignment!,
        pinBoxDecoration: customRoundedPinBoxDecoration,
        pinTextStyle: const TextStyle(fontSize: 10.0),
        pinTextAnimatedSwitcherTransition:
            ProvidedPinBoxTextAnimation.scalingTransition,
        pinBoxColor: Theme.of(context).backgroundColor,
        pinTextAnimatedSwitcherDuration: const Duration(milliseconds: 300),
        //highlightAnimation: true,
        highlightAnimationBeginColor: Colors.black,
        highlightAnimationEndColor: Colors.white12,
        keyboardType: keyboardType,
        onDone: (String val) {
          onDone(val);
        },
        onTextChanged: (String val) =>
            (onTextChanged == null) ? <dynamic>{} : onTextChanged!(val));
  }
}
