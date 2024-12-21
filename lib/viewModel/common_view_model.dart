import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../global/global_var.dart';

class CommonViewModel{
  getCurrentLocation() async {
    Position cPosition = await Geolocator.getCurrentPosition();
    position = cPosition;
    placeMark = await placemarkFromCoordinates (cPosition.latitude, cPosition.longitude);
    Placemark placeMarkVar = placeMark![0];
    fullAddress = "${placeMarkVar.subThoroughfare} ${placeMarkVar.thoroughfare}, ${placeMarkVar.subLocality} ${placeMarkVar.locality}, ${placeMarkVar.subAdministrativeArea} ${placeMarkVar.administrativeArea} ${placeMarkVar.postalCode}";
     return fullAddress;
  }

  showSnackBar(String message, BuildContext context){
    final snackBar = SnackBar
      (content: Center(child: Text(message, style: const TextStyle(color: Colors.white),)),
      backgroundColor: Colors.black,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  updateLocationInDatabase() async{
    String address = await getCurrentLocation();
    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "address": address,
      "latitude":position?.latitude,
      "longitude": position?.longitude,
    });
  }
  pickImageFromGallery() async {
    imageFile = await pickerImage.pickImage(source: ImageSource.gallery);
  }
  captureImageWithPhoneCamera() async{
    imageFile = await pickerImage.pickImage(source: ImageSource.camera);
  }

  showDialogWithImageOptions(BuildContext context) async{
     return showDialog(
         context: context,
         builder: (context){
           return SimpleDialog(
             title: const Text(
               "Choose Option",
               style: TextStyle(
                 color: Colors.black87,
                 fontWeight: FontWeight.bold,
               ),
             ),
             children: [
               SimpleDialogOption(
                 onPressed: () async
                 {
                   await captureImageWithPhoneCamera();
                   Navigator.pop(context, "Selected");
                 },
                 child: const Text(
                   "Capture With Camera",
                   style: TextStyle(color: Colors.grey),
                 ),
               ),
               SimpleDialogOption(
                 onPressed: () async
                 {
                    await pickImageFromGallery();
                    Navigator.pop(context,"Selected");
                 },
                 child: const Text(
                   "Pick From Gallery",
                   style: TextStyle(color: Colors.grey),
                 ),
               ),
               SimpleDialogOption(
                 onPressed: ()
                 {
                   Navigator.pop(context);
                 },
                 child: const Text(
                   "Cancel",
                   style: TextStyle(color: Colors.grey),
                 ),
               )
             ],
           );
         }
     );
  }

  retrieveSellersEarnings() async {
    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .get().then((snap){
             sellersTotalEarnings= double.parse(snap.data()!["earnings"].toString());
    });
  }
}