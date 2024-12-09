import 'package:flutter/material.dart';
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
         child: Column(
          children: [
          Image.network(
            widget.menuModel!.menuImage.toString(),
            width: MediaQuery.of(context).size.width,
            height: 220,
            fit:BoxFit.fitWidth
          ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.menuModel!.menuTitle.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "Train",
                ),
                ),
                IconButton(onPressed: (){},
                    icon: const Icon(Icons.delete_sweep_outlined,
                    color: Colors.white,))
              ],
            )
          ],
         ),
       ),

    ),);
  }
}
