import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
        width: 120,
        child: FloatingActionButton(
          backgroundColor: Colors.black87,
            onPressed: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (c)=> const MenuUploadScreen()));
            },
            child: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 5,right: 2),
                  child: Icon(Icons.add,color: Colors.white,),
                ),
                 Text(
                "New Menu",
                  style: TextStyle(
                    fontSize: 15,
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
            return const Center(child: CircularProgressIndicator(color: Colors.black,)); // Show loading indicator
          }

          // Check for errors
          if (snapShot.hasError) {
            return const Center(child: Text("Error loading data"));
          }

          // Check if there is no data
          if (!snapShot.hasData || snapShot.data!.docs.isEmpty) {
            return const Center(child: Text("No menus found! Add new menu"));
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
