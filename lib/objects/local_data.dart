class LocalData {
  late String uid;
  late String action;
  late String date;
  late String time;
  static const String _divider = ',';

  LocalData(
      {required this.uid,
      required this.action,
      required this.date,
      required this.time});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'action': action,
      'date': date,
      'time': time,
    };
  }

  factory LocalData.fromString(String str) {
    return LocalData(
      uid: str.split(_divider)[0],
      action: str.split(_divider)[1],
      date: str.split(_divider)[2],
      time: str.split(_divider)[3],
    );
  }

  @override
  String toString() {
    return '$uid$_divider$action$_divider$date$_divider$time';
  }
}
