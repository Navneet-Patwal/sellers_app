import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sellers/global/global_var.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;


import '../global/global_ins.dart';

class MenuViewModel{



  getCategories() async{
    await FirebaseFirestore.instance.
    collection("categories")
        .get().then((QuerySnapshot dataSnapshot){
          dataSnapshot.docs.forEach((doc)
          {
            categoryList.add(doc["name"]);
          });
    });
  }

  validateMenuUploadForm(infoText, titleText, context) async {

    if(imageFile != null){
      if( infoText.isNotEmpty && titleText.isNotEmpty ){
        commonViewModel.showSnackBar("Uploading image please wait...", context);
        String uniqueFileID = DateTime.now().millisecondsSinceEpoch.toString();
        // String downloadUrl = await uploadImageToStorage(uniqueFileId);
        String downloadUrl = "https://images.unsplash.com/photo-1725610147161-5caa05b3b156?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
        await saveMenuInfoToDatabase(infoText, titleText, downloadUrl,uniqueFileID, context);
      } else{
        commonViewModel.showSnackBar("Please fill all the fields.", context);
      }
    }
    else{
      commonViewModel.showSnackBar("Please select menu image.", context);
    }
  }

  uploadImageToStorage(uniqueFileID) async {

    fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref().child("menus");

    fStorage.UploadTask uploadTask = reference.child(uniqueFileID + ".jpg").putFile(File(imageFile!.path));

    fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete((){});
     String downloadUrl =  await taskSnapshot.ref.getDownloadURL();
     return downloadUrl;
  }

  saveMenuInfoToDatabase(infoText,titleText, downloadUrl,uniqueFileID,context) async {

    final reference = FirebaseFirestore.instance.collection("sellers").doc(sharedPreferences!.getString("uid"))
    .collection("menus");

    await reference.doc(uniqueFileID).set({
      "menuId":uniqueFileID,
      "sellersUid": sharedPreferences!.getString("uid"),
      "sellersName": sharedPreferences!.getString("name"),
      "menuInfo": infoText,
      "menuTitle": titleText,
      "menuImage":downloadUrl,
      "publishedDateTime": DateTime.now(),
      "status":"available",

    });
     commonViewModel.showSnackBar("Uploaded Successfully!", context);
  }

  retrieveMenus(){
    return FirebaseFirestore.instance.collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus").orderBy("publishedDateTime", descending: true)
        .snapshots();
  }

  deleteMenu(menuId,context) async {
    try {
      CollectionReference collection = FirebaseFirestore.instance.collection('menus');
      await collection.doc(menuId).delete();
      await FirebaseFirestore.instance.collection("sellers").doc(sharedPreferences!.getString("uid"))
      .collection('menus').doc(menuId).delete();
      commonViewModel.showSnackBar("Menu deleted successfully", context);
    } catch (e) {
      commonViewModel.showSnackBar("Error in deleting menu.", context);
    }
  }

}