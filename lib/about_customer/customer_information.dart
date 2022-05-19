// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectfood/about_customer/customer.dart';
import 'package:projectfood/about_customer/customer_account_information.dart';
import 'package:projectfood/about_customer/customer_edit_information.dart';
import 'package:projectfood/about_customer/customer_home.dart';
import 'package:projectfood/about_customer/customer_login.dart';
import 'package:projectfood/main.dart';
import 'package:projectfood/widgets/customshape.dart';

// ignore: use_key_in_widget_constructors
class CustomerInfo extends StatefulWidget {
  @override
  _CustomerInfoState createState() => _CustomerInfoState();
}

class _CustomerInfoState extends State<CustomerInfo> {
  var firebaseUser = FirebaseAuth
      .instance.currentUser; //เก็บ uid สำหรับ account ที่กำลัง login
  final auth = FirebaseAuth.instance; //ใช้ตัวแปรนี้สำหรับ logout

  //เป็นส่วนของ UI แสดงผลบนหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(37, 37, 37, 1),
      appBar: AppBar(
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
            Navigator.pop(context, CupertinoPageRoute(builder: (context) {
              return CustomerHome();
            }));
          },
        ),
        title: Container(
          alignment: Alignment.center,
          child: const Text(
            "ข้อมูลส่วนตัว",
            style: TextStyle(fontFamily: 'NotoSansThai-Medium'),
          ),
          width: 165,
          height: 37,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: const Color.fromRGBO(118, 115, 217, 1),
          ),
        ),
      ),
      // query ข้อมูลจาก firebase ไปแสดงเป็น listview
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("customers")
            .where("customer_id", isEqualTo: firebaseUser?.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            color: Colors.white,
            child: ListView(
              children: snapshot.data!.docs.map((document) {
                return Column(
                  children: [
                    Container(
                      child: ClipPath(
                        clipper: Customshape(),
                        child: Container(
                          height: 220,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.elliptical(
                                      MediaQuery.of(context).size.width, 100)),
                              color: const Color.fromRGBO(37, 37, 37, 1)),
                          child: SingleChildScrollView(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    CupertinoPageRoute(builder: (context) {
                                  return CustomerEditInfo(
                                    customerId: document["customer_id"],
                                    customerAddress:
                                        document["customer_address"],
                                    customerName: document["customer_name"],
                                    customerTel: document["customer_tel"],
                                  );
                                }));
                              },
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 10, top: 10),
                                          width: 80,
                                          child: Image.asset(
                                            "images/profile.png",
                                            width: 50,
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 20),
                                          child: Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      document["customer_name"],
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'NotoSansThai-Regular'),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 270,
                                                          child: Text(
                                                            document[
                                                                "customer_address"],
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'NotoSansThai-Regular'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: SizedBox(
                                                      width: 270,
                                                      height: 2,
                                                      child: DecoratedBox(
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 100,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (context) {
                          return AccountInfo(
                            digitalWallet: document["digital_wallet"],
                            privateWallet: document["private_digital_wallet"],
                          );
                        }));
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.assignment_ind_rounded,
                                size: 35,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "บัญชี",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'NotoSansThai-Regular'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: SizedBox(
                        width: 370,
                        height: 1,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(233, 233, 233, 1)),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.assignment,
                                size: 35,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "ประวัติการสั่งซื้อ",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'NotoSansThai-Regular'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: SizedBox(
                        width: 370,
                        height: 1,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(233, 233, 233, 1)),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        auth.signOut().then((value) {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return const Customer();
                          }));
                        });
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.logout,
                                size: 35,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "ออกจากระบบ",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'NotoSansThai-Regular'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: SizedBox(
                        width: 370,
                        height: 1,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(233, 233, 233, 1)),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
