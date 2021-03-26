import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sil_ui_components/src/constants.dart';
import 'package:sil_ui_components/src/helpers.dart';

class SILCountryPicker extends StatefulWidget {
  const SILCountryPicker({Key? key, required this.onChanged}) : super(key: key);

  final Function onChanged;

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
          widget.onChanged(getCountry(_country)!['code']);
        }
      },
      child: SizedBox(
        key: const Key('selectCountryKey'),
        height: 30,
        width: 76,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                getCountry(this._country)!['code']!,
                key: const Key('countrySelectedKey'),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Image.asset(
              getCountry(this._country)!['flag']!,
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
