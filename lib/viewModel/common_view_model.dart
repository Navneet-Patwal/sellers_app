import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../global/global_var.dart';

class CommonViewModel{
  getMyCurrentLocation() async
  {
    Position cPosition = await Geolocator.getCurrentPosition();
    position = cPosition;
    placemark = await placemarkFromCoordinates(cPosition.latitude, cPosition.longitude);
    Placemark placemarkvar = placemark![0];
    fullAddress = "${placemarkvar.subThoroughfare} ${placemarkvar.thoroughfare}, ${placemarkvar.subLocality} ${placemarkvar.locality},${placemarkvar.subAdministrativeArea}, ${placemarkvar.administrativeArea} ${placemarkvar.postalCode}, ${placemarkvar.country},";
    return fullAddress;
  }

  showSnackBar(String message, BuildContext context){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}