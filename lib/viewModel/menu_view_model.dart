import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:sellers/global/global_var.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import '../global/global_ins.dart';
import 'package:http/http.dart' as http;

class MenuViewModel {
  getCategories() async {
    categoryList.clear();
    await FirebaseFirestore.instance.
    collection("categories")
        .get().then((QuerySnapshot dataSnapshot) {
      for (var doc in dataSnapshot.docs) {
        categoryList.add(doc["name"]);
      }
    });
  }

  validateMenuUploadForm(infoText, titleText, context) async {
    if (imageFile != null) {
      if (infoText.isNotEmpty && titleText.isNotEmpty) {
        commonViewModel.showSnackBar("Uploading image please wait...", context);
        String uniqueFileID = DateTime
            .now()
            .millisecondsSinceEpoch
            .toString();
        String downloadUrl = await uploadImageToStorage(uniqueFileID);
        // String downloadUrl = "https://images.unsplash.com/photo-1725610147161-5caa05b3b156?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
        await saveMenuInfoToDatabase(
            infoText, titleText, downloadUrl, uniqueFileID, context);
      } else {
        commonViewModel.showSnackBar("Please fill all the fields.", context);
      }
    }
    else {
      commonViewModel.showSnackBar("Please select menu image.", context);
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

    request.fields['upload_preset'] = "menus_upload";
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


  saveMenuInfoToDatabase(infoText, titleText, downloadUrl, uniqueFileID,
      context) async {
    final reference = FirebaseFirestore.instance.collection("sellers").doc(
        sharedPreferences!.getString("uid"))
        .collection("menus");

    await reference.doc(uniqueFileID).set({
      "menuId": uniqueFileID,
      "sellersUid": sharedPreferences!.getString("uid"),
      "sellersName": sharedPreferences!.getString("name"),
      "menuInfo": infoText,
      "menuTitle": titleText,
      "menuImage": downloadUrl,
      "publishedDateTime": DateTime.now(),
      "status": "available",

    });
    commonViewModel.showSnackBar("Uploaded Successfully!", context);
  }

  retrieveMenus() {
    return FirebaseFirestore.instance.collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus").orderBy("publishedDateTime", descending: true)
        .snapshots();
  }

  deleteMenu(menuId, context) async {
    try {
      CollectionReference collection = FirebaseFirestore.instance.collection(
          'menus');
      await collection.doc(menuId).delete();
      await FirebaseFirestore.instance.collection("sellers").doc(
          sharedPreferences!.getString("uid"))
          .collection('menus').doc(menuId).delete();
    } catch (e) {
      commonViewModel.showSnackBar("Error in deleting menu.", context);
    }
  }

  updateMenuInfo(menuTitle, menuCategory, menuId, context) async {
    try {
      String downloadUrl = "https://images.unsplash.com/photo-1619566636858-adf3ef46400b?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
      await FirebaseFirestore.instance.collection("sellers").doc(
          sharedPreferences!.getString("uid"))
          .collection("menus").doc(menuId).update({
        "menuInfo": menuTitle,
        "menuTitle": menuCategory,
        "menuImage": downloadUrl,
      });
      await FirebaseFirestore.instance
          .collection("menus").doc(menuId).update({
        "menuInfo": menuTitle,
        "menuTitle": menuCategory,
        "menuImage": downloadUrl,
      });
      commonViewModel.showSnackBar("Menu updated", context);
    } catch (e) {
      commonViewModel.showSnackBar(e.toString(), context);
    }
  }

}