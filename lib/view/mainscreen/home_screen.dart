import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sellers/global/global_ins.dart';
import 'package:sellers/global/global_var.dart';
import 'package:sellers/view/mainscreen/menu_upload_screen.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: MyAppbar(
          titleMsg: sharedPreferences!.getString("name").toString(),
          showBackButton: false,
      ),
      floatingActionButton: SizedBox(
        width: 120,
        child: FloatingActionButton(
          backgroundColor: Colors.black87,
            onPressed: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (c)=> MenuUploadScreen()));
            },
            child: const Text(
            "Add New Menu",
              style: TextStyle(
                fontSize: 15,
                color: Colors.white
              ),
        ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: menuViewModel.retrieveMenus(),
        builder: (context, snapShot){
            return !snapShot.hasData ?
             const Center(
             child: Text("No data available")
            ):
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
