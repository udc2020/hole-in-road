import 'package:flutter/foundation.dart';

class ImagProvider extends ChangeNotifier {
  String img;

  ImagProvider({this.img = ''});

  void addImag(String newimg) {
    img = newimg;
    notifyListeners();
  }
}
