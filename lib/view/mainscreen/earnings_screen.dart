import 'package:flutter/material.dart';
import 'package:sellers/global/global_var.dart';
class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("₹$sellersTotalEarnings",
                style: const TextStyle(
                  fontSize: 80,
                  color: Colors.black,
                  fontFamily: "Signatra"
                ),),

                const Text("Total Earnings",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                ),),

                const SizedBox(
                  height: 20,
                    width: 200,
                  child: Divider(
                    color: Colors.white,
                    thickness: 1.5,
                  ),
                ),

                const SizedBox(height: 40,),

                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: const Card(
                    color: Colors.black,
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 125),
                    child: ListTile(
                      leading: Icon(Icons.arrow_back,size: 30,
                      color: Colors.white,),
                      title: Text(
                        "Back",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
