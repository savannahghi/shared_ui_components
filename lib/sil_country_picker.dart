import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sil_ui_components/utils/constants.dart';
import 'package:sil_ui_components/utils/helpers.dart';

Map<String, String>? getCountry(Country country) {
  switch (country) {
    case Country.kenya:
      return supportedCountries['kenya'];
    case Country.uganda:
      return supportedCountries['uganda'];
    case Country.tanzania:
      return supportedCountries['tanzania'];
    default:
      return supportedCountries['usa'];
  }
}

class SilCountryPicker extends StatefulWidget {
  @override
  _SilCountryPickerState createState() => _SilCountryPickerState();
}

class _SilCountryPickerState extends State<SilCountryPicker> {
  Country _country = Country.kenya;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final dynamic _result = await _selectCountryModalBottomSheet(context);
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

dynamic _selectCountryModalBottomSheet(BuildContext context) {
  return showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SizedBox(
          child: Wrap(
            children: <Widget>[
              for (Map<String, String> country in supportedCountries.values)
                ListTile(
                  leading: Image.asset(country['flag']!),
                  title: Text(country['name']!),
                  onTap: () {
                    Navigator.of(context).pop(popValue(country['name']!));
                  },
                ),
            ],
          ),
        );
      });
}
