import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sellers/global/global_ins.dart';
import 'package:sellers/global/global_var.dart';
import 'package:sellers/view/mainscreen/earnings_screen.dart';
import 'package:sellers/view/mainscreen/history_screen.dart';
import 'package:sellers/view/mainscreen/home_screen.dart';
import 'package:sellers/view/mainscreen/info_update_screen.dart';
import 'package:sellers/view/mainscreen/new_orders_screen.dart';

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
                  child: InkWell(
                    onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (c)=> const InfoUpdateScreen()));
                    },
                    child: SizedBox(
                      height: 158,
                      width: 158,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius:81,
                            backgroundImage: NetworkImage(
                                sharedPreferences!.getString("imageUrl").toString()
                            ),
                          ),
                          Positioned(
                              right: 0,
                              top:0,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration:const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: const Icon(Icons.edit, size: 25,color: Colors.black45,),),
                              )
                        ],
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
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const HomeScreen())),

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
                  Navigator.push(context, MaterialPageRoute(builder: (c) => const EarningsScreen()));
                },

              ),

              const Divider(
                height: 10,
                thickness: 2,
                color: Colors.grey,
              ),

              ListTile(
                leading: const Icon(Icons.new_releases, color: Colors.white,),
                title: const Text("New Orders",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => const NewOrdersScreen()));
                },

              ),

              const Divider(
                height: 10,
                thickness: 2,
                color: Colors.grey,

              ),
              ListTile(
                leading: const Icon(Icons.access_time, color: Colors.white,),
                title: const Text("Orders History",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => const HistoryScreen()));
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
                  Navigator.push(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
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
                  Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
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

