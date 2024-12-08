import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sellers/global/global_ins.dart';
import 'package:sellers/global/global_var.dart';
import 'package:sellers/view/widgets/my_appbar.dart';

class MenuUploadScreen extends StatefulWidget {
  const MenuUploadScreen({super.key});

  @override
  State<MenuUploadScreen> createState() => _MenuUploadScreenState();
}

class _MenuUploadScreenState extends State<MenuUploadScreen> {
  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController infoTextEditingController = TextEditingController();
  defaultScreeen(){
    return Scaffold(
      appBar: MyAppbar(
          titleMsg: "Add New Menu",
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
                    "Add New Menu"
                )
            )
          ],
        ),
      ),
    );
  }
  uploadMenuFormScreen(){
    return Scaffold(
      appBar: MyAppbar(
          titleMsg: "Upload New Menu",
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
          )
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return imageFile==null?defaultScreeen():uploadMenuFormScreen();
  }
}
