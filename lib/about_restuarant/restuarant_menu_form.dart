// ignore_for_file: use_key_in_widget_constructors

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectfood/about_restuarant/restuarant_manage_menu.dart';
import 'package:projectfood/models/menu_model.dart';

class MenuForm extends StatefulWidget {
  @override
  _MenuFormState createState() => _MenuFormState();
}

class _MenuFormState extends State<MenuForm> {
  late File image;
  String urlPicture = "";

  //ฟังก์ชันเลือกรูปจาก gallery
  Future<void> pickImage() async {
    try {
      // ignore: non_constant_identifier_names
      final Image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (Image == null) return;

      final imageTemporary = File(Image.path);
      setState(() {
        image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print("failed to pick image: $e");
    }
  }

  final formKey = GlobalKey<FormState>(); //ประกาศ Form state เพื่อเรียกใช้ Form
  //ดึง model MenuModel มาเพื่อเก็บค่า
  MenuModel menu = MenuModel(
      restuarantMenuId: "",
      menuId: "",
      menuName: "",
      menuPrice: 0,
      menuDescript: "");

  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  CollectionReference menuCollection =
      FirebaseFirestore.instance.collection("menus");

  //ฟังก์ชัน upload รูปภาพลง cloud storage
  Future<void> uploadImage() async {
    Random random = Random();
    int i = random.nextInt(10000);
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference reference =
        firebaseStorage.ref().child("/ImageForMenu/imageFood$i.jpg");
    UploadTask uploadTask = reference.putFile(image);

    urlPicture =
        // ignore: await_only_futures
        await (await uploadTask.then((res) => res.ref.getDownloadURL()));
    print('urlPicture = $urlPicture');

    var firebaseUser = FirebaseAuth.instance.currentUser;
    String newMenuID = "MN${DateTime.now().millisecondsSinceEpoch.toString()}";

    await menuCollection.doc(newMenuID).set({
      "menu_id": newMenuID,
      "menu_name": menu.menuName,
      "menu_price": menu.menuPrice,
      "menu_descript": menu.menuDescript,
      "restuarant_menu_id": firebaseUser!.uid,
      "uriPicture": urlPicture,
    });
  }

//เป็นส่วนของ UI แสดงผลบนหน้าจอ
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    "เพิ่มรายการอาหาร",
                    style: TextStyle(fontFamily: 'NotoSansThai-Regular'),
                  ),
                  width: 180,
                  height: 37,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color.fromRGBO(118, 115, 217, 1),
                  ),
                ),
                centerTitle: true,
                automaticallyImplyLeading: true,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                  ),
                  onPressed: () {
                    Navigator.pop(context,
                        MaterialPageRoute(builder: (context) {
                      return const ManageMenu();
                    }));
                  },
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                backgroundColor: const Color.fromRGBO(255, 191, 64, 1),
                toolbarHeight: 80,
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
                  child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  pickImage();
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  child: Image.asset(
                                    "images/addphoto.png",
                                    scale: 2.1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Center(
                            child: Container(
                              width: 371,
                              height: 50,
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(241, 241, 241, 1),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: TextFormField(
                                style: const TextStyle(
                                    color: Color.fromRGBO(88, 88, 88, 1),
                                    fontFamily: 'NotoSansThai-Regular',
                                    fontSize: 18),
                                decoration: const InputDecoration(
                                  hintText: "ชื่ออาหาร",
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'NotoSansThai-Regular',
                                      color: Color.fromRGBO(88, 88, 88, 1)),
                                ),
                                keyboardType: TextInputType.text,
                                onSaved: (String? menuName) {
                                  menu.menuName = menuName!;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Container(
                              width: 371,
                              height: 50,
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(241, 241, 241, 1),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: TextFormField(
                                style: const TextStyle(
                                    color: Color.fromRGBO(88, 88, 88, 1),
                                    fontFamily: 'NotoSansThai-Regular',
                                    fontSize: 18),
                                decoration: const InputDecoration(
                                  hintText: "ราคา",
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'NotoSansThai-Regular',
                                      color: Color.fromRGBO(88, 88, 88, 1)),
                                ),
                                keyboardType: TextInputType.number,
                                onSaved: (String? menuPrice) {
                                  menu.menuPrice = int.parse(menuPrice!);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Container(
                              width: 371,
                              height: 50,
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(241, 241, 241, 1),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: TextFormField(
                                style: const TextStyle(
                                    color: Color.fromRGBO(88, 88, 88, 1),
                                    fontFamily: 'NotoSansThai-Regular',
                                    fontSize: 18),
                                decoration: const InputDecoration(
                                  hintText: "คำอธิบายเมนู",
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'NotoSansThai-Regular',
                                      color: Color.fromRGBO(88, 88, 88, 1)),
                                ),
                                keyboardType: TextInputType.text,
                                onSaved: (String? menuDescript) {
                                  menu.menuDescript = menuDescript!;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      )),
                ),
              ),
              //เป็นส่วนล่างของหน้าจอ
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
                      onPressed: () async {
                        formKey.currentState!.save();
                        uploadImage();
                        formKey.currentState!.reset();
                        Navigator.pop(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ManageMenu()));
                      },
                      child: const Text(
                        "สร้างรายการอาหาร",
                        style: TextStyle(
                            fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
                      )),
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
