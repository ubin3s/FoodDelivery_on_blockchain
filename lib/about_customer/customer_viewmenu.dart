// prefer_const_constructors_in_immutables
// ignore_for_file: use_key_in_widget_constructors, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, sized_box_for_whitespace, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projectfood/about_customer/customer_cart.dart';
import 'package:projectfood/about_customer/customer_detailmenu.dart';
import 'package:projectfood/about_customer/customer_home.dart';

class CustomerViewMenu extends StatefulWidget {
  //ประกาศ Constructor เพื่อนำมารับค่าจากหน้าอื่น
  final String resId;
  final String resName;
  final String resTel;
  final int quantity;
  final String menuId;
  final String menuName;
  final int menuPrice;
  final String resAddress;
  final String digitalWallet;
  final String uriPicture;

  const CustomerViewMenu(
      {required this.resId,
      required this.resName,
      required this.resTel,
      required this.quantity,
      required this.menuId,
      required this.menuName,
      required this.menuPrice,
      required this.resAddress,
      required this.digitalWallet,
      required this.uriPicture});
  @override
  _CustomerViewMenuState createState() => _CustomerViewMenuState();
}

class _CustomerViewMenuState extends State<CustomerViewMenu> {
  //query รูปภาพจาก firebase
  Future<void> getdataimage() async {
    var result = FirebaseFirestore.instance
        .collection("menus")
        .where("restuarant_menu_id", isEqualTo: widget.resId)
        .get()
        .then((data) => data
          ..docs.forEach((element) {
            element.data()["uriPicture"];
          }));
  }

//เป็นส่วนของ UI แสดงผลบนหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              return CustomerHome();
            }));
          },
        ),
        title: Container(
          alignment: Alignment.center,
          child: const Text(
            "ร้านอาหาร",
            style: TextStyle(fontFamily: 'NotoSansThai-Medium'),
          ),
          width: 165,
          height: 37,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: const Color.fromRGBO(118, 115, 217, 1),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(top: 20, right: 20),
            child: SingleChildScrollView(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: IconButton(
                  color: const Color.fromRGBO(118, 115, 217, 1),
                  icon: const Icon(
                    Icons.shopping_bag_rounded,
                    size: 23.5,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Cart(
                                  menuName: widget.menuName,
                                  menuPrice: widget.menuPrice,
                                  quantity: widget.quantity,
                                  resId: widget.resId,
                                  menuId: widget.menuId,
                                  resName: widget.resName,
                                  resTel: widget.resTel,
                                  digitalWallet: widget.digitalWallet,
                                  uriPicture: widget.uriPicture,
                                )));
                  },
                ),
              ),
            ),
          )
        ],
      ),
      body: Container(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("menus")
                .where("restuarant_menu_id", isEqualTo: widget.resId)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: ExactAssetImage('images/imagefood.jpg'),
                        fit: BoxFit.fitHeight)),
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(
                                    top: 40, left: 20, right: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 7,
                                        offset: const Offset(0, 4),
                                      )
                                    ]),
                                width: 371,
                                height: 180,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  child: Column(
                                    children: [
                                      Text(
                                        widget.resName,
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontFamily: 'NotoSansThai-Regular'),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        widget.resAddress,
                                        maxLines: 10,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'NotoSansThai-Regular'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          margin: const EdgeInsets.only(top: 50),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 7,
                                  offset: const Offset(0, 4),
                                )
                              ]),
                          height: 400,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, top: 20, bottom: 10),
                                  child: const Text(
                                    "รายการอาหาร",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'NotoSansThai-Regular'),
                                  ),
                                ),
                                Container(
                                  child: ListView(
                                    shrinkWrap: true,
                                    children:
                                        snapshot.data!.docs.map((document) {
                                      return Column(
                                        children: [
                                          Container(
                                            child: GestureDetector(
                                              onTap: () async {
                                                var result =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            "restuarants")
                                                        .where("restuarant_id",
                                                            isEqualTo:
                                                                widget.resId)
                                                        .get();
                                                print(result);
                                                result.docs
                                                    .forEach((restuarantData) {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return DetailMenu(
                                                      menuId:
                                                          document["menu_id"],
                                                      menuName:
                                                          document["menu_name"],
                                                      menuPrice: document[
                                                          "menu_price"],
                                                      resId: document[
                                                          "restuarant_menu_id"],
                                                      resName: restuarantData
                                                              .data()[
                                                          "restuarant_name"],
                                                      resTel:
                                                          restuarantData.data()[
                                                              "restuarant_tel"],
                                                      digitalWallet:
                                                          restuarantData.data()[
                                                              "digital_wallet"],
                                                      uriPicture: document[
                                                          "uriPicture"],
                                                    );
                                                  }));
                                                });
                                              },
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 100,
                                                      child: ListTile(
                                                        title: Row(
                                                          children: [
                                                            Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            10),
                                                                child:
                                                                    Container(
                                                                  width: 140,
                                                                  height: 90,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      image: DecorationImage(
                                                                          image: NetworkImage(document[
                                                                              "uriPicture"]),
                                                                          fit: BoxFit
                                                                              .cover)),
                                                                )),
                                                            Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            12),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          bottom:
                                                                              10),
                                                                      child:
                                                                          Text(
                                                                        document[
                                                                            "menu_name"],
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontFamily: 'NotoSansThai-Regular'),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child: Text(
                                                                          document["menu_price"]
                                                                              .toString(),
                                                                          style: const TextStyle(
                                                                              fontSize: 14,
                                                                              fontFamily: 'NotoSansThai-Regular')),
                                                                    ),
                                                                  ],
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10),
                                                      child: SizedBox(
                                                        width: 380,
                                                        height: 2,
                                                        child: DecoratedBox(
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          233,
                                                                          233,
                                                                          233,
                                                                          1)),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
