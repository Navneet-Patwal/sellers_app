import 'package:flutter/material.dart';

import '../../model/item.dart';


class ItemUiDesign extends StatefulWidget {
  Item? itemModel;
  ItemUiDesign({super.key, this.itemModel});

  @override
  State<ItemUiDesign> createState() => _ItemUiDesignState();
}

class _ItemUiDesignState extends State<ItemUiDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: (){
      //Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemsScreen(menuModel: widget.menuModel,)));
    },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          height: 270,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Image.network(
                  widget.itemModel!.itemImage.toString(),
                  width: MediaQuery.of(context).size.width,
                  height: 220,
                  fit:BoxFit.fitWidth
              ),
              const SizedBox(height: 2,),
              Text(widget.itemModel!.itemTitle.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "Train",
                ),
              ),
            ],
          ),
        ),

      ),);
  }
}
