import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sellers/global/global_var.dart';

class OrdersViewModel{

  getNewOrders()
  {
    return FirebaseFirestore.instance
        .collection("orders")
        .where("status", isEqualTo: "normal")
        .where("sellersUid", isEqualTo: sharedPreferences!.getString("uid"))
        .snapshots();
  }


  separateOrderItemIdsForOrders(orderIds){

    List<String> separateItemIDsList = [], defaultItemList = [];
    int i = 0;

    defaultItemList =List<String>.from(orderIds);

    for(i;i<defaultItemList.length;i++){
      String item = defaultItemList[i].toString();
      var pos = item.lastIndexOf(":");


      String getItemId = (pos!=-1)?item.substring(0,pos):item;
      separateItemIDsList.add(getItemId);
    }

    return separateItemIDsList;

  }



  separateOrderItemQuantity(orderIds){
    List<String> separateItemQuantityList = [], defaultItemList = [];
    int i = 1;

    defaultItemList =List<String>.from(orderIds);

    for(i;i<defaultItemList.length;i++){
      String item = defaultItemList[i].toString();
      List<String> listItemCharacters = item.split(":").toList();

      var quanNumber = int.parse(listItemCharacters[1].toString());

      separateItemQuantityList.add(quanNumber.toString());

    }
    return separateItemQuantityList;
  }

  getSpecificOrderDetails(String orderId){

    return  FirebaseFirestore.instance
        .collection("orders")
        .doc(orderId)
        .get();

  }

  getShipmentAddress(String addressId, orderByUser){

    return  FirebaseFirestore.instance
        .collection("users")
        .doc(orderByUser)
        .collection("userAddress")
        .doc(addressId)
        .get();

  }


  retrieveOrderHistory(){
    return FirebaseFirestore.instance
        .collection("orders")
        .where("sellersUid",isEqualTo: sharedPreferences!.getString("uid"))
        .where("status", isEqualTo: "ended")
        .orderBy("orderTime", descending: true)
        .snapshots();
  }

}