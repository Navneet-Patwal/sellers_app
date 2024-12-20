import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../global/global_ins.dart';
import '../widgets/my_appbar.dart';
import '../widgets/order_card_ui_design.dart';


class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(titleMsg: "History", showBackButton: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: ordersViewModel.retrieveOrderHistory(),
        builder: (c, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.network("https://lottie.host/0cffb566-76a0-47e0-be40-43b4aca390d0/mojGmYzm3R.json",
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    fit: BoxFit.contain),
                const Center(child: Text("Loading...",
                  style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),)),
              ],
            ); // Show loading indicator
          }

          // Check for errors
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading history",style: TextStyle(color: Colors.black, fontSize:25)));
          }

          // Check if there is no data
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.network("https://lottie.host/60a95ff6-1e02-45c7-826d-0d9687af5aa7/hzkQnqGBU7.json",
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    fit: BoxFit.contain),
                const Center(child: Text("No History",
                  style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),)),
              ],
            );
          }
          return snapshot.hasData ?
          ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (c,index){
                return FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance.collection("items")
                      .where("itemId", whereIn: ordersViewModel.separateOrderItemIdsForOrders(
                      (snapshot.data!.docs[index].data() as Map<String, dynamic>)["productIds"]
                  ))
                      .where("sellersUid", whereIn: (snapshot.data!.docs[index].data()! as Map<String, dynamic>)["uid"])
                      .orderBy("publishedDateTime", descending: true)
                      .get(),
                  builder: (c, snap){
                    return snap.hasData ? Card(
                      child: OrderCardUiDesign(
                          itemCount: snap.data!.docs.length,
                          data: snap.data!.docs,
                          orderId: snapshot.data!.docs[index].id,
                          separateQuantityList: ordersViewModel.separateOrderItemQuantity((snapshot.data!.docs[index].data() as Map<String, dynamic>)["productIds"])),
                    ) : const Center(child: CircularProgressIndicator(color: Colors.green,),);
                  },

                );
              }
          ):
          //Center(child: Text("No orders found", style: TextStyle(color: Colors.white),),);
          const Center(child: CircularProgressIndicator(color: Colors.green,),);

        },
      ),
    );
  }
}
