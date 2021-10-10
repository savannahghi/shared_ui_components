import 'package:flutter/material.dart';
import 'package:shared_themes/text_themes.dart';
import 'package:shared_ui_components/src/marketplace/payments/common/strings/strings.dart';

class ChangePaymentMethod extends StatelessWidget {
  final String mpesaRoute;
  final String bankTransferRoute;

  const ChangePaymentMethod({
    Key? key,
    required this.mpesaRoute,
    required this.bankTransferRoute,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selectPaymentMethod(context, mpesaRoute, bankTransferRoute);
      },
      child: Text(
        changePaymentMethod,
        style: TextThemes.boldSize15Text(Colors.blue)
            .copyWith(decoration: TextDecoration.underline),
      ),
    );
  }

  void selectPaymentMethod(
      BuildContext context, String mpesaRoute, String bankTransferRoute) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Text(
                    choosePaymentMethod,
                    style: TextThemes.veryBoldSize20Text(),
                  ),
                ),
                ListTile(
                  leading: Image.asset('assets/mpesa.png',
                      package: 'shared_ui_components'),
                  trailing: const Icon(Icons.chevron_right),
                  title: Text(
                    'MPESA',
                    style: TextThemes.boldSize16Text(),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, mpesaRoute);
                  },
                ),
                ListTile(
                  leading: Image.asset('assets/bank.png',
                      package: 'shared_ui_components'),
                  trailing: const Icon(Icons.chevron_right),
                  title: Text(
                    bankTransfer,
                    style: TextThemes.boldSize16Text(),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, bankTransferRoute);
                  },
                ),
              ],
            ),
          );
        });
  }
}
