// ignore_for_file: use_key_in_widget_constructors, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectfood/about_customer/customer_history.dart';
import 'package:projectfood/about_customer/customer_information.dart';
import 'package:projectfood/about_customer/customer_viewmenu.dart';

class CustomerHome extends StatefulWidget {
  @override
  _CustomerHomeState createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  final auth = FirebaseAuth.instance; //เก็บ uid สำหรับ accouut ที่กำลัง login

  //เป็นส่วนของ UI แสดงผลบนหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 191, 64, 1),
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: const Text(
          "หน้าหลัก",
          style: TextStyle(fontFamily: 'NotoSansThai-Medium'),
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        )),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 25),
            child: Row(
              children: [
                SingleChildScrollView(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: IconButton(
                        color: const Color.fromRGBO(118, 115, 217, 1),
                        onPressed: () async {
                          var firebaseUser = FirebaseAuth.instance.currentUser;
                          var queryFirebase = await FirebaseFirestore.instance
                              .collection("customers")
                              .where("customer_id",
                                  isEqualTo: firebaseUser!.uid)
                              .get();

                          queryFirebase.docs.forEach((cusAddress) {
                            Navigator.push(context,
                                CupertinoPageRoute(builder: (context) {
                              return CusHistory(
                                addressCus: cusAddress.data()["digital_wallet"],
                              );
                            }));
                          });
                        },
                        icon: const Icon(
                          Icons.assignment,
                          size: 23.5,
                        )),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                SingleChildScrollView(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: IconButton(
                        color: const Color.fromRGBO(118, 115, 217, 1),
                        onPressed: () {
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) {
                            return CustomerInfo();
                          }));
                        },
                        icon: const Icon(
                          Icons.person,
                          size: 23.5,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 371,
              height: 50,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(241, 241, 241, 1),
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
              padding: const EdgeInsets.only(left: 20),
              child: const TextField(
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'ค้นหา',
                    icon: Icon(
                      Icons.search_outlined,
                      size: 30,
                      color: Color.fromRGBO(178, 178, 178, 1),
                    ),
                    hintStyle: TextStyle(
                        fontSize: 20,
                        fontFamily: 'NotoSansThai-Regular',
                        color: Color.fromRGBO(178, 178, 178, 1))),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, top: 20),
              child: const Text(
                "ร้านอาหาร:",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NotoSansThai-Regular'),
              ),
            ),
            Container(
              //query ข้อมูลร้านอาหารจาก firebase
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("restuarants")
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  //แสดง listview
                  return ListView(
                    shrinkWrap: true,
                    children: snapshot.data!.docs.map((document) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) {
                            return CustomerViewMenu(
                              resId: document["restuarant_id"],
                              menuId: '',
                              menuName: '',
                              menuPrice: 0,
                              quantity: 0,
                              resName: document["restuarant_name"],
                              resTel: '',
                              resAddress: document["restuarant_address"],
                              digitalWallet: document["private_digital_wallet"],
                              uriPicture: '',
                            );
                          }));
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              child: ListTile(
                                title: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      child: Image.asset(
                                        "images/Reslogo.png",
                                        width: 70,
                                      ),
                                    ),
                                    Container(
                                        margin: const EdgeInsets.only(top: 12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              document["restuarant_name"],
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily:
                                                      'NotoSansThai-Regular'),
                                            ),
                                            Text(document["restuarant_address"],
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                        'NotoSansThai-Regular')),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: SizedBox(
                                width: 380,
                                height: 2,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(233, 233, 233, 1)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
