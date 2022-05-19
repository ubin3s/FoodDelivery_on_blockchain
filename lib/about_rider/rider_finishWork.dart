// ignore_for_file: prefer_const_constructors_in_immutables, file_names, use_key_in_widget_constructors, avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:projectfood/about_rider/rider_home.dart';

class RiderFinish extends StatefulWidget {
  final String menuName;
  final String menuPrice;
  final String qty;

  RiderFinish(
      {required this.menuName, required this.menuPrice, required this.qty});

  @override
  State<RiderFinish> createState() => _RiderFinishState();
}

class _RiderFinishState extends State<RiderFinish> {
  int costDelivery = 10;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(55, 60, 75, 1),
      appBar: AppBar(
        centerTitle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color.fromRGBO(255, 191, 64, 1),
        toolbarHeight: 80,
        automaticallyImplyLeading: true,
        title: Container(
          alignment: Alignment.center,
          child: const Text(
            "สรุปคำสั่งซื้อ ",
            style: TextStyle(fontFamily: 'NotoSansThai-Regular'),
          ),
          width: 165,
          height: 37,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: const Color.fromRGBO(118, 115, 217, 1),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 371,
              height: 118,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 10),
                    child: const Text(
                      "รายได้ของคุณ",
                      style: TextStyle(
                          fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 10),
                    child: const Text(
                      "40 THB",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NotoSansThai-Regular'),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 371,
              height: 131,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 10),
                    child: const Text(
                      "รายการอาหาร",
                      style: TextStyle(
                          fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: SizedBox(
                        width: 350,
                        height: 1,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(233, 233, 233, 1)),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "${widget.qty}x",
                            style: const TextStyle(
                                fontSize: 20,
                                fontFamily: 'NotoSansThai-Regular'),
                          ),
                        ),
                        Container(
                          width: 250,
                          margin: const EdgeInsets.only(right: 20),
                          child: Text(
                            widget.menuName,
                            style: const TextStyle(
                                fontSize: 20,
                                fontFamily: 'NotoSansThai-Regular'),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: Text(
                            "${int.parse(widget.menuPrice).toInt() - costDelivery} ",
                            style: const TextStyle(
                                fontSize: 20,
                                fontFamily: 'NotoSansThai-Regular'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 371,
              height: 160,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10, top: 10),
                        child: const Text(
                          "ราคาอาหาร",
                          style: TextStyle(
                              fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 10, top: 10),
                        child: Text(
                          "${int.parse(widget.menuPrice).toInt() - costDelivery}",
                          style: const TextStyle(
                              fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10, top: 10),
                        child: const Text(
                          "ค่าจัดส่ง",
                          style: TextStyle(
                              fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 10, top: 10),
                        child: Text(
                          costDelivery.toString(),
                          style: const TextStyle(
                              fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: SizedBox(
                        width: 350,
                        height: 1,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(233, 233, 233, 1)),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10, top: 10),
                        child: const Text(
                          "ราคาทั้งหมด",
                          style: TextStyle(
                              fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 10, top: 10),
                        child: Text(
                          widget.menuPrice,
                          style: const TextStyle(
                              fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
            color: const Color.fromRGBO(44, 47, 57, 1),
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(44, 47, 57, 1).withOpacity(0.5),
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
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 16,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return RiderHome();
                            }));
                          },
                          child: Container(
                            width: 318,
                            height: 249,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  child: Image.asset(
                                    "images/success.png",
                                    width: 80,
                                  ),
                                ),
                                Container(
                                  child: const Text(
                                    "เสร็จสิ้น",
                                    style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'NotoSansThai-Regular',
                                        color: Color.fromRGBO(255, 191, 64, 1)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
              child: const Text(
                "จบงานจัดส่งอาหาร",
                style:
                    TextStyle(fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
              )),
        ),
      ),
    );
  }
}
