import 'package:flutter/material.dart';

enum InstructionsSender { whatsApp, text }

class BankTransferDetails {
  final String amount;
  final String accountName;
  final String accountNo;
  final String referenceNo;
  final String? phoneNo;
  final String? email;
  final String? address;
  final String? swiftCode;

  BankTransferDetails({
    required this.amount,
    required this.accountName,
    required this.accountNo,
    required this.referenceNo,
    this.phoneNo,
    this.email,
    this.address,
    this.swiftCode,
  });
}

class BankTransferManager {
  void sendInstructions(InstructionsSender sender) {
    //
  }

  static void verifyPayment(BankTransferType transferType) {
    //
  }
}

enum BankTransferType { base, pesaLink, rtgs, equitel, swift }

enum HelpType { unableToPay, paymentNotConfirmed, other, none }

class PaymentDetails {
  final String amount;
  final String phoneNo;
  String? email;

  PaymentDetails({
    required this.amount,
    required this.phoneNo,
    this.email,
  });
}

// to be mapped to theme
const Color textGreyColor = Color(0xFF455A64);
const Color textGreyColorShade2 = Color(0xFF666666);
const Color green = Color(0xFF2A9187);
const Color bordrGreyColor = Color(0xFFB5B5B5);
const Color lightGreen = Color(0xFFA3C717);
