class MyDetails {
  int myDetailsId = 0;
  String myBillingName;
  String myBillingAddress;
  String myAdditionalInfo;
  int myExpectedPaymentPeriod;
  String myPaymentDetails;
  int gstRequired;
  String myMobile;
  String myEmail;
  double myTaxRate;
  int nextInvoiceNumber;

  MyDetails({
    this.myBillingName,
    this.myBillingAddress,
    this.myAdditionalInfo,
    this.myExpectedPaymentPeriod,
    this.myPaymentDetails,
    this.gstRequired,
    this.myMobile,
    this.myEmail,
    this.myTaxRate,
    this.nextInvoiceNumber,
  });

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['my_table_id'] = 1;
    map['my_billing_name'] = myBillingName;
    map['my_billing_address'] = myBillingAddress;
    map['my_additional_info'] = myAdditionalInfo;
    map['my_expected_payment_period'] = myExpectedPaymentPeriod;
    map['my_payment_details'] = myPaymentDetails;
    map['gst_required'] = gstRequired;
    map['my_mobile'] = myMobile;
    map['my_email'] = myEmail;
    map['my_tax_rate'] = myTaxRate;
    map['next_invoice_number'] = nextInvoiceNumber;
    return map;
  }

  factory MyDetails.fromMap(Map<String, dynamic> map) {
    return MyDetails(
      myBillingName: map['my_billing_name'],
      myBillingAddress: map['my_billing_address'],
      myAdditionalInfo: map['my_additional_info'],
      myExpectedPaymentPeriod: map['my_expected_payment_period'],
      myPaymentDetails: map['my_payment_details'],
      gstRequired: map['gst_required'],
      myMobile: map['my_mobile'],
      myEmail: map['my_email'],
      myTaxRate: map['my_tax_rate'],
      nextInvoiceNumber: map['next_invoice_number'],
    );
  }
}
