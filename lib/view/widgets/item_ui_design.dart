import 'package:flutter/material.dart';
import 'package:sellers/view/editscreens/edit_item_info_screen.dart';

import '../../global/global_ins.dart';
import '../../model/item.dart';


class ItemUiDesign extends StatefulWidget {
  Item? itemModel;
  String? menuId;
  ItemUiDesign({super.key, this.itemModel, this.menuId});

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
          child: Stack(
            children: [
              Column(
                children: [
                  Image.network(
                      widget.itemModel!.itemImage.toString(),
                      width: MediaQuery.of(context).size.width,
                      height: 220,
                      fit:BoxFit.fitWidth
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.itemModel!.itemTitle.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: "Train",
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      Navigator.push(context, MaterialPageRoute(builder: (c)=> EditItemInfoScreen(itemId: widget.itemModel!.itemId,menuId:widget.menuId)));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('edit clicked!')),
                      );
                    } else if (value == 'delete') {
                      itemViewModel.deleteItem(widget.itemModel!.itemId,widget.menuId,context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Item has been deleted.')));
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ];
                  },
                  child: const  Icon(Icons.keyboard_control, color: Colors.white,size: 40,),
                ),
              ),
            ],
          ),
        ),

      ),);
  }
}
