// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:projectfood/about_customer/customer_login.dart';
import 'package:projectfood/about_customer/customer_register.dart';
import 'package:projectfood/main.dart';

class Customer extends StatefulWidget {
  const Customer({Key? key}) : super(key: key);

  @override
  _CustomerState createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
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
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const MyApp();
                  }));
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 3),
                  width: 220,
                  height: 260,
                  child: Image.asset(
                    'images/logoappCus.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 420,
                    height: 340,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: ExactAssetImage('images/shape.png'),
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
                              "Let's Order Your Food",
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
                                    primary:
                                        const Color.fromRGBO(255, 170, 0, 1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                                onPressed: () {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                    return CustomerLogin();
                                  }));
                                },
                                child: const Text(
                                  "เข้าสู่ระบบ",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontFamily: 'NotoSansThai-Regular'),
                                )),
                          ),
                          Container(
                            width: 343,
                            height: 50,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary:
                                        const Color.fromRGBO(37, 37, 37, 1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: const BorderSide(
                                            color:
                                                Color.fromRGBO(255, 170, 0, 1),
                                            width: 3))),
                                onPressed: () {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const CustomerRegister();
                                  }));
                                },
                                child: const Text(
                                  "สมัครสมาชิก",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'NotoSansThai-Regular',
                                    color: Color.fromRGBO(255, 170, 0, 1),
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )

        // Padding(
        //   padding: const EdgeInsets.fromLTRB(10, 100, 10, 0),
        //   child: Column(
        //     children: [
        //       SizedBox(
        //         width: double.infinity,
        //         child: ElevatedButton.icon(
        //             onPressed: () {
        //               Navigator.pushReplacement(context,
        //                   MaterialPageRoute(builder: (context) {
        //                 return CustomerLogin();
        //               }));
        //             },
        //             icon: const Icon(Icons.login),
        //             label: const Text(
        //               "เข้าสู่ระบบ",
        //               style: TextStyle(fontSize: 20),
        //             )),
        //       ),
        //       SizedBox(
        //         width: double.infinity,
        //         child: ElevatedButton.icon(
        //             onPressed: () {
        //               Navigator.pushReplacement(context,
        //                   MaterialPageRoute(builder: (context) {
        //                 return const CustomerRegister();
        //               }));
        //             },
        //             icon: const Icon(Icons.add),
        //             label: const Text(
        //               "สร้างบัญชีผู้ใช้",
        //               style: TextStyle(fontSize: 20),
        //             )),
        //       )
        //     ],
        //   ),
        // ),
        );
  }
}
