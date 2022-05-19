// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_const_constructors, unnecessary_string_interpolations, prefer_const_literals_to_create_immutables, non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_unnecessary_containers, sized_box_for_whitespace

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:projectfood/about_customer/customer_home.dart';
import 'package:projectfood/about_restuarant/restuarant_home.dart';
import 'package:web3dart/web3dart.dart';

class ResCooking extends StatefulWidget {
  //ประกาศ Constructor เพื่อรับค่าที่ส้่งมาจากหน้าอื่น
  final String dataMenuname;
  final String MenuPrice;
  final String dataName;
  final String dataqty;
  final String dataId;
  final String dataAddress;
  final String private_digital_wallet;
  ResCooking(
      {required this.dataMenuname,
      required this.MenuPrice,
      required this.dataName,
      required this.dataqty,
      required this.dataId,
      required this.dataAddress,
      required this.private_digital_wallet});
  @override
  _ResCookingState createState() => _ResCookingState();
}

class _ResCookingState extends State<ResCooking> {
  List<dynamic> dataFinalMenuRider = []; //เก็บข้อมูลออเดอร์ไรเดอร์
  List<dynamic> resultMenu = []; //เก็บข้อมูลออเดอร์ลูกค้า
  List<dynamic> amoutMenu = []; //เก็บจำนวนเมนูทั้งหมด
  List<dynamic> resultOrderRider = [];

  var riderName = "";
  var riderTel = "";
  late BuildContext dialogContext;
  late Timer timer;
  int costDelivery = 10;
  late Client httpClient;
  late Web3Client ethClient;
  bool data = false;
  bool statusRider = false;
  final myAddress =
      "0x0b2194Fde4B6D32f23331C12EA21c4B7c06efCa3"; //หมายเลขกระเป๋าตังร้านอาหาร

  //Set ค่าตั้งต้น
  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(
        "https://kovan.infura.io/v3/ea6f8a087ef041da9aa38a52779c1af3",
        httpClient); //เก็บ url ของ infura

    //เรียกใช้ฟังก์ชัน getStatusRider
    getStatusRider(myAddress);

    //เช็คเงื่อนไขทุก 15 วินาที
    Timer(Duration(seconds: 15), () {
      if (statusRider == true) {
        riderName = dataFinalMenuRider[0][1];
        riderTel = dataFinalMenuRider[0][2];
      }
    });
  }

  //load smartcontract
  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("lib/assets/abi.json");
    String contractAddress = "0xF1820c9873aEd059809c0B2CFa8031F8B67C5249";
    final contract = DeployedContract(ContractAbi.fromJson(abi, "FoodDelivery"),
        EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  //ฟังก์ชันสำหรับ query ข้อมูลจากบล็อกเชน
  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
        contract: contract, function: ethFunction, params: args);

    return result;
  }

  //query ข้อมูลจากบล็อกเชน
  Future<void> getStatusRider(String targetAddress) async {
    List<dynamic> resultOrderRes = []; //เก็บข้อมูลออเดอร์ร้านอาหาร

    amoutMenu = await query("nextId", []); //จำนวนออเดอร์ทั้งหมด

    //query ข้อมูลในบล็อกเชน จากฟังก์ชัน readOrderCustomer
    for (int i = 0; i < amoutMenu[0].toInt(); i++) {
      List<dynamic> result = await query("readOrderCustomer", [BigInt.from(i)]);

      resultMenu.add(result);
      print(resultMenu.length);
    }

//query ข้อมูลในบล็อกเชน จากฟังก์ชัน readOrderRider
    for (int i = 0; i < amoutMenu[0].toInt(); i++) {
      List<dynamic> result1 = await query("readOrderRider", [BigInt.from(i)]);
      resultOrderRider.clear();
      resultOrderRider.add(result1);
      print("ไรเดอร์${resultOrderRider}");
    }
//query ข้อมูลในบล็อกเชน จากฟังก์ชัน readOrderRestaurant
    for (int i = 0; i < amoutMenu[0].toInt(); i++) {
      List<dynamic> result2 =
          await query("readOrderRestaurant", [BigInt.from(i)]);
      resultOrderRes.clear();
      resultOrderRes.add(result2);
      print("ร้านอาหาร${resultOrderRes}");
    }

    if (resultOrderRider[0][3].toString() != '0' &&
        resultOrderRider[0][5].toString() == '0') {
      Timer(Duration(seconds: 1), () {
        setState(() {
          statusRider = true;
          print(statusRider);

          dataFinalMenuRider.clear();
          dataFinalMenuRider.add(resultOrderRider[0]);
          riderName = dataFinalMenuRider[0][1];
          riderTel = dataFinalMenuRider[0][2];
          print("Finish ${dataFinalMenuRider}");

          print(dataFinalMenuRider);
        });
      });
    }
  }

//เป็นส่วนของ UI แสดงผลบนหน้าจจอ
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
            "คำสั่งซื้อ",
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
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "รหัสคำสั่งซื้อ",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'NotoSansThai-Regular',
                        color: Color.fromRGBO(171, 171, 171, 1)),
                  ),
                  Text(
                    widget.dataId,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'NotoSansThai-Regular',
                        color: Color.fromRGBO(171, 171, 171, 1)),
                  )
                ],
              ),
            ),
            Container(
              height: 150,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 5))
              ]),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "สั่งโดย:",
                      style: TextStyle(
                          fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 10, top: 10, right: 20),
                          width: 60,
                          child: Image.asset(
                            "images/profile.png",
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 5),
                                child: Text(
                                  widget.dataName,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'NotoSansThai-Regular'),
                                ),
                              ),
                              Container(
                                width: 280,
                                child: Text(
                                  widget.dataAddress,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'NotoSansThai-Regular'),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 100,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 5))
              ]),
              margin: EdgeInsets.only(top: 15),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              "ผู้จัดส่ง",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'NotoSansThai-Regular'),
                            ),
                          ),
                          Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color.fromRGBO(118, 115, 217, 1),
                            ),
                            child: IconButton(
                              onPressed: () {
                                statusRider == true;
                                dataFinalMenuRider.clear();
                                getStatusRider(myAddress);
                              },
                              icon: const Icon(
                                Icons.refresh_outlined,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text("${riderName}",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'NotoSansThai-Regular')),
                          ),
                          Container(
                            child: Container(
                              child: Text("${riderTel}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'NotoSansThai-Regular')),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 100,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 5))
              ]),
              margin: EdgeInsets.only(top: 15),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "สรุปคำสั่งซื้อ",
                      style: TextStyle(
                          fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
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
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text("${widget.dataqty} x",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'NotoSansThai-Regular')),
                          ),
                          Container(
                            width: 200,
                            margin: EdgeInsets.only(right: 80),
                            child: Container(
                              child: Text("${widget.dataMenuname}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'NotoSansThai-Regular')),
                            ),
                          ),
                          Container(
                            child: Text(
                                "${int.parse(widget.MenuPrice) - costDelivery}",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'NotoSansThai-Regular')),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 150,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 5))
              ]),
              margin: EdgeInsets.only(top: 15),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "รวมค่าอาหารทั้งหมด",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'NotoSansThai-Regular'),
                              ),
                              Text(
                                  "${int.parse(widget.MenuPrice) - costDelivery}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'NotoSansThai-Regular')),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "ค่าจัดส่ง",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'NotoSansThai-Regular'),
                                ),
                                Text(costDelivery.toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'NotoSansThai-Regular')),
                              ],
                            ),
                          ),
                        ],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text("ราคาทั้งหมด",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'NotoSansThai-Regular')),
                        ),
                        Container(
                          child: Text(
                              "${(int.parse(widget.MenuPrice).toInt())}",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'NotoSansThai-Regular')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      //ส่วนด้านล่างของหน้าจอ
      bottomNavigationBar: Container(
        height: 80,
        decoration:
            BoxDecoration(color: Color.fromRGBO(44, 47, 57, 1), boxShadow: [
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
                //ฟังก์ชันเตรียมอาหารเสร็จสิ้นของร้านอาหาร
                restaurantSubmit(BuildContext context) async {
                  EthPrivateKey credentials = EthPrivateKey.fromHex(
                      widget.private_digital_wallet); //PrivateKey Restaurant
                  var apiurl =
                      "https://kovan.infura.io/v3/ea6f8a087ef041da9aa38a52779c1af3";
                  var ethClient = Web3Client(apiurl, httpClient);
                  DeployedContract contract = await loadContract();
                  final ethFunction = contract.function("restaurantSubmit");

                  var result = await ethClient.sendTransaction(
                      credentials,
                      Transaction.callContract(
                          maxGas: 800000,
                          contract: contract,
                          function: ethFunction,
                          parameters: [BigInt.tryParse(widget.dataId)]),
                      chainId: 42);

                  return result;
                }

                //print(widget.dataId);
                //เรียกใช้ ฟังก์ชั้นรับออเดอร์
                restaurantSubmit(context);
                print(restaurantSubmit.runtimeType);
                print("คำสั่งซื้อเสร็จแล้ว");

                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return RestuarantHome();
                }));
              },
              child: const Text(
                "เตรียมอาหารเสร็จสิ้น",
                style:
                    TextStyle(fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
              )),
        ),
      ),
    );
  }
}
