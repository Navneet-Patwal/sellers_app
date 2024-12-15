import 'package:flutter/material.dart';
import 'package:sellers/view/splashScreen/splash_screen.dart';
import '../../model/address.dart';

class ShipmentAddressUiDesign extends StatelessWidget {
  Address? model;
  String? orderStatus;

  ShipmentAddressUiDesign({super.key, this.model, this.orderStatus});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        //shipping details
        const Padding(padding: EdgeInsets.all(10),
        child: Text(
          "Shipping Details:",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),),

        const SizedBox( height: 6.0,),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5 ),
          width: MediaQuery.of(context).size.width,
          child:Table(
            children: [
              TableRow(
                children: [
                  const Text(
                      "Name ", style: TextStyle(color: Colors.white)
                  ),
                  Text(model!.name!)
                ]
              ),
              TableRow(
                  children: [
                    const Text(
                        "Phone Number ", style: TextStyle(color: Colors.white)
                    ),
                    Text(model!.phoneNumber!)
                  ]
              ),
            ],
          ),
        ),

        const SizedBox(height: 10,),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal:40,vertical: 5),
          child: Text(
            "Address ${model!.fullAddress!}",
            textAlign: TextAlign.justify,
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: (){

              Navigator.push(context, MaterialPageRoute(builder: (c)=> const mySplashScreen()));
            },
            child: Container(
              alignment: Alignment.center,
              color: Colors.green,
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Center(
                child: Text(
                  orderStatus == "ended" ? "Go back" :"Order Picking - Done",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
