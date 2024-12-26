import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../global/global_ins.dart';
import '../global/global_var.dart';
import '../model/menu.dart';
import 'package:http/http.dart' as http;


class ItemViewModel {
  validateItemUploadForm(infoText, titleText, descText, priceText,Menu menuModel, context) async {
    if(imageFile != null){
      if( infoText.isNotEmpty && titleText.isNotEmpty && descText.isNotEmpty && priceText.isNotEmpty ){
        commonViewModel.showSnackBar("Uploading image please wait...", context);
        String uniqueFileID = DateTime.now().millisecondsSinceEpoch.toString();
        String downloadUrl = await uploadImageToStorage(uniqueFileID);
        //String downloadUrl = "https://images.unsplash.com/photo-1725610147161-5caa05b3b156?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
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
    String downloadUrl = "";
    File file = File(imageFile!.path);
    var uri = Uri.parse("https://api.cloudinary.com/v1_1/de2dkdxdr/raw/upload");
    var request = http.MultipartRequest("POST", uri);
    var fileBytes = await file.readAsBytes();

    var multipartFile = http.MultipartFile.fromBytes(
      'file', // The form field name for the file
      fileBytes,
      filename: file.path.split("/").last, //The file name to send in the request
    );

    // Add the file part to the request
    request.files.add(multipartFile);

    request.fields['upload_preset'] = "items_upload";
    request.fields['resource_type'] = "raw";
    var response = await request.send();

    // Get the response as text
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(responseBody);
      Map<String, String> requiredData = {
        "id": jsonResponse["public_id"],
        "size": jsonResponse["bytes"].toString(),
        "url": jsonResponse["secure_url"],
        "created_at": jsonResponse["created_at"],
      };
      downloadUrl = requiredData['url']!;
      print("Upload successful!");
    } else {
      print("Upload failed with status: ${response.statusCode}");

    }
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
    } catch (e) {
      commonViewModel.showSnackBar("Error in deleting menu.", context);
    }
  }

  updateItemInfo(infoText, titleText, descText, priceText,menuId,itemId,context) async {
    String downloadUrl = "https://images.unsplash.com/photo-1734126801303-06da3e3f2db6?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxNnx8fGVufDB8fHx8fA%3D%3D";
    try {await FirebaseFirestore.instance.collection("sellers").doc(sharedPreferences!.getString("uid"))
        .collection("menus").doc(menuId).collection("items").doc(itemId).update(
        {
          "itemInfo":infoText,
          "itemTitle": titleText,
          "description":descText,
          "price": priceText,
          "itemImage":downloadUrl,
    }
    );

    await FirebaseFirestore.instance.collection("items").doc(itemId).update(
        {
          "itemInfo":infoText,
          "itemTitle": titleText,
          "description":descText,
          "price": priceText,
          "itemImage":downloadUrl,
        });
    commonViewModel.showSnackBar("Item info update successfully.", context);

  } catch(e){
      commonViewModel.showSnackBar(e.toString(), context);
    }
  }

}

