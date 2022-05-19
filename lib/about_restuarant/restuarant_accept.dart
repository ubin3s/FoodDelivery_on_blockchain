// ignore_for_file: prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables, prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, unused_local_variable, non_constant_identifier_names, use_key_in_widget_constructors, unnecessary_string_interpolations, unused_element, avoid_unnecessary_containers, division_optimization, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:projectfood/about_customer/customer_home.dart';
import 'package:projectfood/about_restuarant/restuarant_cooking.dart';
import 'package:projectfood/about_restuarant/restuarant_home.dart';

import 'package:web3dart/web3dart.dart';

class ResAcceptOrder extends StatefulWidget {
  //ประกาศ Constructor เพื่อรับค่าจากหน้าอื่น
  final String dataMenuname;
  final String MenuPrice;
  final String dataName;
  final String dataqty;
  final String dataId;
  final String dataAddress;
  final String digitalWallet;
  final String private_digital_wallet;

  ResAcceptOrder(
      {required this.dataMenuname,
      required this.MenuPrice,
      required this.dataName,
      required this.dataqty,
      required this.dataId,
      required this.dataAddress,
      required this.digitalWallet,
      required this.private_digital_wallet});

  @override
  _ResAcceptOrderState createState() => _ResAcceptOrderState();
}

class _ResAcceptOrderState extends State<ResAcceptOrder> {
  int costDelivery = 10;
  late Client httpClient;
  late Web3Client ethClient;
  bool data = false;
  final myAddress =
      "0x0b2194Fde4B6D32f23331C12EA21c4B7c06efCa3"; //หมายเลขกระเป๋าตังร้านอาหาร

  //Set ค่าตั้งต้น
  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(
        "https://kovan.infura.io/v3/ea6f8a087ef041da9aa38a52779c1af3",
        httpClient); //เก็บ url infura
  }

  //load smartcontract จากไฟล์ Json
  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("lib/assets/abi.json");
    String contractAddress =
        "0xF1820c9873aEd059809c0B2CFa8031F8B67C5249"; //contractAddress
    final contract = DeployedContract(ContractAbi.fromJson(abi, "FoodDelivery"),
        EthereumAddress.fromHex(contractAddress));

    return contract;
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

      //พื้นที่ส่วนล่างของหน้าจอ
      bottomNavigationBar: Container(
        height: 102,
        decoration:
            BoxDecoration(color: Color.fromRGBO(44, 47, 57, 1), boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          )
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromRGBO(255, 62, 62, 1), width: 3)),
              width: 163,
              height: 50,
              margin: const EdgeInsets.only(left: 30),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                  ),
                  onPressed: () {
                    String status = "2";
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return RestuarantHome();
                    }));

                    //ฟังก์ชันส่งข้อมูลเข้า smartcontract ผ่าน parametor //ฟังก์ชันปฏิเสธคำสั่งซื้อ
                    restaurantDecline(BuildContext context) async {
                      EthPrivateKey credentials = EthPrivateKey.fromHex(widget
                          .private_digital_wallet); //PrivateKey restaurant
                      var apiurl =
                          "https://kovan.infura.io/v3/ea6f8a087ef041da9aa38a52779c1af3";
                      var ethClient = Web3Client(apiurl, httpClient);
                      DeployedContract contract = await loadContract();
                      final ethFunction = contract.function("restaurantAccept");

                      var result = await ethClient.sendTransaction(
                          credentials,
                          Transaction.callContract(
                              maxGas: 800000,
                              contract: contract,
                              function: ethFunction,
                              parameters: [
                                BigInt.tryParse(widget.dataId),
                                BigInt.tryParse(status)
                              ]),
                          chainId: 42);

                      return result;
                    }

                    //เรียกใช้ฟังก์ชันปฏิเสธคำสั่งซื้อ
                    restaurantDecline(context);
                    print(restaurantDecline.runtimeType);
                  },
                  child: const Text(
                    "ปฏิเสธ",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'NotoSansThai-Regular',
                        color: Color.fromRGBO(255, 62, 62, 1)),
                  )),
            ),
            Container(
              width: 163,
              height: 50,
              margin: const EdgeInsets.only(right: 30),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(0, 177, 62, 1),
                  ),
                  onPressed: () {
                    String status = "1";

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ResCooking(
                        dataId: widget.dataId,
                        dataName: widget.dataName,
                        dataMenuname: widget.dataMenuname,
                        dataqty: widget.dataqty,
                        MenuPrice: widget.MenuPrice,
                        dataAddress: widget.dataAddress,
                        private_digital_wallet: widget.private_digital_wallet,
                      );
                    }));

                    //ฟังก์ชันส่งข้อมูลเข้า smartcontract ผ่าน parametor //ฟังก์ชันรับคำสั่งซื้อ
                    restaurantAccept(BuildContext context) async {
                      EthPrivateKey credentials = EthPrivateKey.fromHex(widget
                          .private_digital_wallet); //PrivateKey Restaurant
                      var apiurl =
                          "https://kovan.infura.io/v3/ea6f8a087ef041da9aa38a52779c1af3";
                      var ethClient = Web3Client(apiurl, httpClient);
                      DeployedContract contract = await loadContract();
                      final ethFunction = contract.function("restaurantAccept");

                      var result = await ethClient.sendTransaction(
                          credentials,
                          Transaction.callContract(
                              maxGas: 800000,
                              contract: contract,
                              function: ethFunction,
                              parameters: [
                                BigInt.tryParse(widget.dataId),
                                BigInt.tryParse(status)
                              ]),
                          chainId: 42);

                      return result;
                    }

                    //เรียกใช้ ฟังก์ชั้นรับออเดอร์
                    restaurantAccept(context);
                    print(restaurantAccept.runtimeType);
                    print("รับคำสั่งซื้อแล้ว");
                  },
                  child: const Text(
                    "รับคำสั่งซื้อ",
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
