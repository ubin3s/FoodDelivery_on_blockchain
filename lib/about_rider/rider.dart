// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:projectfood/about_rider/rider_login.dart';
import 'package:projectfood/about_rider/rider_register.dart';
import 'package:projectfood/main.dart';

class Rider extends StatefulWidget {
  const Rider({Key? key}) : super(key: key);

  @override
  _RiderState createState() => _RiderState();
}

class _RiderState extends State<Rider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 191, 64, 1),
      // appBar: AppBar(
      //   title: const Text("พนักงานขนส่งอาหาร"),
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
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const MyApp();
                }));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 3),
                width: 200,
                height: 260,
                child: Image.asset(
                  'images/Riderlogo.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 420,
                  height: 355,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: ExactAssetImage('images/shapeRider.png'),
                    fit: BoxFit.fitWidth,
                  )),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 45),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 50,
                          padding: const EdgeInsets.only(
                            left: 35,
                          ),
                          alignment: Alignment.bottomLeft,
                          child: const Text(
                            "Let's Deliver Food",
                            style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'NotoSansThai-Medium',
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Container(
                          width: 343,
                          height: 50,
                          margin: const EdgeInsets.only(bottom: 20, top: 20),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: const Color.fromRGBO(255, 170, 0, 1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              onPressed: () {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return RiderLogin();
                                }));
                              },
                              child: const Text(
                                "เข้าสู่ระบบ",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'NotoSansThai-Regular'),
                              )),
                        ),
                        Container(
                            width: 343,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: const Color.fromRGBO(37, 37, 37, 1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: const BorderSide(
                                          color: Color.fromRGBO(255, 170, 0, 1),
                                          width: 3))),
                              onPressed: () {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const RiderRegister();
                                }));
                              },
                              child: const Text("สมัครสมาชิก",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'NotoSansThai-Regular',
                                    color: Color.fromRGBO(255, 170, 0, 1),
                                  )),
                            ))
                      ],
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
}
