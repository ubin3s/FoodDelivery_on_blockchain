// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projectfood/about_restuarant/restuarant_manage_menu.dart';

class MenuEditForm extends StatefulWidget {
  //ประกาศ constractor เพื่อรับค่าจากหน้าอื่น
  final String menuId;
  final String menuName;
  final int menuPrice;
  final String menuDescript;
  final String urlPicture;

  MenuEditForm(
      {required this.menuId,
      required this.menuName,
      required this.menuPrice,
      required this.menuDescript,
      required this.urlPicture});

  @override
  _MenuEditFormState createState() => _MenuEditFormState();
}

class _MenuEditFormState extends State<MenuEditForm> {
  TextEditingController menuNameController = TextEditingController();
  TextEditingController menuPriceController = TextEditingController();
  TextEditingController menuDescriptController = TextEditingController();

// Set ค่าที่รับมาให้กับตัวแปรที่ประกาศไว้
  @override
  void initState() {
    super.initState();

    menuNameController.text = widget.menuName;
    menuPriceController.text = widget.menuPrice.toString();
    menuDescriptController.text = widget.menuDescript;
  }

  //เป็นส่วนของ UI แสดงผลบนหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          child: const Text(
            "รายการอาหาร",
            style: TextStyle(fontFamily: 'NotoSansThai-Regular'),
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
              return const ManageMenu();
            }));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    // ignore: prefer_const_constructors
                    Container(
                        width: 250,
                        height: 150,
                        margin: const EdgeInsets.only(
                            right: 10, top: 10, bottom: 20),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: NetworkImage(widget.urlPicture))),
                        )),
                    Container(
                      width: 371,
                      height: 50,
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(241, 241, 241, 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      margin: const EdgeInsets.only(bottom: 20),
                      child: TextField(
                        style: const TextStyle(
                            color: Color.fromRGBO(88, 88, 88, 1),
                            fontFamily: 'NotoSansThai-Regular',
                            fontSize: 18),
                        controller: menuNameController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontSize: 20,
                              fontFamily: 'NotoSansThai-Regular',
                              color: Color.fromRGBO(88, 88, 88, 1)),
                          hintText: "ชื่ออาหาร",
                        ),
                      ),
                    ),
                    Container(
                      width: 371,
                      height: 50,
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(241, 241, 241, 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      margin: const EdgeInsets.only(bottom: 20),
                      child: TextField(
                        style: const TextStyle(
                            color: Color.fromRGBO(88, 88, 88, 1),
                            fontFamily: 'NotoSansThai-Regular',
                            fontSize: 18),
                        controller: menuPriceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "ราคา",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontSize: 20,
                              fontFamily: 'NotoSansThai-Regular',
                              color: Color.fromRGBO(88, 88, 88, 1)),
                        ),
                      ),
                    ),
                    Container(
                      width: 371,
                      height: 50,
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(241, 241, 241, 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      margin: const EdgeInsets.only(bottom: 20),
                      child: TextField(
                        controller: menuDescriptController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: "คำอธิบายอาหาร",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontSize: 20,
                              fontFamily: 'NotoSansThai-Regular',
                              color: Color.fromRGBO(178, 178, 178, 1)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ])),
            ),
          ],
        ),
      ),
      //เป็นส่วนล่างของหน้าจอ
      bottomNavigationBar: Container(
        height: 160,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(44, 47, 57, 1),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              width: 371,
              height: 51,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(255, 77, 77, 1),
                  ),
                  onPressed: () async {
                    // ลบข้อมูลใน firebase
                    final reference = FirebaseFirestore.instance
                        .collection("menus")
                        .doc(widget.menuId);
                    try {
                      await reference.delete();
                    } catch (err) {
                      rethrow;
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "ลบรายการอาหาร",
                    style: TextStyle(
                        fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
                  )),
            ),
            Container(
              width: 371,
              height: 51,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(0, 177, 62, 1),
                  ),
                  onPressed: () async {
                    //update ข้อมูลใน firebase
                    await FirebaseFirestore.instance
                        .collection("menus")
                        .doc(widget.menuId)
                        .update({
                      "menu_name": menuNameController.text,
                      "menu_price": int.tryParse(menuPriceController.text),
                      "menu_descript": menuDescriptController.text
                    });
                    menuNameController.clear();
                    menuPriceController.clear();
                    menuDescriptController.clear();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "แก้ไขรายการอาหาร",
                    style: TextStyle(
                        fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
