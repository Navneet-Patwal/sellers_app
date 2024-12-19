import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sellers/global/global_ins.dart';
import 'package:sellers/global/global_var.dart';
import 'package:sellers/view/mainscreen/home_screen.dart';
import 'package:sellers/view/widgets/my_appbar.dart';

import '../../../model/menu.dart';

class ItemUploadScreen extends StatefulWidget {

  Menu? menuModel;
  ItemUploadScreen({super.key, this.menuModel});

  @override
  State<ItemUploadScreen> createState() => _ItemUploadScreenState();
}

class _ItemUploadScreenState extends State<ItemUploadScreen>
{


  TextEditingController infoTextEditingController = TextEditingController();
  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController descTextEditingController = TextEditingController();
  TextEditingController priceTextEditingController = TextEditingController();


  defaultScreen(){
    return Scaffold(
      appBar: MyAppbar(
          titleMsg: "Add New Item",
          showBackButton: true
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shop_two,
              color: Colors.black87,
              size: 200,
            ),
            ElevatedButton(
                onPressed:() async
                {
                  String response = await commonViewModel.showDialogWithImageOptions(context);
                  if(response=="Selected"){
                    setState(() {
                      imageFile;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: const Text(
                    "Add New Item"
                )
            )
          ],
        ),
      ),
    );
  }

  uploadItemFormScreen(){
    return Scaffold(
      appBar: MyAppbar(
        titleMsg: "Add New Item",
        showBackButton: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        onPressed: ()
        {
          setState(() {
            imageFile = null;
            titleTextEditingController.clear();
            infoTextEditingController.clear();
            priceTextEditingController.clear();
            descTextEditingController.clear();
          });
        },
        child: const Icon(
          Icons.close,
          color: Colors.white,
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 230,
            width: MediaQuery.of(context).size.width*0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(
                          File(
                              imageFile!.path
                          ),
                        ),
                        fit: BoxFit.cover,
                      )
                  ),
                ),
              ),
            ),
          ),

          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),

          //item info

          ListTile(
            leading: const Icon(Icons.info,color: Colors.black87,),
            title: TextField(
              style: const TextStyle(color: Colors.black),
              maxLines: 1,
              controller: infoTextEditingController,
              decoration: const InputDecoration(
                hintText: "Item Info",
                hintStyle: TextStyle(color: Colors.black),
                border: InputBorder.none,
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),

        //item title
          ListTile(
            leading: const Icon(Icons.title,color: Colors.black87,),
            title: TextField(
              style: const TextStyle(color: Colors.black),
              maxLines: 1,
              controller: titleTextEditingController,
              decoration: const InputDecoration(
                hintText: "Item Title",
                hintStyle: TextStyle(color: Colors.black),
                border: InputBorder.none,
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),

          //item description
          ListTile(
            leading: const Icon(Icons.description,color: Colors.black87,),
            title: TextField(
              style: const TextStyle(color: Colors.black),
              maxLines: 1,
              controller: descTextEditingController,
              decoration: const InputDecoration(
                hintText: "Item Description",
                hintStyle: TextStyle(color: Colors.black),
                border: InputBorder.none,
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),


          //item price
          ListTile(
            leading: const Icon(Icons.currency_rupee,color: Colors.black87,),
            title: TextField(
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.black),
              maxLines: 1,
              controller: priceTextEditingController,
              decoration: const InputDecoration(
                hintText: "Item Price",
                hintStyle: TextStyle(color: Colors.black),
                border: InputBorder.none,
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),




       const SizedBox(height: 50,),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              onPressed:() async {

               await itemViewModel.validateItemUploadForm(
                    infoTextEditingController.text.trim(),
                    titleTextEditingController.text.trim(),
                    descTextEditingController.text.trim(),
                    priceTextEditingController.text.trim(),
                    widget.menuModel!,
                    context);

                setState(() {
                  imageFile = null;
                });
                Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
              ),
              child: const Text("Upload",
                style: TextStyle(
                    color: Colors.white
                ),),
            ),
          )
        ],
      ),
    );
  }
  @override
  void initState(){
    // TODO implement initState
    super.initState();
    menuViewModel.getCategories();
  }
  @override
  Widget build(BuildContext context) {
    return imageFile==null?defaultScreen():uploadItemFormScreen();
  }
}
