import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sellers/global/global_ins.dart';
import 'package:sellers/view/widgets/my_appbar.dart';
import '../../../model/item.dart';
import '../../../model/menu.dart';
import '../../widgets/item_ui_design.dart';
import 'items_upload_screen.dart';



class ItemsScreen extends StatefulWidget {

  final Menu? menuModel;
  const ItemsScreen({super.key, this.menuModel});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       // drawer: MyDrawer(),
        appBar: MyAppbar(
          titleMsg: widget.menuModel!.menuTitle.toString().toUpperCase() + "'s Items",
          showBackButton: true,
        ),
        floatingActionButton: SizedBox(
          width: 120,
          child: FloatingActionButton(
            backgroundColor: Colors.black87,
            onPressed: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemUploadScreen(menuModel: widget.menuModel,)));
            },
            child: const Text(
              "Add New Item",
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white
              ),
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: itemViewModel.retrieveItems(widget.menuModel!.menuId),
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
              return const Center(child: Text("No Items found Add items to get started",
              style: TextStyle(color: Colors.black, fontSize: 20),));
            }
            return
            ListView.builder(
                itemCount: snapShot.data!.docs.length,
                itemBuilder: (context, index){

                 Item itemModel = Item.fromJson(
                      snapShot.data!.docs[index].data()! as Map<String, dynamic>
                  );
                  return Card(
                    elevation: 6,
                    color: Colors.black87,
                    child: ItemUiDesign(
                      itemModel: itemModel,
                    ),
                  );
                }
            );
          },
        )
    );
  }
}
