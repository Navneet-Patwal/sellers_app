import 'package:flutter/material.dart';
import '../../global/global_var.dart';
import '../widgets/my_appbar.dart';
class InfoUpdateScreen extends StatefulWidget {
  const InfoUpdateScreen({super.key});
  @override
  State<InfoUpdateScreen> createState() => _InfoUpdateScreenState();
}

class _InfoUpdateScreenState extends State<InfoUpdateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(titleMsg: "Profile", showBackButton:true),
      body: Padding(
        padding: const EdgeInsets.only(top:50),
        child: Center(
          child: Column(
            children: [
              Material(
                  borderRadius: const BorderRadius.all(Radius.circular(81)),
                  elevation: 8,
                  child: SizedBox(
                      height: 160,
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
                              top:120,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration:const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                                child: const Icon(Icons.photo_camera_outlined, size: 25,color: Colors.white,),),
                              )
                        ],
                      )

                  )
              ),
              const SizedBox(height: 12,),
              Text(sharedPreferences!.getString("name").toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
