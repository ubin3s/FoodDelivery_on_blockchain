// ignore_for_file: prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projectfood/about_customer/customer_information.dart';
import 'package:projectfood/widgets/customshape.dart';

class CustomerEditInfo extends StatefulWidget {
  //ประกาศ Constructor สำหรับรับค่าจากหน้าอื่น
  final customerId;
  final customerName;
  final customerAddress;
  final customerTel;

  // ignore: use_key_in_widget_constructors
  const CustomerEditInfo(
      {required this.customerId,
      required this.customerName,
      required this.customerAddress,
      required this.customerTel});

  @override
  _CustomerEditInfoState createState() => _CustomerEditInfoState();
}

class _CustomerEditInfoState extends State<CustomerEditInfo> {
  //ประกาศตัวแปรเพื่อนำมารับค่า
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerAddressController = TextEditingController();
  TextEditingController customerTelController = TextEditingController();

//set ค่าที่รับมาให้กับตัวแปร
  @override
  void initState() {
    super.initState();
    customerNameController.text = widget.customerName;
    customerAddressController.text = widget.customerAddress;
    customerTelController.text = widget.customerTel;
  }

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
            Navigator.pop(context, MaterialPageRoute(builder: (context) {
              return CustomerInfo();
            }));
          },
        ),
        title: Container(
          alignment: Alignment.center,
          child: const Text(
            "แก้ไขข้อมูลส่วนตัว",
            style: TextStyle(fontFamily: 'NotoSansThai-Medium'),
          ),
          width: 189,
          height: 37,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: const Color.fromRGBO(118, 115, 217, 1),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: ClipPath(
                  clipper: Customshape(),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 25),
                        width: 450,
                        height: 220,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.elliptical(
                                    MediaQuery.of(context).size.width, 100)),
                            color: const Color.fromRGBO(37, 37, 37, 1)),
                        child: Image.asset(
                          "images/profile.png",
                          scale: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                // ignore: prefer_const_constructors
                margin: EdgeInsets.only(left: 25, right: 25),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "ชื่อลูกค้า",
                        style: TextStyle(
                            fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 371,
                        height: 50,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(241, 241, 241, 1),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextField(
                          style: const TextStyle(
                            color: Color.fromRGBO(88, 88, 88, 1),
                            fontSize: 18,
                            fontFamily: 'NotoSansThai-Regular',
                          ),
                          controller: customerNameController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: "ชื่อลูกค้า",
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: 20,
                                fontFamily: 'NotoSansThai-Regular',
                                color: Color.fromRGBO(88, 88, 88, 1)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "ที่อยู่",
                        style: TextStyle(
                            fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 371,
                        height: 50,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(241, 241, 241, 1),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextField(
                          style: const TextStyle(
                              color: Color.fromRGBO(88, 88, 88, 1),
                              fontFamily: 'NotoSansThai-Regular',
                              fontSize: 18),
                          controller: customerAddressController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: 20,
                                fontFamily: 'NotoSansThai-Regular',
                                color: Color.fromRGBO(88, 88, 88, 1)),
                            hintText: "ที่อยู่",
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "เบอร์โทรศัพท์",
                        style: TextStyle(
                            fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 371,
                        height: 50,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(241, 241, 241, 1),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextField(
                          style: const TextStyle(
                              color: Color.fromRGBO(88, 88, 88, 1),
                              fontFamily: 'NotoSansThai-Regular',
                              fontSize: 18),
                          controller: customerTelController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: 20,
                                fontFamily: 'NotoSansThai-Regular',
                                color: Color.fromRGBO(88, 88, 88, 1)),
                            hintText: "เบอร์โทรศัพท์",
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          )
        ]),
        child: Container(
          margin: const EdgeInsets.all(17),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color.fromRGBO(0, 177, 62, 1),
              ),
              onPressed: () {
                //ฟังก์ชัน update ข้อมูลลงไปใน Firebase
                FirebaseFirestore.instance
                    .collection("customers")
                    .doc(widget.customerId)
                    .update({
                  "customer_name": customerNameController.text,
                  "customer_address": customerAddressController.text,
                  "customer_tel": customerTelController.text,
                });
                Navigator.pop(context);
              },
              child: const Text(
                "แก้ไข",
                style:
                    TextStyle(fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
              )),
        ),
      ),
    );
  }
}
