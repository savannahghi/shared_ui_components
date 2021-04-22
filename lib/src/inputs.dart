import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import 'package:sil_themes/colors.dart';
import 'package:sil_themes/text_themes.dart';
import 'package:intl/intl.dart';
import 'package:sil_ui_components/sil_country_picker.dart';
import 'package:sil_ui_components/src/helpers.dart';
import 'package:sil_ui_components/src/type_defs.dart';

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
    String? initialValue = '',
    bool autoValidate = false,
  }) : super(
          enabled: enabled ?? true,
          autovalidateMode: autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          validator: (String? value) {
            final RegExp kenyanRegExp = RegExp(r'^[0-9]{9}$');
            final RegExp usRegExp = RegExp(r'^[0-9]{10}$');

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

              if (!kenyanRegExp.hasMatch(phone) && !usRegExp.hasMatch(phone)) {
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
                                    .countryCode.valueWrapper!.value,
                                phoneNumber: phoneInputBehaviorSubject
                                    .phoneNumber.valueWrapper!.value,
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
                                        .countryCode.valueWrapper!.value,
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
  const SILFormTextField({
    Key? key,
    this.inputController,
    this.onSaved,
    this.onTap,
    this.labelText,
    this.hintText,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.onFieldSubmit,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.formatters,
    this.maxLines,
    this.maxLength,
    this.textStyle,
    this.enabled,
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
  }) : super(key: key);

  final Queue<int>? inputController;
  final FormFieldSetter<String>? onSaved;
  final Function? onTap;
  final String? labelText;
  final String? hintText;
  final String? initialValue;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmit;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? formatters;
  final int? maxLines;
  final int? maxLength;
  final TextStyle? textStyle;
  final bool? enabled;
  final Widget? suffixIcon;
  final bool? isSearchField;
  final bool? obscureText;

  final bool? autoValidate;
  final bool? isSearchFieldSmall;
  final bool? autoFocus;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final TextInputAction? textInputAction;
  final Color? customFillColor;
  final Color? hintColor;
  final Color? hintTextColor;
  final Color? borderColor;
  final Color? textFieldBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      maxLength: maxLength,
      autovalidateMode: autoValidate == true
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      initialValue: controller == null ? initialValue : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: customFillColor ?? white,
        alignLabelWithHint: alignLabelWithHint(maxLines),
        contentPadding: isSearchField == true
            ? const EdgeInsets.all(20)
            : EdgeInsets.symmetric(
                vertical: isSearchFieldSmall == true ? 10 : 15, horizontal: 15),
        labelText: labelText,
        hintText: hintText,
        suffix: suffixIcon,
        prefixIcon: prefixIcon,
        labelStyle: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(color: grey, fontSize: 16),
        hintStyle: Theme.of(context)
            .textTheme
            .headline4!
            .copyWith(color: hintColor ?? grey, fontSize: 16),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: customFillColor ?? borderColor ?? Colors.white24),
          borderRadius:
              BorderRadius.all(Radius.circular(isSearchField == true ? 1 : 5)),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: grey),
          borderRadius:
              BorderRadius.all(Radius.circular(isSearchField == true ? 1 : 5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: healthcloudAccentColor),
          borderRadius:
              BorderRadius.all(Radius.circular(isSearchField == true ? 1 : 5)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: red),
          borderRadius:
              BorderRadius.all(Radius.circular(isSearchField == true ? 1 : 5)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: red),
          borderRadius:
              BorderRadius.all(Radius.circular(isSearchField == true ? 1 : 5)),
        ),
        focusColor: healthcloudAccentColor,
      ),
      cursorColor: healthcloudAccentColor,
      autofocus: autoFocus ?? false,
      enabled: enabled ?? true,
      style: textStyle ??
          Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: black, fontSize: 16),
      onFieldSubmitted: onFieldSubmit != null
          ? (String value) => onFieldSubmit!(value)
          : null,
      textInputAction: textInputAction ?? TextInputAction.done,
      textAlignVertical: TextAlignVertical.center,
      validator:
          validator != null ? (String? value) => validator!(value) : null,
      onChanged: onChanged != null ? (String value) => onChanged!(value) : null,
      onTap: onTap != null ? () => onTap!() : null,
      controller: initialValue == null ? controller : null,
      focusNode: focusNode,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType ?? TextInputType.text,
      inputFormatters: inputFormatters,
    );
  }
}

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
  const SILDatePickerField({
    required this.controller,
    this.gestureDateKey,
    this.textFieldDateKey,
    this.onSaved,
    this.labelText,
    this.hintText,
    this.initialValue,
    this.focusNode,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.suffixIcon,
    this.enabled,
    this.allowCurrentYear = false,
    this.allowFutureYears = false,
    this.allowEligibleDate = false,
  });

  final TextEditingController controller;
  final Key? gestureDateKey;
  final Key? textFieldDateKey;
  final FormFieldSetter<String>? onSaved;
  final String? labelText;
  final String? hintText;
  final String? initialValue;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onChanged;
  final bool allowCurrentYear;
  final bool allowFutureYears;
  final bool allowEligibleDate;
  final Icon? suffixIcon;
  final bool? enabled;

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

  DateTime getLastDate() {
    if (allowCurrentYear && !allowFutureYears) {
      return DateTime(currentYear, currentMonth, currentDay);
    }
    if (allowFutureYears) {
      return DateTime(eligibleFutureYear);
    }
    if (allowEligibleDate) {
      return eligibleYear;
    }
    return DateTime(eligibleFutureYear);
  }

  // a material design date picker
  Future<void> _selectDate(BuildContext context) async {
    dynamic selectedDate;
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
                minimumDate: allowCurrentYear
                    ? DateTime(currentYear, currentMonth, currentDay)
                    : DateTime(oldestYear, currentMonth, currentDay),
                minimumYear: allowCurrentYear ? currentYear : oldestYear,
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
        firstDate: allowCurrentYear
            ? DateTime(currentYear, currentMonth, currentDay)
            : DateTime(oldestYear),
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

    if (selectedDate == null) return;

    final String date = _convertDateToString(selectedDate as DateTime);

    controller.value = controller.value.copyWith(
      text: date,
    );

    onChanged!(date);
  }

  String _convertDateToString(DateTime datePicked) {
    return DateFormat('yyyy-MM-dd').format(datePicked);
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
  final Key dropDownInputKey;
  final FormFieldSetter<String>? onSaved;
  final List<String> options;
  final String hintText;
  final Color? color;
  final String value;
  final bool disabled;
  final FormFieldSetter<String>? onChanged;

  const SILSelectOptionField({
    required this.onSaved,
    required this.options,
    required this.value,
    required this.dropDownInputKey,
    required this.hintText,
    required this.onChanged,
    this.color,
    bool? disabled,
  }) : this.disabled = disabled ?? false;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: color ?? grey),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: healthcloudAccentColor),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        focusColor: healthcloudAccentColor,
        fillColor: white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          key: dropDownInputKey,
          dropdownColor: white,
          hint: Text(
            hintText,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Colors.grey, fontSize: 16),
          ),
          value: value,
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              key: ValueKey<String>(value),
              value: value,
              child: Text(titleCase(value)),
            );
          }).toList(),
          onChanged: disabled != true
              ? (dynamic value) {
                  if (onChanged != null) {
                    onChanged!(value.toString());
                  }
                }
              : null,
          isDense: true,
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

  final bool? value;
  final String? text;
  final ValueChanged<bool?>? onChanged;
  final Function? onTap;
  final Key? checkboxKey;
  final Widget? child;

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
/// Example:
/// ```dart
///   SILRadio(
///     context: context,
///     value: dataPayload['Section'][4]['Text']['Div'] =='1'? 'Gain': 'Loss',
///     text: 'Weight Gain',
///     groupValue: 'Gain',
///     onChanged: (dynamic v) {
///       <do-something-awesome-here>
///     },
///   ),
/// ```
class SILRadio extends StatelessWidget {
  const SILRadio({
    required this.value,
    required this.text,
    required this.onChanged,
    required this.groupValue,
    this.radioKey,
    this.rightAligned = false,
  });

  final dynamic? value;
  final String? text;
  final ValueChanged<dynamic?>? onChanged;
  final dynamic groupValue;
  final bool rightAligned;
  final Key? radioKey;

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
      key: radioKey,
      mainAxisAlignment: alignment,
      children: <Widget>[
        if (rightAligned) textWidget,
        Radio<dynamic>(
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
  final int? maxLength;
  final Function onTextChanged;
  final Function onDone;
  final double? pinBoxWidth;
  final double? pinBoxHeight;
  final bool? autoFocus;
  final WrapAlignment? wrapAlignment;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final FocusNode? focusNode;

  const SILPinCodeTextField({
    Key? key,
    required this.maxLength,
    required this.onTextChanged,
    required this.onDone,
    this.autoFocus = false,
    this.wrapAlignment = WrapAlignment.spaceBetween,
    this.pinBoxHeight = 50.0,
    this.pinBoxWidth = 50.0,
    this.controller,
    this.keyboardType = TextInputType.number,
    this.focusNode,
  }) : super(key: key);

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
      onTextChanged: (String val) {
        onTextChanged(val);
      },
      onDone: (String val) {
        onDone(val);
      },
    );
  }
}
