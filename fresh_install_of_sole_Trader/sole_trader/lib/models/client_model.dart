class Client {
  int clientId;
  String clientNickname;
  String clientBillingName;
  String clientAddress;
  double clientHourlyRate;
  int isArchived;

  Client(
      {this.clientNickname,
      this.clientBillingName,
      this.clientHourlyRate,
      this.clientAddress,
      this.isArchived});
  Client.withId(
      {this.clientId,
      this.clientNickname,
      this.clientBillingName,
      this.clientHourlyRate,
      this.clientAddress,
      this.isArchived});

  Map<String, dynamic> toMap() {
    //converting Client object to map in order to store it into the database
    final map = Map<String, dynamic>();
    if (clientId != null) {
      map['client_id'] = clientId;
    }
    map['client_nickname'] = clientNickname;
    map['client_billing_name'] = clientBillingName;
    map['client_address'] = clientAddress;
    map['client_hourly_rate'] = clientHourlyRate;
    map['is_archived'] = isArchived;

    return map;
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    //Retrieves maps of clients from database and converts them into Client objects
    return Client.withId(
      clientId: map['client_id'],
      clientNickname: map['client_nickname'],
      clientBillingName: map['client_billing_name'],
      clientAddress: map['client_address'],
      clientHourlyRate: map['client_hourly_rate'],
      isArchived: map['is_archived'],
    );
  }
}
