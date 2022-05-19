// ignore_for_file: use_key_in_widget_constructors, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectfood/about_restuarant/restuarant_metamask.dart';

class RestuarantForm extends StatefulWidget {
  @override
  _RestuarantFormState createState() => _RestuarantFormState();
}

class _RestuarantFormState extends State<RestuarantForm> {
  final formKey = GlobalKey<FormState>(); //ประกาศ FormState เพื่อเรียกใช้ Form

//ประกาศตัวแปรเพื่อรับค่าจากการกรอกข้อมูล
  TextEditingController restuarantNameController = TextEditingController();
  TextEditingController restuarantOwnerController = TextEditingController();
  TextEditingController restuarantTelController = TextEditingController();
  TextEditingController restuarantAddressController = TextEditingController();

//เป็นส่วนของ UI แสดงผลบนหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 191, 64, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 60),
              width: 350,
              height: 120,
              child: Image.asset(
                'images/logoAppRes.png',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                Container(
                  width: 420,
                  height: 660,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: ExactAssetImage('images/shapelong.png'),
                    fit: BoxFit.fitWidth,
                  )),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: 80, left: 15),
                                  child: const Text(
                                    "รายละเอียดร้านอาหาร",
                                    style: TextStyle(
                                        fontSize: 35,
                                        fontFamily: 'NotoSansThai-Regular',
                                        color: Colors.white),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    width: 343,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          108, 108, 108, 1),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: TextFormField(
                                        style: const TextStyle(
                                            color: Colors.white),
                                        controller: restuarantNameController,
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                                fontSize: 20,
                                                fontFamily:
                                                    'NotoSansThai-Regular',
                                                color: Color.fromRGBO(
                                                    178, 178, 178, 1)),
                                            hintText: "ชื่อร้านอาหาร"),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    width: 343,
                                    height: 50,
                                    margin: const EdgeInsets.only(top: 20),
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          108, 108, 108, 1),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: TextFormField(
                                        style: const TextStyle(
                                            color: Colors.white),
                                        controller: restuarantOwnerController,
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                                fontSize: 20,
                                                fontFamily:
                                                    'NotoSansThai-Regular',
                                                color: Color.fromRGBO(
                                                    178, 178, 178, 1)),
                                            hintText: "ชื่อเจ้าของร้านอาหาร"),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    width: 343,
                                    height: 50,
                                    margin: const EdgeInsets.only(top: 20),
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          108, 108, 108, 1),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: TextFormField(
                                        style: const TextStyle(
                                            color: Colors.white),
                                        controller: restuarantAddressController,
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                                fontSize: 20,
                                                fontFamily:
                                                    'NotoSansThai-Regular',
                                                color: Color.fromRGBO(
                                                    178, 178, 178, 1)),
                                            hintText: "ที่อยู่ร้านอาหาร"),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    width: 343,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          108, 108, 108, 1),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: TextFormField(
                                        style: const TextStyle(
                                            color: Colors.white),
                                        controller: restuarantTelController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                                fontSize: 20,
                                                fontFamily:
                                                    'NotoSansThai-Regular',
                                                color: Color.fromRGBO(
                                                    178, 178, 178, 1)),
                                            hintText: "เบอร์โทรศัพท์"),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _showOKButton(),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

//เป็น widget ปุ่มกดยืนยัน
  Widget _showOKButton() {
    // ignore: deprecated_member_use
    return Center(
      child: Container(
        width: 343,
        height: 50,
        margin: const EdgeInsets.only(top: 25),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: const Color.fromRGBO(255, 170, 0, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          onPressed: () {
            //ส่งข้อมูลไปบันทึกใน firebase
            var firebaseUser = FirebaseAuth.instance.currentUser;
            FirebaseFirestore.instance
                .collection("restuarants")
                .doc(firebaseUser!.uid)
                .set({
              "restuarant_id": firebaseUser.uid,
              "restuarant_name": restuarantNameController.text,
              "restuarant_owner": restuarantOwnerController.text,
              "restuarant_address": restuarantAddressController.text,
              "restuarant_tel": restuarantTelController.text
            });
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return ResMetaMark();
            }));
          },
          child: const Text("ยืนยัน",
              style:
                  TextStyle(fontSize: 22, fontFamily: 'NotoSansThai-Regular')),
        ),
      ),
    );
  }
}
