import 'package:flutter/services.dart';
import 'package:location/location.dart';

class LocationService{
    late Location _location;
    bool _serviceEnabled = false;
    PermissionStatus? _permissionGranted;

  LocationService(){
    _location = Location();
  }

  Future<bool> _checkPermission() async{

    if(await _checkService()){
      _permissionGranted = await _location.hasPermission();
      if(_permissionGranted != PermissionStatus.granted){
        _permissionGranted = await _location.requestPermission();
      }
    }
    return _permissionGranted == PermissionStatus.granted;
  }

  Future<bool> _checkService() async{
    try{

      _serviceEnabled = await _location.serviceEnabled();
      if(!_serviceEnabled){
        _serviceEnabled = await _location.requestService();
      }
    } on PlatformException catch(error){
      print('error code is ${error.code} and message = ${error.message}');
      _serviceEnabled = false;
      await _checkService();
    }
    return _serviceEnabled;
  }

  Future<LocationData?> getLocation() async{
    if (await _checkPermission()){
      final locationData = _location.getLocation();
      return locationData;
    }

    return null;
  }

}