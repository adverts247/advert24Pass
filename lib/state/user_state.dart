import 'package:flutter/foundation.dart';

class UserState extends ChangeNotifier {
  dynamic userDetails;
  String? size;
  String? sessionId;
  void getUserData(data) {
    userDetails = data;
    print(userDetails);
    notifyListeners();
  }
}
