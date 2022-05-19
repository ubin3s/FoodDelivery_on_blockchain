// ignore_for_file: prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projectfood/about_rider/rider_information.dart';
import 'package:projectfood/widgets/customshape.dart';

class RiderEditInfo extends StatefulWidget {
  final riderId;
  final riderName;
  final riderCarModel;
  final riderTel;
  final riderlicensePlate;

  // ignore: use_key_in_widget_constructors
  const RiderEditInfo(
      {required this.riderId,
      required this.riderName,
      required this.riderCarModel,
      required this.riderTel,
      required this.riderlicensePlate});

  @override
  _RiderEditInfoState createState() => _RiderEditInfoState();
}

class _RiderEditInfoState extends State<RiderEditInfo> {
  TextEditingController riderNameController = TextEditingController();
  TextEditingController riderCarModelController = TextEditingController();
  TextEditingController riderTelController = TextEditingController();
  TextEditingController riderlicensePlateController = TextEditingController();

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    riderNameController.text = widget.riderName;
    riderTelController.text = widget.riderTel;
    riderCarModelController.text = widget.riderCarModel;
    riderlicensePlateController.text = widget.riderlicensePlate;
  }

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
              return RiderInfo();
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
                margin: const EdgeInsets.only(left: 25, right: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "ชื่อผู้ใช้งาน",
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
                        controller: riderNameController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontSize: 20,
                              fontFamily: 'NotoSansThai-Regular',
                              color: Color.fromRGBO(88, 88, 88, 1)),
                          hintText: "ชื่อพนักงานขนส่งอาหาร",
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
                        controller: riderTelController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "เบอร์โทรศัพท์",
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
                      "ยี่ห้อรถ",
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
                        controller: riderCarModelController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: "ยี่ห้อรถ",
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
                      "หมายเลขทะเบียนรถ",
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
                        controller: riderlicensePlateController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: "หมายเลขทะเบียนรถ",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontSize: 20,
                              fontFamily: 'NotoSansThai-Regular',
                              color: Color.fromRGBO(88, 88, 88, 1)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
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
                FirebaseFirestore.instance
                    .collection("Riders")
                    .doc(widget.riderId)
                    .update({
                  "rider_name": riderNameController.text,
                  "rider_tel": riderTelController.text,
                  "rider_car_model": riderCarModelController.text,
                  "rider_license_plate": riderlicensePlateController.text
                });
                Navigator.pop(context);
              },
              child: const Text(
                "ยืนยัน",
                style:
                    TextStyle(fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
              )),
        ),
      ),
    );
  }
}
