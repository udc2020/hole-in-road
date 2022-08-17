import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  String user;

  UserProvider({this.user = ''});

  void changeUserInformation(String newUser) {
    user = newUser;
    notifyListeners();
  }
}
