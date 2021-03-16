import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sil_ui_components/src/constants.dart';
import 'package:sil_ui_components/src/helpers.dart';

class SILCountryPicker extends StatefulWidget {
  @override
  _SILCountryPickerState createState() => _SILCountryPickerState();
}

class _SILCountryPickerState extends State<SILCountryPicker> {
  Country _country = Country.kenya;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final dynamic _result = await selectCountryModalBottomSheet(context);
        if (_result != null) {
          setState(() {
            _country = _result as Country;
          });
        }
      },
      child: SizedBox(
        width: 100,
        height: 30,
        child: Row(
          children: <Widget>[
            Text(getCountry(_country)!['initial']!),
          ],
        ),
      ),
    );
  }
}
