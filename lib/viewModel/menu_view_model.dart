import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sellers/global/global_var.dart';

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
}