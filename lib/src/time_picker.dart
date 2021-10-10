import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_themes/colors.dart';
import 'package:shared_ui_components/src/constants.dart';
import 'package:shared_ui_components/src/inputs.dart';
import 'package:shared_ui_components/src/type_defs.dart';

/// [SILTimePicker] customized for selection time
/// Example
/// ```dart
/// SILTimePicker(
/// context: context,
/// labelText: 'At',
/// controller: startTimeController,
/// onSaved: (dynamic value) {
///     <do-something-awesome-here>
///   },
/// validator: (dynamic v) {
///   if (v.toString().isEmpty) {
///     return 'Start time is required';
///   }
///  return null;
///  },
/// onChanged: (dynamic v) {
///   <do-something-awesome-here>
/// },
/// ),
/// ```
///
///
/// The widget adds a formatted date of the form [HH:MM AM/PM]
/// to the [TextEditingController]. An example of the date is
/// `12:30 AM` or `5:30 PM`.
///
/// - The selected date is an instance of TimeOfDay. For example [TimeOfDay(20:22]
///   is formatted to become [8:22 PM]

class SILTimePicker extends StatelessWidget {
  final TextEditingController controller;
  final FormFieldCallback? onChanged;
  final FormFieldCallback? onSaved;
  final String? labelText;
  final String? hintText;
  final String? initialValue;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final FormFieldCallback? validator;
  final Icon? suffixIcon;

  const SILTimePicker({
    required this.controller,
    required this.onChanged,
    required this.onSaved,
    this.focusNode,
    this.hintText,
    this.initialValue,
    this.keyboardType,
    this.labelText,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final TimeOfDay selectedTime = TimeOfDay.now();
        selectTime(
            context: context,
            controller: controller,
            initialTime: selectedTime);
      },
      child: AbsorbPointer(
        child: SILFormTextField(
          suffixIcon: suffixIcon,
          labelText: labelText,
          hintText: hintText,
          focusNode: focusNode,
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          onSaved: onSaved,
        ),
      ),
    );
  }

  Future<void> selectTime(
      {required BuildContext context,
      required TextEditingController controller,
      required TimeOfDay initialTime}) async {
    TimeOfDay selectedTime = initialTime;
    dynamic picked;
    final TargetPlatform _platForm = Theme.of(context).platform;
    if (_platForm == TargetPlatform.iOS) {
      final DateTime minimumDateTime = DateTime(currentYear, currentMonth,
          currentDay, TimeOfDay.now().hour, TimeOfDay.now().minute);
      await showModalBottomSheet(
          context: context,
          builder: (BuildContext builder) {
            return SizedBox(
              height: MediaQuery.of(context).copyWith().size.height / 3,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: minimumDateTime,
                minimumDate: minimumDateTime,
                onDateTimeChanged: (DateTime changedTimer) {
                  picked = TimeOfDay.fromDateTime(changedTimer);
                },
              ),
            );
          });
    } else {
      picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (BuildContext? context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context!)
                  .copyWith(alwaysUse24HourFormat: false),
              child: Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: healthcloudAccentColor,
                ),
                child: child!,
              ),
            );
          });
    }
    if (picked != null && picked != selectedTime) {
      selectedTime = picked as TimeOfDay;
    }

    String _convertTimeToString(TimeOfDay time) {
      //format time to format as "6.05 PM"
      final DateTime now = DateTime.now();
      final DateTime formattedDateTime =
          DateTime(now.year, now.month, now.day, time.hour, time.minute);
      return DateFormat.jm().format(formattedDateTime);
    }

    controller.text = _convertTimeToString(selectedTime);
  }
}
