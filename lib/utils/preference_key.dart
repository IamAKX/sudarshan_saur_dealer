import '../main.dart';

class SharedpreferenceKey {
  static const String userId = 'userId';

  static const String firstTimeAppOpen = 'firstTimeAppOpen';

  static const String serialNumber = 'serialNumber';
  static const String userPhone = 'userPhone';
  static const String loggedIn = 'loggedIn';
  static const String ongoingRequest = 'ongoingRequest';

  static const String newCustId = 'newCustId';
  static const String newCustSerial = 'newCustSerial';
  static const String newCustPhone = 'newCustPhone';

  static int getUserId() {
    return prefs.getInt(userId) ?? -1;
  }
}
