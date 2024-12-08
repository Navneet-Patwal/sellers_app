import 'package:flutter/material.dart';
import 'package:sellers/global/global_var.dart';
import 'package:sellers/view/mainscreen/menu_upload_screen.dart';
import 'package:sellers/view/widgets/my_appbar.dart';
import 'package:sellers/view/widgets/my_drawer.dart';


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
    );
  }
}
