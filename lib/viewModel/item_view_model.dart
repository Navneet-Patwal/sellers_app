import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../global/global_ins.dart';
import '../global/global_var.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import '../model/menu.dart';



class ItemViewModel {
  validateItemUploadForm(infoText, titleText, descText, priceText,Menu menuModel, context) async {
    if(imageFile != null){
      if( infoText.isNotEmpty && titleText.isNotEmpty && descText.isNotEmpty && priceText.isNotEmpty ){
        commonViewModel.showSnackBar("Uploading image please wait...", context);
        String uniqueFileID = DateTime.now().millisecondsSinceEpoch.toString();
        // String downloadUrl = await uploadImageToStorage(uniqueFileID);
        String downloadUrl = "https://images.unsplash.com/photo-1725610147161-5caa05b3b156?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
        await saveItemInfoToDatabase(infoText, titleText,descText,priceText, downloadUrl, menuModel,uniqueFileID, context);
      } else{
        commonViewModel.showSnackBar("Please fill all the fields.", context);
      }
    }
    else{
      commonViewModel.showSnackBar("Please select Item image.", context);
    }
  }


  uploadImageToStorage(uniqueFileID) async {

    fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref().child("itemImages");

    fStorage.UploadTask uploadTask = reference.child(uniqueFileID + ".jpg").putFile(File(imageFile!.path));

    fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete((){});
    String downloadUrl =  await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }


  saveItemInfoToDatabase(infoText, titleText,descText,priceText, downloadUrl,Menu menuModel,uniqueFileID, context) async {


    final referenceSeller = FirebaseFirestore.instance.collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus")
        .doc(menuModel.menuId)
        .collection("items");

    final referenceMain = FirebaseFirestore.instance
        .collection("items");

    await referenceSeller.doc(uniqueFileID).set({
      "menuId":menuModel.menuId,
      "menuName" :menuModel.menuTitle,
      "itemId":uniqueFileID,
      "sellersUid": sharedPreferences!.getString("uid"),
      "sellersName": sharedPreferences!.getString("name"),
      "itemInfo": infoText,
      "itemTitle": titleText,
      "itemImage":downloadUrl,
      "description": descText,
      "price":int.parse(priceText),
      "publishedDateTime": DateTime.now(),
      "status":"available",

    }).then((value) async {

      await referenceMain.doc(uniqueFileID).set({
        "menuId": menuModel.menuId,
        "menuName": menuModel.menuTitle,
        "itemId": uniqueFileID,
        "sellersUid": sharedPreferences!.getString("uid"),
        "sellersName": sharedPreferences!.getString("name"),
        "itemInfo": infoText,
        "itemTitle": titleText,
        "itemImage": downloadUrl,
        "description": descText,
        "price": int.parse(priceText),
        "publishedDateTime": DateTime.now(),
        "status": "available",
        "isRecommended":false,
        "isPopular": false
      });

    });
    commonViewModel.showSnackBar("Uploaded Successfully!", context);


  }


  retrieveItems(menuId){
    return FirebaseFirestore.instance.collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus").doc(menuId)
        .collection("items").orderBy("publishedDateTime", descending: true)
        .snapshots();

  }

  deleteItem(itemId,menuId,context) async {
    try {
      CollectionReference collection = FirebaseFirestore.instance.collection('items');
      await collection.doc(itemId).delete();
      await FirebaseFirestore.instance.collection("sellers").doc(sharedPreferences!.getString("uid"))
          .collection('menus').doc(menuId).collection("items").doc(itemId).delete();
      commonViewModel.showSnackBar("Item deleted successfully", context);
    } catch (e) {
      commonViewModel.showSnackBar("Error in deleting menu.", context);
    }
  }

}

