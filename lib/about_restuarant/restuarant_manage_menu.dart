import 'package:flutter/material.dart';
import 'package:projectfood/about_restuarant/restuarant_home.dart';
import 'package:projectfood/about_restuarant/restuarant_menu_form.dart';
import 'package:projectfood/about_restuarant/restuarant_menu_lists.dart';

class ManageMenu extends StatefulWidget {
  const ManageMenu({Key? key}) : super(key: key);

  @override
  _ManageMenuState createState() => _ManageMenuState();
}

class _ManageMenuState extends State<ManageMenu> {
  //เป็นส่วนของ UI แสดงผลบนหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          child: const Text(
            "รายการอาหาร",
            style: TextStyle(fontFamily: 'NotoSansThai-Medium'),
          ),
          width: 165,
          height: 37,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: const Color.fromRGBO(118, 115, 217, 1),
          ),
        ),
        centerTitle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color.fromRGBO(255, 191, 64, 1),
        toolbarHeight: 80,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.pop(context, MaterialPageRoute(builder: (context) {
              return const RestuarantHome();
            }));
          },
        ),
      ),
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: MenuLists(),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(44, 47, 57, 1),
        ),
        child: Container(
          margin: const EdgeInsets.all(17),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color.fromRGBO(0, 177, 62, 1),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MenuForm()));
              },
              child: const Text(
                "เพิ่มรายการอาหาร",
                style:
                    TextStyle(fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
              )),
        ),
      ),
    );
  }
}
