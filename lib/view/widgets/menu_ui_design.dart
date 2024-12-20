import 'package:flutter/material.dart';
import 'package:sellers/global/global_ins.dart';
import 'package:sellers/view/editscreens/edit_menu_info_screen.dart';
import 'package:sellers/view/mainscreen/items/items_screen.dart';
import '../../model/menu.dart';

class MenuUiDesign extends StatefulWidget {

  Menu? menuModel;
  MenuUiDesign({super.key, this.menuModel});

  @override
  State<MenuUiDesign> createState() => _MenuUiDesignState();
}

class _MenuUiDesignState extends State<MenuUiDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemsScreen(menuModel: widget.menuModel,)));
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
                     widget.menuModel!.menuImage.toString(),
                     width: MediaQuery.of(context).size.width,
                     height: 220,
                     fit:BoxFit.fitWidth
                 ),
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Text(widget.menuModel!.menuInfo.toString(),
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
                           Navigator.push(context,MaterialPageRoute(builder: (c)=> EditMenuInfoScreen(menuId: widget.menuModel!.menuId,)));
                     } else if (value == 'delete') {
                             menuViewModel.deleteMenu(widget.menuModel!.menuId,context);
                             ScaffoldMessenger.of(context).showSnackBar(
                                 const SnackBar(content: Text('Menu has been deleted.')));
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
