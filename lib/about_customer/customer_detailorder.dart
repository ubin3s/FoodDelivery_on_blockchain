//ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, non_constant_identifier_names, avoid_unnecessary_containers, duplicate_ignore, sized_box_for_whitespace, unnecessary_brace_in_string_interps

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:projectfood/about_customer/customer_home.dart';

import 'package:web3dart/web3dart.dart' as web3dart;

class DetailOrder extends StatefulWidget {
  //ประกาศ Constructor เพื่อรับค่าจากหน้าอื่น
  final String digitalWallet;
  final String customerName;
  final String customerTel;
  final String address;
  final String menuName;
  final String resName;
  final String resTel;
  final int menuPrice;
  final int quantity;
  final String shipping_cost;
  final bool pressed;
  const DetailOrder(
      {required this.digitalWallet,
      required this.customerName,
      required this.address,
      required this.menuName,
      required this.menuPrice,
      required this.quantity,
      required this.customerTel,
      required this.resName,
      required this.resTel,
      required this.shipping_cost,
      required this.pressed});

  @override
  _DetailOrderState createState() => _DetailOrderState();
}

class _DetailOrderState extends State<DetailOrder> {
  late Client httpClient;
  late web3dart.Web3Client ethClient;
  bool data = false;
  bool statusCooking = false;
  bool statusCookingFail = false;
  bool statusShipping = false;
  bool statusDelivary = false;

  List<dynamic> _statusCooking =
      []; //เก็บข้อมูลสถานะการทำอาหารของร้านอาหารที่อยู่ในบล็อกเชน
  List<dynamic> _statusShipping =
      []; //เก็บข้อมูลสถานะการรับอาหารของพนักงานขนส่งอาหารที่อยู่ในบล็อกเชน
  List<dynamic> _statusDelivery =
      []; //เก็บข้อมูลสถานะการทำส่งอาหารของพนักงานขนส่งอาหารที่อยู่ในบล็อกเชน
  List<dynamic> _statusAccept =
      []; //เก็บข้อมูลสถานะการรับอาหารของร้านอาหารที่อยู่ใยบล็อกเชน
  List<dynamic> amoutMenu = [];

  late Timer timer;
  bool isShow = true; //boolean มีไว้เพื่อเป็นเงื่อนไขในการเเสดง widget

  var myData;
  final myAddress =
      "0x0b2194Fde4B6D32f23331C12EA21c4B7c06efCa3"; //หมายเลขกระเป๋าตัง
  @override

  //Set ค่าตั้งต้นในการเชื่อมต่อ Infura
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = web3dart.Web3Client(
        "https://kovan.infura.io/v3/ea6f8a087ef041da9aa38a52779c1af3",
        httpClient);

    // Timer query ข้อมูลทุกๆ 15 วินาที
    Timer.periodic(Duration(seconds: 15), (timer) {
      getOrderCustomer(myAddress);
      if (statusDelivary == true) {
        timer.cancel();
      }

      //เป็นเงื่อนไขในการหยุด query
      if (statusCookingFail == true) {
        timer.cancel();
      }
    });
  }

  //load smartcontract
  Future<web3dart.DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("lib/assets/abi.json");
    String contractAddress = "0xF1820c9873aEd059809c0B2CFa8031F8B67C5249";
    final contract = web3dart.DeployedContract(
        web3dart.ContractAbi.fromJson(abi, "FoodDelivery"),
        web3dart.EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  //เรียกใช้การ query ข้อมูลจาก smartcontract
  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
        contract: contract, function: ethFunction, params: args);

    return result;
  }

  //ฟังก์ชัน query ข้อมูลต่าง ๆ มาเก็บไว้ในตัวแปร
  Future<void> getOrderCustomer(String targetAddress) async {
    //query จำนวนเมนูทั้งหมด
    amoutMenu = await query("nextId", []);

    //query ข้อมูลของฟังก์ชัน readOrderRider จากบล็อกเชน
    for (int i = 0; i < amoutMenu[0].toInt(); i++) {
      List<dynamic> result = await query("readOrderRider", [BigInt.from(i)]);
      _statusCooking.add(result);
      _statusShipping.add(result);
      _statusDelivery.add(result);
      print(_statusDelivery.length);
      print(_statusShipping.length);
      print("${_statusCooking.length}");
    }

    //query ข้อมูลของฟังก์ชัน readOrderRestaurant จากบล็อกเชน
    for (int i = 0; i < amoutMenu[0].toInt(); i++) {
      List<dynamic> result =
          await query("readOrderRestaurant", [BigInt.from(i)]);
      _statusAccept.add(result);
      print(_statusAccept.length);
    }

    int amountOrder = _statusCooking.length - 1; //นับจำนวนเมนูในบล็อกเชน

    print("สุทธิ${amountOrder}");
    print("สถานะทำอาหาร${_statusCooking}");
    print("สถานะกำลังจัดส่ง${_statusShipping}");
    print("สถานะส่งอาหารแล้ว${_statusDelivery}");

//ในกรณีอาหารหมดให้แสดง popup และแสดงคำว่าอาหารหมด
    if (_statusAccept[amountOrder][4].toString() == 2.toString()) {
      setState(() {
        statusCookingFail = true;
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
                      return CustomerHome();
                    }));
                  },
                  child: Container(
                    width: 318,
                    height: 249,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: const Text(
                            "อาหารหมด",
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'NotoSansThai-Regular',
                                color: Colors.red),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
      });
    }

    //เปลี่ยนสี status การติดตามอาหารของหน้าจอลูกค้า
    if (_statusCooking[amountOrder][3].toString() != 0.toString()) {
      Timer(Duration(seconds: 1), () {
        setState(() {
          statusCooking = true;
          print("กำลังทำอาหาร");
        });
      });
    }
    if (_statusShipping[amountOrder][5].toString() != 0.toString()) {
      Timer(Duration(seconds: 1), () {
        setState(() {
          statusShipping = true;
          print("กำลังจัดส่ง");
        });
      });
    }
    if (_statusDelivery[amountOrder][8].toString() == '1' ||
        _statusDelivery[amountOrder][8].toString() == '2') {
      setState(() {
        statusDelivary = true;
        print("ส่งสำเร็จ");
      });
    }

    data = true;
  }

//เป็นส่วนของ UI แสดงผลบนหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      appBar: AppBar(
        centerTitle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color.fromRGBO(255, 191, 64, 1),
        toolbarHeight: 80,
        title: Container(
          alignment: Alignment.center,
          child: const Text(
            "คำสั่งซื้อ",
            style: TextStyle(fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
          ),
          width: 180,
          height: 37,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: const Color.fromRGBO(118, 115, 217, 1),
          ),
        ),
      ),
      body: Container(
          child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                "เวลารออาหารประมาณ",
                style:
                    TextStyle(fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text(
                "30 นาที",
                style:
                    TextStyle(fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    "สั่งอาหาร",
                    style: TextStyle(
                        fontSize: 14, fontFamily: 'NotoSansThai-Regular'),
                  ),
                  width: 90,
                  height: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color.fromRGBO(114, 209, 118, 1)),
                ),
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    "ทำอาหาร",
                    style: TextStyle(
                        fontSize: 14, fontFamily: 'NotoSansThai-Regular'),
                  ),
                  width: 90,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: statusCooking
                        ? const Color.fromRGBO(114, 209, 118, 1)
                        : const Color.fromRGBO(232, 232, 232, 1),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    "กำลังจัดส่ง",
                    style: TextStyle(
                        fontSize: 14, fontFamily: 'NotoSansThai-Regular'),
                  ),
                  width: 90,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: statusShipping
                        ? const Color.fromRGBO(114, 209, 118, 1)
                        : const Color.fromRGBO(232, 232, 232, 1),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    "ส่งอาหารแล้ว",
                    style: TextStyle(
                        fontSize: 14, fontFamily: 'NotoSansThai-Regular'),
                  ),
                  width: 90,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: statusDelivary
                        ? const Color.fromRGBO(114, 209, 118, 1)
                        : const Color.fromRGBO(232, 232, 232, 1),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              width: 391,
              height: 131,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      "สรุปคำสั่งซื้อ",
                      style: TextStyle(
                          fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          "${widget.quantity.toString()}x",
                          style: TextStyle(
                              fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
                        ),
                      ),
                      Container(
                        width: 290,
                        child: Text(
                          widget.menuName,
                          style: TextStyle(
                              fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
                        ),
                      ),
                      Container(
                        child: Text(
                          "${widget.menuPrice - int.parse(widget.shipping_cost)}",
                          style: TextStyle(
                              fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              width: 391,
              height: 180,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          "รวมค่าอาหารทั้งหมด",
                          style: TextStyle(
                              fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
                        ),
                      ),
                      Container(
                        child: Text(
                          "${widget.menuPrice - int.parse(widget.shipping_cost)}",
                          style: TextStyle(
                              fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          "ค่าจัดส่ง",
                          style: TextStyle(
                              fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
                        ),
                      ),
                      Container(
                        child: Text(
                          widget.shipping_cost,
                          style: TextStyle(
                              fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
                        ),
                      )
                    ],
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          "ราคาทั้งหมด",
                          style: TextStyle(
                              fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
                        ),
                      ),
                      Container(
                        child: Text(
                          "${widget.menuPrice}",
                          style: TextStyle(
                              fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
      bottomNavigationBar: Container(
        height: 160,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          )
        ]),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              width: 371,
              height: 51,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(255, 77, 77, 1),
                  ),
                  onPressed: () async {
                    String status = "2";
                    var menuID = int.parse(amoutMenu[0].toString()) - 1;

                    var firebaseUser = FirebaseAuth.instance
                        .currentUser; //เก็บ uid สำหรับ account ที่กำลัง login

                    //query ข้อมูลจาก firebase
                    var result = await FirebaseFirestore.instance
                        .collection("customers")
                        .where("customer_id", isEqualTo: firebaseUser!.uid)
                        .get();
                    // ignore: avoid_function_literals_in_foreach_calls, non_constant_identifier_names
                    result.docs.forEach((customer_data) {
                      //ฟังก์ชันสำหรับการให้ลูกค้ากดยืนยันการได้รับอาหารจากพนักงานขนส่งอาหาร
                      customerAcceptFail(BuildContext context) async {
                        web3dart.EthPrivateKey credentials = web3dart
                            .EthPrivateKey.fromHex(customer_data
                                .data()[
                            "private_digital_wallet"]); //แปลงข้อมูล privatekey ของร้านอาหารให้อยู่ใน type ที่ใช้งานได้กับบล็อกเชน
                        var apiurl =
                            "https://kovan.infura.io/v3/ea6f8a087ef041da9aa38a52779c1af3"; //เก็บ url ของ infura
                        var ethClient = web3dart.Web3Client(apiurl, httpClient);
                        web3dart.DeployedContract contract =
                            await loadContract(); //load smartcontract
                        final ethFunction = contract.function(
                            "customerAccept"); //set ชื่อฟังก์ชันที่จะเชื่อมต่อกับ smartcontract

                        //ส่งข้อมูลเข้า smartcontract ผ่าน parameter
                        var result = await ethClient.sendTransaction(
                            credentials,
                            web3dart.Transaction.callContract(
                                maxGas: 800000,
                                contract: contract,
                                function: ethFunction,
                                parameters: [
                                  BigInt.tryParse(menuID.toString()),
                                  BigInt.tryParse(status)
                                ]),
                            chainId: 42);

                        return result;
                      }

                      //เรียกใช้ฟังก์ชัน
                      customerAcceptFail(context);
                      print(customerAcceptFail(context).runtimeType);
                    });
                    setState(() {
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
                                    return CustomerHome();
                                  }));
                                },
                                child: Container(
                                  width: 318,
                                  height: 249,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 20),
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
                                              fontFamily:
                                                  'NotoSansThai-Regular',
                                              color: Color.fromRGBO(
                                                  255, 191, 64, 1)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    });
                  },
                  child: const Text(
                    "ยังไม่ได้รับอาหาร",
                    style: TextStyle(
                        fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
                  )),
            ),
            Container(
              width: 371,
              height: 51,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(0, 177, 62, 1),
                  ),
                  onPressed: () async {
                    String status = "1";
                    var menuID = int.parse(amoutMenu[0].toString()) - 1;

                    var firebaseUser = FirebaseAuth.instance
                        .currentUser; //เก็บ uid สำหรับ account ที่กำลัง login

                    //query ข้อมูลจาก firebase
                    var result = await FirebaseFirestore.instance
                        .collection("customers")
                        .where("customer_id", isEqualTo: firebaseUser!.uid)
                        .get();
                    // ignore: avoid_function_literals_in_foreach_calls, non_constant_identifier_names
                    result.docs.forEach((customer_data) {
                      //ฟังก์ชันสำหรับการให้ลูกค้ากดยืนยันการได้รับอาหารจากพนักงานขนส่งอาหาร
                      customerAccept(BuildContext context) async {
                        web3dart.EthPrivateKey credentials = web3dart
                            .EthPrivateKey.fromHex(customer_data
                                .data()[
                            "private_digital_wallet"]); //แปลงข้อมูล privatekey ของร้านอาหารให้อยู่ใน type ที่ใช้งานได้กับบล็อกเชน
                        var apiurl =
                            "https://kovan.infura.io/v3/ea6f8a087ef041da9aa38a52779c1af3"; //เก็บ url ของ infura
                        var ethClient = web3dart.Web3Client(apiurl, httpClient);
                        web3dart.DeployedContract contract =
                            await loadContract(); //load smartcontract
                        final ethFunction = contract.function(
                            "customerAccept"); //set ชื่อฟังก์ชันที่จะเชื่อมต่อกับ smartcontract

                        //ส่งข้อมูลเข้า smartcontract ผ่าน parameter
                        var result = await ethClient.sendTransaction(
                            credentials,
                            web3dart.Transaction.callContract(
                                maxGas: 800000,
                                contract: contract,
                                function: ethFunction,
                                parameters: [
                                  BigInt.tryParse(menuID.toString()),
                                  BigInt.tryParse(status)
                                ]),
                            chainId: 42);

                        return result;
                      }

                      //เรียกใช้ฟังก์ชัน
                      customerAccept(context);
                      print(customerAccept(context).runtimeType);
                    });
                    //show dialog และแสดงข้อความว่าเสร็จสิ้น
                    setState(() {
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
                                    return CustomerHome();
                                  }));
                                },
                                child: Container(
                                  width: 318,
                                  height: 249,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 20),
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
                                              fontFamily:
                                                  'NotoSansThai-Regular',
                                              color: Color.fromRGBO(
                                                  255, 191, 64, 1)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    });

                    // setState(() {
                    //   pressed1 = !pressed1;
                    //   pressed2 = !pressed2;
                    // });
                  },
                  child: const Text(
                    "ได้รับอาหารแล้ว",
                    style: TextStyle(
                        fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
