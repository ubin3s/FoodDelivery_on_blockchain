// ignore_for_file: use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectfood/about_customer/customer_metamask.dart';

class CustomerForm extends StatefulWidget {
  @override
  _CustomerFormState createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  final formKey = GlobalKey<FormState>();

  //ประกาศตัวแปรเพื่อใช้ในการรับข้อมูลจากการกรอก form
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerTelController = TextEditingController();
  TextEditingController customerAddressController = TextEditingController();

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
              width: 255,
              height: 120,
              child: Image.asset(
                'images/bumbleFood.png',
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
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 80, left: 15),
                              child: const Text(
                                "ข้อมูลส่วนตัว",
                                style: TextStyle(
                                    fontSize: 35,
                                    fontFamily: 'NotoSansThai-Regular',
                                    color: Colors.white),
                              ),
                            ),
                            Center(
                              child: Container(
                                width: 343,
                                height: 50,
                                margin: const EdgeInsets.only(top: 20),
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(108, 108, 108, 1),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: TextFormField(
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18),
                                  controller: customerNameController,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "ชื่อลูกค้า",
                                      hintStyle: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'NotoSansThai-Regular',
                                          color: Color.fromRGBO(
                                              178, 178, 178, 1))),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                width: 343,
                                height: 50,
                                margin: const EdgeInsets.only(top: 20),
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(108, 108, 108, 1),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: TextFormField(
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18),
                                  controller: customerAddressController,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "ที่อยู่ลูกค้า",
                                      hintStyle: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'NotoSansThai-Regular',
                                          color: Color.fromRGBO(
                                              178, 178, 178, 1))),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                width: 343,
                                height: 50,
                                margin: const EdgeInsets.only(top: 20),
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(108, 108, 108, 1),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: TextFormField(
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18),
                                  controller: customerTelController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "เบอร์โทรศัพท์",
                                    hintStyle: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'NotoSansThai-Regular',
                                        color:
                                            Color.fromRGBO(178, 178, 178, 1)),
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// Widget สำหรับปุ่มสมัครสมาชิก
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
            var firebaseUser = FirebaseAuth
                .instance.currentUser; //เก็บ uid ของ account ที่กำลัง login

            //สร้างข้อมูลใหม่เข้าไปใน firebase
            FirebaseFirestore.instance
                .collection("customers")
                .doc(firebaseUser!.uid)
                .set({
              "customer_id": firebaseUser.uid,
              "customer_name": customerNameController.text,
              "customer_address": customerAddressController.text,
              "customer_tel": customerTelController.text
            });

            //กำหนดให้เปลี่ยนหน้า
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return MetaMark();
            }));
          },
          child: const Text(
            "สมัครสมาชิก",
            style: TextStyle(fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
          ),
        ),
      ),
    );
  }
}
