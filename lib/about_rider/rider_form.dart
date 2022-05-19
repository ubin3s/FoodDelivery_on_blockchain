// ignore_for_file: use_key_in_widget_constructors, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectfood/about_rider/rider_metamark.dart';

class RiderForm extends StatefulWidget {
  @override
  _RiderFormState createState() => _RiderFormState();
}

class _RiderFormState extends State<RiderForm> {
  final formKey = GlobalKey<FormState>();

  TextEditingController RiderNameController = TextEditingController();
  TextEditingController RiderTelController = TextEditingController();
  TextEditingController CarModelController = TextEditingController();
  TextEditingController CarlicensePlateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 191, 64, 1),
      // appBar: AppBar(
      //   title: const Text("สมัครสมาชิกสำหรับพนักงานขนส่งอาหาร"),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 60),
              width: 350,
              height: 120,
              child: Image.asset(
                'images/logoAppRider.png',
                fit: BoxFit.fitHeight,
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
                                margin: const EdgeInsets.only(top: 20),
                                width: 343,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(108, 108, 108, 1),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: TextFormField(
                                    style: const TextStyle(color: Colors.white),
                                    controller: RiderNameController,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'NotoSansThai-Regular',
                                            color: Color.fromRGBO(
                                                178, 178, 178, 1)),
                                        hintText: "ชื่อพนักงานขนส่งอาหาร"),
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
                                  color: const Color.fromRGBO(108, 108, 108, 1),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: TextFormField(
                                    style: const TextStyle(color: Colors.white),
                                    controller: CarModelController,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'NotoSansThai-Regular',
                                            color: Color.fromRGBO(
                                                178, 178, 178, 1)),
                                        hintText: "รุ่นรถ"),
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
                                  color: const Color.fromRGBO(108, 108, 108, 1),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: TextFormField(
                                    style: const TextStyle(color: Colors.white),
                                    controller: CarlicensePlateController,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                        hintStyle: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'NotoSansThai-Regular',
                                            color: Color.fromRGBO(
                                                178, 178, 178, 1)),
                                        border: InputBorder.none,
                                        hintText: "ทะเบียนรถ"),
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
                                  color: const Color.fromRGBO(108, 108, 108, 1),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: TextFormField(
                                    style: const TextStyle(color: Colors.white),
                                    controller: RiderTelController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'NotoSansThai-Regular',
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
        margin: const EdgeInsets.only(top: 25),
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
              "rider_id": firebaseUser.uid,
              "rider_name": RiderNameController.text,
              "rider_tel": RiderTelController.text,
              "rider_car_model": CarModelController.text,
              "rider_license_plate": CarlicensePlateController.text
            });
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return RiderMetamark();
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
