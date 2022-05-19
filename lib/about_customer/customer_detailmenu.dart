// ignore_for_file: use_key_in_widget_constructors, avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectfood/about_customer/customer_viewmenu.dart';

class DetailMenu extends StatefulWidget {
  //ประกาศ Structor เพื่อรับค่าจากหน้าอื่น
  final String menuId;
  final String menuName;
  final String resId;
  final String resName;
  final String resTel;
  final int menuPrice;
  final String digitalWallet;
  final String uriPicture;

  const DetailMenu(
      {required this.menuId,
      required this.menuName,
      required this.menuPrice,
      required this.resId,
      required this.resName,
      required this.resTel,
      required this.digitalWallet,
      required this.uriPicture});
  @override
  _DetailMenuState createState() => _DetailMenuState();
}

class _DetailMenuState extends State<DetailMenu> {
  int quantity = 1; //เป็นค่า state ไว้บวกเพิ่มจำนวน
  late var list = [
    DetailMenu(
      menuName: widget.menuName,
      menuPrice: widget.menuPrice,
      resId: widget.resId,
      menuId: widget.menuId,
      resName: widget.resName,
      resTel: widget.resTel,
      digitalWallet: widget.digitalWallet,
      uriPicture: widget.uriPicture,
    )
  ]; // list ข้อมูลของรายละเอียดเมนู

  //เป็นส่วนของ UI แสดงผลของหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
        appBar: AppBar(
          centerTitle: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color.fromRGBO(255, 191, 64, 1),
          toolbarHeight: 80,
          leading: IconButton(
            icon: const Icon(
              Icons.close,
              size: 32,
            ),
            onPressed: () {
              // action กดปุ่มแล้วเปลี่ยนหน้า
              Navigator.pop(context, CupertinoPageRoute(builder: (context) {
                return const CustomerViewMenu(
                  menuId: '',
                  menuName: '',
                  menuPrice: 0,
                  quantity: 0,
                  resId: '',
                  resAddress: '',
                  resName: '',
                  resTel: '',
                  digitalWallet: '',
                  uriPicture: '',
                );
              }));
            },
          ),
          title: Container(
            alignment: Alignment.center,
            child: const Text(
              "รายละเอียดอาหาร",
              style: TextStyle(fontSize: 20, fontFamily: 'NotoSansThai-Medium'),
            ),
            width: 180,
            height: 37,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: const Color.fromRGBO(118, 115, 217, 1),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 220,
                width: 420,
                child: Image.network(
                  widget.uriPicture,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                color: Colors.white,
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.menuName,
                        style: const TextStyle(
                            fontSize: 25, fontFamily: 'NotoSansThai-Regular'),
                      ),
                      Text(
                        "${widget.menuPrice * quantity} บาท",
                        style: const TextStyle(
                            fontSize: 30, fontFamily: 'NotoSansThai-Regular'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.white,
                height: 340,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20, top: 20),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "หมายเหตุถึงร้านอาหาร",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'NotoSansThai-Regular'),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10, top: 25),
                          child: const Text(
                            "ไม่จำเป็นต้องระบุ",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'NotoSansThai-Regular',
                                color: Color.fromRGBO(174, 174, 174, 1)),
                          ),
                        )
                      ],
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
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      child: const TextField(
                        decoration:
                            InputDecoration(labelText: "ระบุรายละเอียดคำขอ"),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20, left: 140),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              //ลดจำนวน
                              setState(() {
                                if (quantity > 1) quantity--;
                              });
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color.fromRGBO(
                                          219, 219, 219, 1)),
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Icon(
                                Icons.remove,
                                color: Color.fromRGBO(255, 191, 64, 1),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "$quantity",
                            style: const TextStyle(
                                fontSize: 30,
                                fontFamily: 'NotoSansThai-Regular'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              //บวกเพิ่มจำนวน
                              setState(() {
                                quantity++;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 150),
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color.fromRGBO(
                                          219, 219, 219, 1)),
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Icon(
                                Icons.add,
                                color: Color.fromRGBO(255, 191, 64, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
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
                  // action กดปุ่มแล้วเปลี่ยนหน้า
                  Navigator.pushReplacement(context,
                      CupertinoPageRoute(builder: (context) {
                    return CustomerViewMenu(
                      resId: widget.resId,
                      menuId: widget.menuId,
                      menuName: widget.menuName,
                      menuPrice: widget.menuPrice,
                      quantity: quantity,
                      resName: widget.resName,
                      resTel: widget.resTel,
                      resAddress: '',
                      digitalWallet: widget.digitalWallet,
                      uriPicture: widget.uriPicture,
                    );
                  }));
                },
                child: const Text(
                  "เพิ่มในตะกร้า",
                  style: TextStyle(
                      fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
                )),
          ),
        ));
  }
}
