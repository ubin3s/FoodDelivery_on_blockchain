// ignore_for_file: prefer_const_constructors_in_immutables, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectfood/about_rider/rider_home.dart';

class RiderMetamark extends StatefulWidget {
  RiderMetamark({Key? key}) : super(key: key);

  @override
  _RiderMetamarkState createState() => _RiderMetamarkState();
}

class _RiderMetamarkState extends State<RiderMetamark> {
  final formKey = GlobalKey<FormState>();

  TextEditingController customerDWController = TextEditingController();
  TextEditingController customerPvDWController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 191, 64, 1),
      // appBar: AppBar(
      //   title: const Text("กรอกรหัสกระเป๋าตังค์ดิจิทัล"),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 60),
              width: 360,
              height: 120,
              child: Image.asset(
                'images/metamark.png',
                fit: BoxFit.fitWidth,
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
                                "กระเป๋าเงินดิจิทัล",
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
                                  controller: customerDWController,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'NotoSansThai-Regular',
                                          color:
                                              Color.fromRGBO(178, 178, 178, 1)),
                                      hintText: "หมายเลขกระเป๋าตังค์ดิจิทัล"),
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
                                  controller: customerPvDWController,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'NotoSansThai-Regular',
                                          color:
                                              Color.fromRGBO(178, 178, 178, 1)),
                                      hintText:
                                          "คีย์ส่วนตัวกระเป๋าตังค์ดิจิทัล"),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
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

  Widget _showOKButton() {
    // ignore: deprecated_member_use
    return Center(
      child: Container(
        width: 343,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: const Color.fromRGBO(255, 170, 0, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          onPressed: () {
            var firebaseUser = FirebaseAuth.instance.currentUser;
            FirebaseFirestore.instance
                .collection("Riders")
                .doc(firebaseUser!.uid)
                .set({
              "digital_wallet": customerDWController.text,
              "private_digital_wallet": customerPvDWController.text
            }, SetOptions(merge: true));
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return RiderHome();
            }));
          },
          child: const Text("ยืนยัน",
              style:
                  TextStyle(fontSize: 20, fontFamily: 'NotoSansThai-Regular')),
        ),
      ),
    );
  }
}
