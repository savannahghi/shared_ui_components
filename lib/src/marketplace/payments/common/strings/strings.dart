/// confirm phone number strings
const String mpesaPayment = 'MPESA payment';
const String changeNumber = 'Use this or add a different number to pay with';
const String phoneNumberLabel = 'Phone Number';
const String phoneNumberValidationMsg = 'Please enter a valid phone number';
List<String> receiveSTKPush(String phoneNo, String amount) => <String>[
      'You will receive a prompt on mobile number ',
      phoneNo,
      '. Enter your ',
      'MPESA ',
      'service PIN to pay ',
      'KES $amount ',
      'to Be.Well 101002',
    ];

List<String> waitForSTKPush(String phoneNo, String amount) => <String>[
      'Wait for a prompt on mobile number ',
      phoneNo,
      ' to enter your ',
      'MPESA ',
      'service PIN for your payment of ',
      'KES $amount ',
      'to Be.Well 101002',
    ];

const String didNotReceivePrompt = 'Did not receive prompt';

/// pay with Mpesa manual instructions

const String instructionsHeading = 'Follow the instructions below to pay:';
const String goToMpesa = '1.  Go to MPESA on your phone';
const String lipaNaMpesa = '2.  Select “Lipa na MPESA”';
const String selectPaybillOption = '3. Select the “Paybill” option';
String accountNo(String phoneNo) => '4. Enter $phoneNo as your account number';
const String businessNo = '5. Enter 101002 as business number';
String amount(String amount) => '6. Enter $amount as amount';
const String mpesaPin = '7. Enter your MPESA PIN';
const String nextStep = 'Tap next after making the payment successfully';

/// confirm payments

const String confirmingPayment = 'Confirming payment';
const String confirmingPaymentInstructions =
    'Give us a moment as we confrim your payment, this could take a minute';
const String paymentConfirmationFailed = 'Confirmation failed';
const String paymentConfirmationFailedInstructions =
    'We could not verify your payment. Please make sure you have made the payment.';

const String checkAgainText = 'Check Again';
const String getHelpText = 'Get Help';
const String refreshText = 'Refresh';

const String holdOnText = 'Hold on';
const String goHome = 'Go Home';
const String holdOnInstructions =
    'We are looking into your issue and we will sort you out shortly';

const String paymentSuccessful = 'Payment successful';
const String paymentSuccessfulInstructions =
    'You have successfully paid your first payment, just a few more steps before your health insurance goes live';

const String insufficientAmount = 'Insufficient Amount';
const String insufficientAmountInstructions =
    'You have paid an insufficient amount for your cover. Pay the remaining amount to proceed';

const String payNow = 'Pay now';

const String expectedAmount = 'Expected amount';
const String amountPaid = 'Amount you have paid';
const String remainingAmount = 'Remaining amount';
const String summary = 'Summary';

const String changePaymentMethod = 'Change payment method';
const String choosePaymentMethod = 'Choose a payment method';

const String receiveInstructionsTitle =
    'How would you like to receive the instructions?';
const String viaWhatsApp = 'via WhatsApp';
const String viaText = 'via Text Message';

const String getHelp = 'Get help from our support center';
const String selectIssue = 'Select the issue you are having below';
const String unableToPay = 'Am unable to pay';
const String paymentNotConfirmed = 'Payment not confirmed';
const String other = 'Other';
const String issueLable = 'Description(optional)';

const String bankTransfer = 'Bank Transfer';

const String pesaLinkTitle = 'Pay via PesaLink';
const String pesaLinkDesc =
    'Send money from your Kenyan bank account using PesaLink';

const String rtgsTitle = 'Pay via RTGS';
const String rtgsDesc = 'Send money from your bank to our Equity bank account';

const String equitelTitle = 'Pay via Equitel';
const String equitelDesc = 'Send money from equitel account';

const String swiftTitle = 'International money transfer';
const String swiftDesc = 'Send money from your international bank account';

const String sendInstructionsText = 'Send me instructions';

const String totalAmount = 'Amount';
const String accountName = 'Account name';
const String accountNumber = 'Account number';
const String referenceNo = 'Reference Number';
const String phoneNo = 'Phone number';
const String email = 'Email';
const String swift = 'Swift';
const String address = 'Address';
const String copy = ' Copy';
const String continueText = 'Continue';
const String checkPayment =
    'Once you have made the payment, tap on the button below to continue';
const String copiedToClipBoard = ' copied to clipboard';
const String refDescription = 'Enter this as the reason for payment';

/// PesaLink instructions
const List<String> pesaLinkInstructions = <String>[
  '1. Select PesaLink on your Bank’s menu.',
  '2. Select "Send To Account" on the PesaLink menu option.',
  '3. Confirm the details displayed on the page before sending.',
  '4. Once you have made the payment, verify your payment below.'
];

/// Equitel instructions
const List<String> equitelInstructions = <String>[
  '1. Go to your Equitel menu',
  '2. Select My Money',
  '3. Select Send /Pay',
  '4. Select Account, Others then Other Banks',
  '5. Select Lookup Bank Codes then enter the first letter or keyword of the other bank',
  '6. Enter the following details as prompted',
  '7. Confirm the details and enter your PIN',
  '8. You will receive a confirmation SMS'
];

// swift instructions
const String swiftRTGSInstruction =
    'Use your internet/app banking or go to your bank and use the details below to pay';
