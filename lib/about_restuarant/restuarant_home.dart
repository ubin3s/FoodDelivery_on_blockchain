// ignore_for_file: prefer_final_fields, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_typing_uninitialized_variables, avoid_function_literals_in_foreach_calls, non_constant_identifier_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:projectfood/about_restuarant/restuarant.dart';
import 'package:projectfood/about_restuarant/restuarant_accept.dart';
import 'package:projectfood/about_restuarant/restuarant_account_information.dart';
import 'package:projectfood/about_restuarant/restuarant_edit_information.dart';
import 'package:projectfood/about_restuarant/restuarant_history.dart';
import 'package:projectfood/about_restuarant/restuarant_manage_menu.dart';
import 'package:projectfood/main.dart';
import 'package:web3dart/web3dart.dart';

class RestuarantHome extends StatefulWidget {
  const RestuarantHome({Key? key}) : super(key: key);

  @override
  _RestuarantHomeState createState() => _RestuarantHomeState();
}

class _RestuarantHomeState extends State<RestuarantHome> {
  final auth = FirebaseAuth.instance;
  var firebaseUser = FirebaseAuth
      .instance.currentUser; //เก็บ uid ของ account ที่ login อยู่ปัจจุบัน

  bool viewVisible = true; //show list คำสั่งซื้อ

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late Client httpClient;
  late Web3Client ethClient;
  bool data = false;
  var dataMenuname;
  var dataId;
  List countMenu = [];

  List<dynamic> dataMenu = [];
  List<dynamic> dataMenuRes = [];
  List<dynamic> dataFinalMenuRes = [];
  var dataMenuPrice;
  var dataqty;
  var finalresult;
  final myAddress =
      "0x0b2194Fde4B6D32f23331C12EA21c4B7c06efCa3"; //หมายเลขกระเป๋าตัง

  //Set ค่าตั้งต้น
  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(
        "https://kovan.infura.io/v3/ea6f8a087ef041da9aa38a52779c1af3",
        httpClient); //เก็บ url ของ infura

    //เรียกใช้ฟังก์ชัน
    getOrderCustomer(myAddress);
    viewVisible = true;

    //ให้ทำงานทุกๆ 3 วินาที
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

  //load smartcontract จากไฟล์ Json
  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("lib/assets/abi.json");
    String contractAddress =
        "0xF1820c9873aEd059809c0B2CFa8031F8B67C5249"; //contractAddress
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

  //query ข้อมูล
  Future<void> getOrderCustomer(String targetAddress) async {
    List<dynamic> amoutMenu = await query("nextId", []); //จำนวนออเดอร์ทั้งหมด

    List<dynamic> resultMenu = []; //ข้อมูลออเดอร์ทั้งหมด
    List<dynamic> resultOrderRes = []; //ข้อมูลออเดอร์ของร้านอาหาร

    //query ข้อมูลจากฟังก์ชัน readOrderCustomer และ readOrderRestaurant
    for (int i = 0; i < amoutMenu[0].toInt(); i++) {
      List<dynamic> result = await query("readOrderCustomer", [BigInt.from(i)]);
      List<dynamic> result1 =
          await query("readOrderRestaurant", [BigInt.from(i)]);

      resultOrderRes.add(result1);
      resultMenu.add(result);

      if (resultOrderRes[i][3] == 0) {
        dataMenuRes = resultOrderRes;
      }
    }

    //อ่านข้อมูลร้านอาหาร
    for (int i = 0; i < amoutMenu[0].toInt(); i++) {
      if (resultOrderRes[i][3].toString() == 0.toString()) {
        dataMenuRes.add(resultOrderRes[i][0]);
      }
    }
    //query เมนูที่ยังไม่ได้รับ
    for (int i = 0; i < amoutMenu[0].toInt(); i++) {
      if (resultMenu[i][0] == resultOrderRes[i][0] &&
          resultOrderRes[i][3].toString() == 0.toString()) {
        dataFinalMenuRes.add(resultMenu[i]);
      }
    }

    print("Finish${dataFinalMenuRes}");
    // print("เมนูลูกค้า${resultMenu[1]}");

    print("เมนูร้านอาหาร${resultOrderRes}");
    print(resultMenu.length);
    dataMenu = resultMenu;
    data = true;
  }

  //เป็นส่วนของ UI แสดงผลบนหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Container(
        width: 345,
        child: Drawer(
          backgroundColor: const Color.fromRGBO(55, 60, 75, 1),
          child: ListView(
            children: [
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("restuarants")
                      .where("restuarant_id", isEqualTo: firebaseUser!.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: 300,
                          height: 100,
                          child: Image.asset(
                            "images/logoAppRes.png",
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.all(20),
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromRGBO(255, 191, 64, 1),
                            ),
                            child: ListView(
                              children: snapshot.data!.docs.map((document) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        CupertinoPageRoute(builder: (context) {
                                      return RestuarantEditInfo(
                                        restuarantAddress:
                                            document["restuarant_address"],
                                        restuarantId: document["restuarant_id"],
                                        restuarantName:
                                            document["restuarant_name"],
                                        restuarantOwner:
                                            document["restuarant_owner"],
                                        restuarantTel:
                                            document["restuarant_tel"],
                                      );
                                    }));
                                  },
                                  child: Container(
                                    width: 250,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 10, top: 10),
                                                  width: 80,
                                                  child: Image.asset(
                                                    "images/Reslogo.png",
                                                    width: 50,
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 20, top: 10),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        document[
                                                            "restuarant_name"],
                                                        style: const TextStyle(
                                                            fontSize: 24,
                                                            fontFamily:
                                                                'NotoSansThai-Regular'),
                                                      ),
                                                      Text(
                                                        document[
                                                            "restuarant_owner"],
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            fontFamily:
                                                                'NotoSansThai-Regular'),
                                                      ),
                                                      Text(
                                                        document[
                                                            "restuarant_tel"],
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'NotoSansThai-Regular'),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20, right: 20, top: 10),
                                              child: SizedBox(
                                                width: 260,
                                                height: 2,
                                                child: DecoratedBox(
                                                  decoration: BoxDecoration(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20, right: 20, top: 5),
                                              child: Text(
                                                document["restuarant_address"],
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                        'NotoSansThai-Regular'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            )),
                      ],
                    );
                  }),
              GestureDetector(
                onTap: () async {
                  var result = await FirebaseFirestore.instance
                      .collection("restuarants")
                      .where("restuarant_id", isEqualTo: firebaseUser!.uid)
                      .get();

                  result.docs.forEach((resdata) {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) {
                      return ResAccountInfo(
                        digitalWallet: resdata.data()["digital_wallet"],
                        privateWallet: resdata.data()["private_digital_wallet"],
                      );
                    }));
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  width: 300,
                  height: 65,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: const [
                        Icon(Icons.assignment_ind_rounded),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "บัญชี",
                          style: TextStyle(
                              fontSize: 18, fontFamily: 'NotoSansThai-Regular'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 30, right: 30, top: 10),
                child: SizedBox(
                  width: 250,
                  height: 2,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const ManageMenu()))
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  width: 300,
                  height: 65,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: const [
                        Icon(Icons.menu_open_rounded),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "รายการอาหาร",
                          style: TextStyle(
                              fontSize: 18, fontFamily: 'NotoSansThai-Regular'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 30, right: 30, top: 10),
                child: SizedBox(
                  width: 250,
                  height: 2,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  auth.signOut().then((value) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return const Restuarant();
                    }));
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  width: 300,
                  height: 65,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: const [
                        Icon(Icons.logout),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "ออกจากระบบ",
                          style: TextStyle(
                              fontSize: 18, fontFamily: 'NotoSansThai-Regular'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
                        IconButton(
                            onPressed: () =>
                                _scaffoldKey.currentState?.openDrawer(),
                            // ignore: prefer_const_constructors
                            icon: Icon(
                              Icons.menu_sharp,
                              size: 40,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 25, left: 95),
                    padding: const EdgeInsets.only(bottom: 10, right: 10),
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () {
                        dataFinalMenuRes.clear();
                        getOrderCustomer(myAddress);
                        viewVisible = true;
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
                      color: const Color.fromRGBO(118, 115, 217, 1),
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.only(top: 25, left: 82),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: IconButton(
                        color: const Color.fromRGBO(118, 115, 217, 1),
                        onPressed: () async {
                          var firebaseUser = FirebaseAuth.instance.currentUser;
                          var queryFirebase = await FirebaseFirestore.instance
                              .collection("restuarants")
                              .where("restuarant_id",
                                  isEqualTo: firebaseUser!.uid)
                              .get();

                          queryFirebase.docs.forEach((res) {
                            Navigator.push(context,
                                CupertinoPageRoute(builder: (context) {
                              return ResHistory(
                                addressRes: res.data()["digital_wallet"],
                              );
                            }));
                          });
                        },
                        icon: const Icon(
                          Icons.assignment,
                          size: 30,
                        )),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 20, left: 20),
              child: const Text(
                "คำสั่งซื้อ :",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: 'NotoSansThai-Medium'),
              ),
            ),
            Container(
              child: Visibility(
                visible: viewVisible,
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: List.generate(dataFinalMenuRes.length, (index) {
                      return GestureDetector(
                        onTap: () async {
                          //query ข้อมูลจาก firebase
                          var result = await FirebaseFirestore.instance
                              .collection("restuarants")
                              .where("restuarant_id",
                                  isEqualTo: firebaseUser!.uid)
                              .get();
                          result.docs.forEach((restaurant_data) {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ResAcceptOrder(
                                dataMenuname:
                                    dataFinalMenuRes[index][2].toString(),
                                MenuPrice:
                                    dataFinalMenuRes[index][4].toString(),
                                dataName: dataFinalMenuRes[index][1].toString(),
                                dataqty: dataFinalMenuRes[index][3].toString(),
                                dataId: dataFinalMenuRes[index][0].toString(),
                                dataAddress:
                                    dataFinalMenuRes[index][5].toString(),
                                digitalWallet: restaurant_data
                                    .data()["digital_wallet"]
                                    .toString(),
                                private_digital_wallet: restaurant_data
                                    .data()["private_digital_wallet"]
                                    .toString(),
                              );
                            }));
                          });
                        },
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                  width: 370,
                                  height: 100,
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          244, 244, 244, 1),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            right: 10, left: 20),
                                        child: Image.asset(
                                          "images/logoApp.png",
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
                                                "ID: ${dataFinalMenuRes[index][0].toString()}",
                                                style: const TextStyle(
                                                    fontFamily:
                                                        'NotoSansThai-Regular'),
                                              ),
                                              Text(
                                                dataFinalMenuRes[index][2]
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        'NotoSansThai-Regular'),
                                              ),
                                              Text(
                                                "${dataFinalMenuRes[index][3].toString()} รายการ",
                                                style: const TextStyle(
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
                                                    dataFinalMenuRes[index][4]
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
