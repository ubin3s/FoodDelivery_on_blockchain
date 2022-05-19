// ignore_for_file: use_key_in_widget_constructors, override_on_non_overriding_member, non_constant_identifier_names, prefer_const_constructors_in_immutables, annotate_overrides, prefer_const_constructors, avoid_function_literals_in_foreach_calls, unnecessary_string_interpolations, unused_element, prefer_typing_uninitialized_variables, avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:projectfood/about_rider/rider_SetMenu.dart';
import 'package:projectfood/about_rider/rider_home.dart';
import 'package:web3dart/web3dart.dart' as web3dart;

class RiderAccept extends StatefulWidget {
  //ประกาศ constructor เพื่อรับค่าจากหน้าอื่น
  final String MenuPrice;
  final String dataID;
  final String resName;
  final String resAddress;
  final String cusAddress;
  final String cusName;
  final String qty;
  final String cusTel;
  final String menuName;

  RiderAccept(
      {required this.MenuPrice,
      required this.dataID,
      required this.resName,
      required this.resAddress,
      required this.cusAddress,
      required this.cusName,
      required this.cusTel,
      required this.qty,
      required this.menuName});
  _RiderAcceptState createState() => _RiderAcceptState();
}

class _RiderAcceptState extends State<RiderAccept> {
  late Client httpClient;
  late web3dart.Web3Client ethClient;
  bool data = false;
  final myAddress =
      "0xE70D6D9c9aCEa718De2D126617Cd5E94d16d072a"; //หมายเลขกระเป๋าตัง Rider

  //Set ค่าตั้งต้น
  @override
  void initState() {
    super.initState();

    httpClient = Client();
    ethClient = web3dart.Web3Client(
        "https://kovan.infura.io/v3/ea6f8a087ef041da9aa38a52779c1af3",
        httpClient); //เก็บ url infura
  }

  //load smartcontract จากไฟล์ Json
  Future<web3dart.DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("lib/assets/abi.json");
    String contractAddress =
        "0xF1820c9873aEd059809c0B2CFa8031F8B67C5249"; //contractAddress
    final contract = web3dart.DeployedContract(
        web3dart.ContractAbi.fromJson(abi, "FoodDelivery"),
        web3dart.EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  var firebaseUser = FirebaseAuth.instance.currentUser;

  //เป็นส่วน UI แสดงผลบนหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(55, 60, 75, 1),
      appBar: AppBar(
        centerTitle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color.fromRGBO(255, 191, 64, 1),
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Riders")
            .where("rider_id", isEqualTo: firebaseUser!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((document) {
              return SingleChildScrollView(
                child: Container(
                  height: 420,
                  color: Color.fromRGBO(44, 47, 57, 1),
                  margin: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.only(right: 10, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromRGBO(196, 196, 196, 1)
                                      .withOpacity(0.5),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context,
                                        MaterialPageRoute(builder: (context) {
                                      return RiderHome();
                                    }));
                                  },
                                  icon: Icon(
                                    Icons.close_outlined,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "40 ",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontFamily: 'NotoSansThai-Regular'),
                            ),
                          ),
                          Container(
                            child: Text(
                              "THB",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontFamily: 'NotoSansThai-Regular'),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          "รายได้ของคุณ",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: 'NotoSansThai-Regular'),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30, left: 15),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "BlockFood",
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontFamily: 'NotoSansThai-Regular'),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: SizedBox(
                            width: 340,
                            height: 2,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(65, 69, 83, 1)),
                            ),
                          ),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 10, left: 15),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Container(
                                child: Text(
                                  "ค่าอาหารทั้งหมด",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontFamily: 'NotoSansThai-Regular'),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  "${widget.MenuPrice}  THB",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontFamily: 'NotoSansThai-Regular'),
                                ),
                              ),
                            ],
                          )),
                      Container(
                        alignment: Alignment.center,
                        child: const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: SizedBox(
                            width: 340,
                            height: 2,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(65, 69, 83, 1)),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 15),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 25,
                              child: Image.asset(
                                "images/logoRes.png",
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    widget.resName,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontFamily: 'NotoSansThai-Regular'),
                                  ),
                                ),
                                Container(
                                  width: 300,
                                  child: Text(
                                    widget.resAddress,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontFamily: 'NotoSansThai-Regular'),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Row(
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(right: 10, left: 10),
                              width: 2,
                              child: Image.asset(
                                "images/linewhite.png",
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10, left: 14),
                            width: 25,
                            child: Image.asset(
                              "images/location.png",
                            ),
                          ),
                          Container(
                            width: 300,
                            child: Text(
                              widget.cusAddress,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontFamily: 'NotoSansThai-Regular'),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration:
            BoxDecoration(color: Color.fromRGBO(44, 47, 57, 1), boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(44, 47, 57, 1).withOpacity(0.5),
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
                String stateAccept = "1"; //รับคำสั่งซื้อ
                //query ข้อมูลจาก firebase
                var result = await FirebaseFirestore.instance
                    .collection("Riders")
                    .where("rider_id", isEqualTo: firebaseUser!.uid)
                    .get();

                result.docs.forEach((rider_data) {
                  //ฟังก์ชันรับคำสั่งซื้อของพนักงานขนส่งอาหาร
                  riderAccept(BuildContext context) async {
                    web3dart.EthPrivateKey credentials =
                        web3dart.EthPrivateKey.fromHex(rider_data.data()[
                            "private_digital_wallet"]); //PrivateKey Rider
                    var apiurl =
                        "https://kovan.infura.io/v3/ea6f8a087ef041da9aa38a52779c1af3";
                    var ethClient = web3dart.Web3Client(apiurl, httpClient);
                    web3dart.DeployedContract contract = await loadContract();
                    final ethFunction = contract.function("riderAccept");

                    var result = await ethClient.sendTransaction(
                        credentials,
                        web3dart.Transaction.callContract(
                            maxGas: 800000,
                            contract: contract,
                            function: ethFunction,
                            parameters: [
                              BigInt.tryParse(widget.dataID),
                              rider_data.data()["rider_name"],
                              rider_data.data()["rider_tel"],
                              BigInt.tryParse(stateAccept)
                            ]),
                        chainId: 42);
                    return result;
                  }

                  //  เรียกใช้ ฟังก์ชั้นรับออเดอร์
                  riderAccept(context);
                  print(riderAccept.runtimeType);

                  print("ไรเดอร์รับคำสั่งซื้อแล้ว");
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return RiderSetMenu(
                      dataID: widget.dataID.toString(),
                      cusAddress: widget.cusAddress.toString(),
                      resAddress: widget.resAddress.toString(),
                      resName: widget.resName.toString(),
                      cusName: widget.cusName.toString(),
                      cusTel: widget.cusTel.toString(),
                      menuName: widget.menuName.toString(),
                      MenuPrice: widget.MenuPrice.toString(),
                      qty: widget.qty.toString(),
                      private_digital_wallet:
                          rider_data.data()["private_digital_wallet"],
                    );
                  }));
                });
              },
              child: const Text(
                "รับคำสั่งซื้อ",
                style:
                    TextStyle(fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
              )),
        ),
      ),
    );
  }
}
