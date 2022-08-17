import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

class LocationServices {
  late Location _location;
  bool _servicesEnable = false;
  PermissionStatus? _grantedPermission;
  LocationServices() {
    _location = Location();
  }

  Future<bool> havePermmision() async {
    if (await haveServices()) {
      _grantedPermission = await _location.hasPermission();
      if (_grantedPermission != PermissionStatus.granted) {
        _grantedPermission = await _location.requestPermission();
      }
    }

    return _grantedPermission == PermissionStatus.granted;
  }

  Future<bool> haveServices() async {
    try {
      _servicesEnable = await _location.serviceEnabled();
      if (!_servicesEnable) {
        _servicesEnable = await _location.requestService();
      }
    } on PlatformException catch (e) {
      debugPrint('erro type ${e.code} message ${e.message}');
      _servicesEnable = false;
      await haveServices();
    }

    return _servicesEnable;
  }

  Future<LocationData?> getLoaction() async {
    if (await havePermmision()) {
      final loactionData = _location.getLocation();
      return loactionData;
    }
    return null;
  }
}
