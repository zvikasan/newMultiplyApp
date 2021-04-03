class BackupReminder {
  DateTime lastNotifiedDate;
  int notificationPeriod;

  BackupReminder({this.lastNotifiedDate, this.notificationPeriod});

  // notificationPeriod is integer that means:
  // 0 - notifications off
  // 1 - daily notifications
  // 2 - weekly notifications
  // 3 - monthly notifications

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['my_table_id'] = 1;
    map['last_notified_date'] = lastNotifiedDate.toIso8601String();
    map['notification_period'] = notificationPeriod;
    return map;
  }

  factory BackupReminder.fromMap(Map<String, dynamic> map) {
    DateTime _lastNotifiedDate;
    _lastNotifiedDate = DateTime.parse(map['last_notified_date']);

    return BackupReminder(
      lastNotifiedDate: _lastNotifiedDate,
      notificationPeriod: map['notification_period'],
    );
  }
}
