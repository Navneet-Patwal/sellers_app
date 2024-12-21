import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sellers/global/global_ins.dart';
import 'package:sellers/global/global_var.dart';
import 'package:sellers/view/mainscreen/menus/menu_upload_screen.dart';
import 'package:sellers/view/widgets/menu_ui_design.dart';
import 'package:sellers/view/widgets/my_appbar.dart';
import 'package:sellers/view/widgets/my_drawer.dart';

import '../../model/menu.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {

    super.initState();
    commonViewModel.retrieveSellersEarnings();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: MyAppbar(
          titleMsg: "Welcome! ${sharedPreferences!.getString("name").toString()}",
          showBackButton: false,
      ),
      floatingActionButton: SizedBox(
        width: 100,
        child: FloatingActionButton(
          backgroundColor: Colors.black87,
            onPressed: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (c)=> const MenuUploadScreen()));
            },
            child: const Row(
              children:  [
                Icon(Icons.add,color: Colors.white,),
                 Text(
                "New Menu",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white
                  ),
                        ),
              ],
            ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: menuViewModel.retrieveMenus(),
        builder: (context, snapShot){
          if (snapShot.connectionState == ConnectionState.waiting) {
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
          if (snapShot.hasError) {
            return const Center(child: Text("Error loading data",style: TextStyle(fontSize: 20,color: Colors.black)));
          }

          // Check if there is no data
          if (!snapShot.hasData || snapShot.data!.docs.isEmpty) {
            return  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.network("https://lottie.host/60a95ff6-1e02-45c7-826d-0d9687af5aa7/hzkQnqGBU7.json",
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    fit: BoxFit.contain),
                const Center(child: Text("No Menus found.",
                  style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),)),
              ],
            );
          }
            return
                ListView.builder(
                  itemCount: snapShot.data!.docs.length,
                    itemBuilder: (context, index){
                   Menu menuModel = Menu.fromJson(
                     snapShot.data!.docs[index].data()! as Map<String, dynamic>
                   );
                   return Card(
                     elevation: 6,
                     color: Colors.black87,
                     child: MenuUiDesign(
                       menuModel: menuModel,
                     ),
                   );
                    }
                );
        },
      )
    );
  }

}
