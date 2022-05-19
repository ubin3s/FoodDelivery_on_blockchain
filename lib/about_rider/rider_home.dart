// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, unused_field, prefer_final_fields, prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, sized_box_for_whitespace, unnecessary_brace_in_string_interps

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:projectfood/about_rider/rider_accept.dart';
import 'package:projectfood/about_rider/rider_history.dart';
import 'package:projectfood/about_rider/rider_information.dart';
import 'package:web3dart/web3dart.dart';

class RiderHome extends StatefulWidget {
  RiderHome({Key? key}) : super(key: key);

  @override
  _RiderHomeState createState() => _RiderHomeState();
}

class _RiderHomeState extends State<RiderHome> {
  final auth = FirebaseAuth.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;
  bool viewVisible = true; //show list คำสั่งซื้อ

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late Client httpClient;
  late Web3Client ethClient;
  bool data = false;

  var streamQuery;
  var resName;
  List<dynamic> resultMenu = [];
  List<dynamic> dataMenu = [];
  List<dynamic> dataAddress = [];
  List<dynamic> dataMenuRider = [];
  List<dynamic> dataFinalMenuRider = [];

  final myAddress =
      "0xE70D6D9c9aCEa718De2D126617Cd5E94d16d072a"; //หมายเลขกระเป๋าตัง
  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(
        "https://kovan.infura.io/v3/ea6f8a087ef041da9aa38a52779c1af3",
        httpClient);
    getOrderCustomer(myAddress);
    viewVisible = true;
    Timer.periodic(Duration(seconds: 3), (Timer t) {
      void showWidget() {
        setState(() {
          viewVisible = true;
        });
      }

      showWidget();
    });
    super.initState();
  }

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("lib/assets/abi.json");
    String contractAddress =
        "0xF1820c9873aEd059809c0B2CFa8031F8B67C5249"; //contractAddress
    final contract = DeployedContract(ContractAbi.fromJson(abi, "FoodDelivery"),
        EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
        contract: contract, function: ethFunction, params: args);

    return result;
  }

  Future<void> getOrderCustomer(String targetAddress) async {
    List<dynamic> amoutMenu = await query("nextId", []);

    List<dynamic> resultOrderRider = [];
    List<dynamic> resultOrderRes = [];

    for (int i = 0; i < amoutMenu[0].toInt(); i++) {
      List<dynamic> result = await query("readOrderCustomer", [BigInt.from(i)]);
      List<dynamic> result1 = await query("readOrderRider", [BigInt.from(i)]);
      List<dynamic> result2 =
          await query("readOrderRestaurant", [BigInt.from(i)]);

      resultMenu.add(result);
      resultOrderRider.add(result1);
      resultOrderRes.add(result2);

      print("ลูกค้า${resultMenu}");
      print("ไรเดอร์${result1}");
      print("ร้านอาหาร${result2}");
      // print(resultMenu.length);

      if (resultOrderRider[i][3] == 0) {
        dataMenuRider = resultOrderRider;
      }
    }

    //อ่านข้อมูลของไรเดอร์
    for (int i = 0; i < amoutMenu[0].toInt(); i++) {
      if (resultOrderRider[i][3].toString() == 0.toString()) {
        dataMenuRider.add(resultOrderRider[i][0]);
      }
    }

    //query เมนูที่ยังไม่ได้รับ
    for (int i = 0; i < amoutMenu[0].toInt(); i++) {
      if (resultMenu[i][0].toString() == resultOrderRes[i][0].toString() &&
          resultOrderRes[i][4].toString() == '1' &&
          resultOrderRider[i][3].toString() == '0') {
        //  dataFinalMenuRider.clear();
        dataFinalMenuRider.add(resultMenu[i]);
      }
    }

    print("Finish${dataFinalMenuRider}");
    // print(resultMenu);
    // print(amoutMenu);

    dataMenu = resultMenu;
    // print(dataMenu);
    data = true;
    for (int i = 0; i < amoutMenu[0].toInt(); i++) {
      var resultAddress = await FirebaseFirestore.instance
          .collection("restuarants")
          .where("restuarant_name", isEqualTo: dataMenu[i][7].toString())
          .get();
      resultAddress.docs.forEach((res_address) {
        // print(res_address.data()["restuarant_address"]);
        dataAddress.add(res_address.data()["restuarant_address"]);
        // print("ที่อยู่${dataAddress}");
      });
    }
    //print("ที่อยู่อันนี้ ${dataAddress[0]}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(55, 60, 75, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 450,
              height: 100,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 191, 64, 1),
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 10),
                    child: Stack(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.only(top: 5, left: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: IconButton(
                              onPressed: () async {
                                var firebaseUser =
                                    FirebaseAuth.instance.currentUser;
                                var queryFirebase = await FirebaseFirestore
                                    .instance
                                    .collection("Riders")
                                    .where("rider_id",
                                        isEqualTo: firebaseUser!.uid)
                                    .get();
                                queryFirebase.docs.forEach((rider) {
                                  Navigator.push(context,
                                      CupertinoPageRoute(builder: (context) {
                                    return RiderHistory(
                                      addressRider:
                                          rider.data()["digital_wallet"],
                                    );
                                  }));
                                });
                              },
                              icon: Icon(
                                Icons.assignment,
                                size: 30,
                                color: Color.fromRGBO(118, 115, 217, 1),
                              )),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 25, left: 95),
                    padding: const EdgeInsets.only(bottom: 10, right: 10),
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () {
                        Timer(Duration(seconds: 1), () {
                          setState(() {
                            resultMenu.clear();
                            dataFinalMenuRider.clear();
                            getOrderCustomer(myAddress);
                            viewVisible = true;
                          });
                        });
                      },
                      icon: const Icon(
                        Icons.refresh_outlined,
                        size: 38,
                        color: Colors.white,
                      ),
                    ),
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color:
                          //Colors.white
                          const Color.fromRGBO(118, 115, 217, 1),
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    margin: EdgeInsets.only(top: 25, left: 82),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: IconButton(
                        color: const Color.fromRGBO(118, 115, 217, 1),
                        onPressed: () {
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) {
                            return RiderInfo();
                          }));
                        },
                        icon: const Icon(
                          Icons.person,
                          size: 30,
                        )),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 20, left: 20),
              child: Text(
                "คำสั่งซื้อ :",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontFamily: 'NotoSansThai-Regular'),
              ),
            ),
            Container(
              child: Visibility(
                visible: viewVisible,
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Column(
                    children: List.generate(dataFinalMenuRider.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return RiderAccept(
                              MenuPrice:
                                  dataFinalMenuRider[index][4].toString(),
                              dataID: dataFinalMenuRider[index][0].toString(),
                              cusAddress:
                                  dataFinalMenuRider[index][5].toString(),
                              resAddress: dataAddress[index].toString(),
                              resName: dataFinalMenuRider[index][7].toString(),
                              cusName: dataFinalMenuRider[index][1].toString(),
                              cusTel: dataFinalMenuRider[index][6].toString(),
                              qty: dataFinalMenuRider[index][3].toString(),
                              menuName: dataFinalMenuRider[index][2].toString(),
                            );
                          }));
                        },
                        child: Column(
                          children: [
                            Container(
                                width: 370,
                                height: 100,
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(244, 244, 244, 1),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          right: 10, left: 20),
                                      child: Image.asset(
                                        "images/Riderlogo.png",
                                        width: 70,
                                      ),
                                    ),
                                    Container(
                                      width: 180,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          top: 14,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              dataFinalMenuRider[index][7],
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily:
                                                      'NotoSansThai-Regular'),
                                            ),
                                            Text(
                                              dataAddress[index],
                                              style: TextStyle(
                                                  fontFamily:
                                                      'NotoSansThai-Regular'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 80,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                top: 14, left: 20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "THB",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          'NotoSansThai-Regular'),
                                                ),
                                                Text(
                                                  dataFinalMenuRider[index][4]
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          'NotoSansThai-Regular'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
