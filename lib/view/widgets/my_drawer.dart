import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sellers/global/global_ins.dart';
import 'package:sellers/global/global_var.dart';
import 'package:sellers/view/mainscreen/home_screen.dart';

import '../splashScreen/splash_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          //header
          Container(
            padding: const EdgeInsets.only(top: 25, bottom: 10),
            child:Column(
              children: [
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(81)),
                  elevation: 8,
                  child: SizedBox(
                    height: 158,
                    width: 158,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        sharedPreferences!.getString("imageUrl").toString()
                      ),
                    ),
                  )
                ),
                const SizedBox(height: 12,),
                Text(sharedPreferences!.getString("name").toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ))
              ],
            )
          ),
          const SizedBox(height: 12,),
        //body
          Column(
            children: [
              const Divider(
                height: 10,
                thickness: 2,
                color: Colors.grey,

              ),
              ListTile(
                leading: const Icon(Icons.home, color: Colors.white,),
                title: const Text("Home",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => HomeScreen()));
                },

              ),

              const Divider(
                height: 10,
                thickness: 2,
                color: Colors.grey,

              ),
              ListTile(
                leading: const Icon(Icons.currency_rupee, color: Colors.white,),
                title: const Text("Earnings",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => HomeScreen()));
                },

              ),

              const Divider(
                height: 10,
                thickness: 2,
                color: Colors.grey,

              ),
              ListTile(
                leading: const Icon(Icons.shopping_bag, color: Colors.white,),
                title: const Text("New Orders",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => HomeScreen()));
                },

              ),

              const Divider(
                height: 10,
                thickness: 2,
                color: Colors.grey,

              ),
              ListTile(
                leading: const Icon(Icons.inventory_2, color: Colors.white,),
                title: const Text("Your Orders",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => HomeScreen()));
                },

              ),

              const Divider(
                height: 10,
                thickness: 2,
                color: Colors.grey,

              ),
              ListTile(
                leading: const Icon(Icons.edit_location_alt_sharp, color: Colors.white,),
                title: const Text("Change Address",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  commonViewModel.updateLocationInDatabase();
                  commonViewModel.showSnackBar("Your address updated successfully", context);
                  Navigator.push(context, MaterialPageRoute(builder: (c) => HomeScreen()));
                },

              ),

              const Divider(
                height: 10,
                thickness: 2,
                color: Colors.grey,

              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white,),
                title: const Text("Sign Out",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(context, MaterialPageRoute(builder: (c) => mySplashScreen()));
                },

              ),

              const Divider(
                height: 10,
                color: Colors.grey,
                thickness: 2,
              )
            ],
          )

        ],
      )
    );
  }
}

