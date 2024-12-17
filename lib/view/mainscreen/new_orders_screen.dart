import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sellers/global/global_ins.dart';
import 'package:sellers/view/widgets/my_appbar.dart';
import 'package:sellers/view/widgets/order_card_ui_design.dart';

class NewOrdersScreen extends StatefulWidget {
  const NewOrdersScreen({super.key});

  @override
  State<NewOrdersScreen> createState() => _NewOrdersScreenState();
}

class _NewOrdersScreenState extends State<NewOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(titleMsg: "New orders", showBackButton: true),
      body: StreamBuilder<QuerySnapshot>(
          stream:ordersViewModel.getNewOrders(),
          builder: (c, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.black,)); // Show loading indicator
            }

            // Check for errors
            if (snapshot.hasError) {
              return const Center(child: Text("Error loading orders"));
            }

            // Check if there is no data
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No new orders", style: TextStyle(color: Colors.black, fontSize:25),));
            }
            return
            ListView.builder(
              itemCount: snapshot.data!.docs.length,
                itemBuilder: (c, index){
                return FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("items")
                      .where("itemId", whereIn: ordersViewModel.separateOrderItemIdsForOrders((snapshot.data!.docs[index].data()! as Map<String, dynamic>)["productIds"]))
                      .where("sellersUid", whereIn: (snapshot.data!.docs[index].data()! as Map<String, dynamic>)["uid"])
                      .orderBy("publishedDateTime",descending:true)
                      .get(),
                  builder: (c, snap){
                    return snap.hasData? Card(
                      elevation: 6,
                        color: Colors.black87,
                      child: OrderCardUiDesign(
                        itemCount: snap.data!.docs.length,
                        data:snap.data!.docs,
                        orderId: snapshot.data!.docs[index].id,
                        separateQuantityList: ordersViewModel.separateOrderItemQuantity((snapshot.data!.docs[index].data()! as Map<String, dynamic>)["productIds"]),
                      )
                    ):
                        const Center(child: CircularProgressIndicator(),);
                  }
                );
                });
          }),
    );
  }
}
