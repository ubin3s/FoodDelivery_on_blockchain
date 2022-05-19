// ignore_for_file: use_key_in_widget_constructors, prefer_collection_literals, unused_element, non_constant_identifier_names, duplicate_ignore, prefer_typing_uninitialized_variables, unnecessary_brace_in_string_interps, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:projectfood/about_customer/customer_detailorder.dart';
import 'package:projectfood/about_customer/customer_viewmenu.dart';
import 'package:web3dart/web3dart.dart' as web3dart;

class Cart extends StatefulWidget {
  //ประกาศ Constructor เพื่อรับค่าจากหน้าอื่น

  final String menuName;
  final String resId;
  final String resName;
  final String resTel;
  final String menuId;
  final int menuPrice;
  final int quantity;
  final String digitalWallet;
  final String uriPicture;

  const Cart(
      {required this.menuName,
      required this.menuPrice,
      required this.quantity,
      required this.resId,
      required this.menuId,
      required this.resName,
      required this.resTel,
      required this.digitalWallet,
      required this.uriPicture});

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  int deliveryCost = 10;
  bool data = false;

  late Client httpClient;
  late web3dart.Web3Client ethClient;
  final myAddress =
      "0x0b2194Fde4B6D32f23331C12EA21c4B7c06efCa3"; //หมายเลขกระเป๋าตัง Customer

  //Set ค่าตั้งต้นสำหรับเชื่อมต่อ blockchain ผ่าน Infura
  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = web3dart.Web3Client(
        "https://kovan.infura.io/v3/ea6f8a087ef041da9aa38a52779c1af3",
        httpClient);
  }

  // ฟังก์ชันเชื่อมต่อกับ Smart Contract
  Future<web3dart.DeployedContract> loadContract() async {
    String abi = await rootBundle
        .loadString("lib/assets/abi.json"); // load smartcontract จากไฟล์ json
    String contractAddress =
        "0xF1820c9873aEd059809c0B2CFa8031F8B67C5249"; //contractAddress

    final contract = web3dart.DeployedContract(
        web3dart.ContractAbi.fromJson(abi, "FoodDelivery"), //ชื่อ Smartcontract
        web3dart.EthereumAddress.fromHex(contractAddress));

    return contract;
  }

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
          title: Container(
            alignment: Alignment.center,
            child: const Text(
              "ตะกร้าสั่งซื้อ",
              style:
                  TextStyle(fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
            ),
            width: 180,
            height: 37,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: const Color.fromRGBO(118, 115, 217, 1),
            ),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop(CupertinoPageRoute(
                    builder: (context) => CustomerViewMenu(
                          resId: widget.resId,
                          menuId: widget.menuId,
                          menuName: widget.menuName,
                          menuPrice: widget.menuPrice,
                          quantity: widget.quantity,
                          resName: widget.resName,
                          resTel: widget.resTel,
                          resAddress: '',
                          digitalWallet: '',
                          uriPicture: widget.uriPicture,
                        )));
              },
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                color: Colors.white,
                width: 411,
                height: 181,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 20),
                          child: Container(
                            child: Text(
                              widget.resName,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'NotoSansThai-Regular'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // ignore: prefer_const_constructors
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Container(
                                child: const Text(
                                  "ส่งที่: ",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'NotoSansThai-Regular'),
                                ),
                              ),
                              Container(
                                child: const Text(
                                  "222/9 ต.ไทยบุรี อ.ท่าศาลา จ.นครศรีธรรมราช",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'NotoSansThai-Regular'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Container(
                      width: 371,
                      height: 60,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(241, 241, 241, 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: const TextField(
                          style: TextStyle(
                              color: Color.fromRGBO(178, 178, 178, 1),
                              fontSize: 14),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "ระบุที่อยู่ในการจัดส่ง",
                            hintStyle: TextStyle(
                                fontSize: 20,
                                fontFamily: 'NotoSansThai-Regular',
                                color: Color.fromRGBO(178, 178, 178, 1)),
                            prefixIcon: Icon(Icons.pin_drop_outlined),
                          )),
                    )
                  ],
                ),
              ),
              Container(
                height: 450,
                color: Colors.white,
                margin: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 110,
                            height: 70,
                            //  margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage(widget.uriPicture),
                                    fit: BoxFit.cover)),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 200,
                            child: Text(
                              "${widget.quantity} x ${widget.menuName}",
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'NotoSansThai-Regular'),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "${widget.menuPrice * widget.quantity}",
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'NotoSansThai-Regular'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 110,
                            height: 70,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: const DecorationImage(
                                    image:
                                        ExactAssetImage('images/delivery.png'),
                                    fit: BoxFit.cover)),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 100,
                            margin: const EdgeInsets.only(
                              right: 110,
                            ),
                            child: const Text(
                              "ค่าจัดส่ง",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'NotoSansThai-Regular'),
                            ),
                          ),
                          Container(
                            child: Text(
                              "฿${deliveryCost}",
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'NotoSansThai-Regular'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 20),
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
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // ignore: prefer_const_constructors
                              Text(
                                "ราคาทั้งหมด",
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'NotoSansThai-Regular'),
                              ),
                              Text(
                                "฿${deliveryCost + (widget.menuPrice * widget.quantity)} ",
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'NotoSansThai-Regular'),
                              ),
                            ],
                          ),
                        )
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
                onPressed: () async {
                  String status = "0";

                  var firebaseUser = FirebaseAuth.instance
                      .currentUser; //เก็บ uid สำหรับอ้างถึง account ที่กำลัง login อยู่

                  //query ข้อมูลจาก Firebase
                  var result = await FirebaseFirestore.instance
                      .collection("customers")
                      .where("customer_id", isEqualTo: firebaseUser!.uid)
                      .get();
                  result.docs.forEach((customer_data) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return DetailOrder(
                        address: customer_data.data()["customer_address"],
                        customerName: customer_data.data()["customer_name"],
                        digitalWallet: customer_data.data()["digital_wallet"],
                        customerTel: customer_data.data()["customer_tel"],
                        menuName: widget.menuName,
                        menuPrice:
                            (widget.menuPrice * widget.quantity) + deliveryCost,
                        quantity: widget.quantity,
                        resName: widget.resName,
                        resTel: widget.resTel,
                        shipping_cost: '10',
                        pressed: false,
                      );
                    }));

                    // ฟังก์ชัน ส่งค่าเข้า SmartContract
                    insertOrder(BuildContext context) async {
                      var prices = BigInt.from((widget.menuPrice *
                              widget.quantity) +
                          deliveryCost); //คำนวณราคาและแปลงข้อมูลให้อยู่ใน type ที่สามารถส่งข้อมูลเข้าบล็อกเชนได้
                      var qty = BigInt.from(widget
                          .quantity); //แปลงข้อมูลจำนวนอาหารให้อยู่ใน type ที่สามารถส่งเข้าบล็อกเชนได้
                      var addressed = web3dart.EthereumAddress.fromHex(widget
                          .digitalWallet); //แปลงข้อมูล address ของร้านอาหารให้อยู่ใน type ที่สามารถส่งเข้าบล็อกเชนได้

                      web3dart.EthPrivateKey credentials = web3dart
                          .EthPrivateKey.fromHex(customer_data
                              .data()[
                          "private_digital_wallet"]); //แปลงข้อมูล PrivateKey ของลูกค้าให้อยู่ใน type ที่สามารถใช้ได้กับบล็อกเชน
                      var apiurl =
                          "https://kovan.infura.io/v3/ea6f8a087ef041da9aa38a52779c1af3"; //เก็บ url ของ infura
                      var ethClient = web3dart.Web3Client(apiurl, httpClient);
                      web3dart.DeployedContract contract =
                          await loadContract(); // load smartcontract
                      final ethFunction = contract.function(
                          "insertOrder"); //กำหนดชื่อฟังก์ชันที่เราจะทำการส่งข้อมูลเข้าบล็อกเชน

                      //ส่งข้อมุลเข้า smartcontract ผ่าน parameter
                      var result = await ethClient.sendTransaction(
                          credentials,
                          web3dart.Transaction.callContract(
                              maxGas: 800000,
                              contract: contract,
                              function: ethFunction,
                              parameters: [
                                addressed,
                                customer_data.data()["customer_name"],
                                widget.menuName,
                                qty,
                                prices,
                                customer_data.data()["customer_address"],
                                customer_data.data()["customer_tel"],
                                widget.resName,
                                widget.resTel,
                                BigInt.tryParse(status)
                              ]),
                          chainId: 42);

                      print("ลูกค้าสั่งซื้อ");
                      return result;
                    }

                    //เรียกใช้ฟังก์ชัน
                    var futureBuilder = insertOrder(context);
                    print(futureBuilder.runtimeType);
                  });
                },
                child: const Text(
                  "สั่งซื้อ",
                  style: TextStyle(
                      fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
                )),
          ),
        ));
  }
}
