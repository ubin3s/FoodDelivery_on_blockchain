// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, file_names, prefer_const_constructors, prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:projectfood/about_rider/rider_finishWork.dart';
import 'package:web3dart/web3dart.dart';

class RiderDeliveryDate extends StatefulWidget {
  final String dataID;
  final String resName;
  final String resAddress;
  final String cusAddress;
  final String MenuPrice;
  final String cusName;
  final String qty;
  final String cusTel;
  final String menuName;
  final String private_digital_wallet;
  RiderDeliveryDate(
      {required this.dataID,
      required this.cusAddress,
      required this.resAddress,
      required this.resName,
      required this.MenuPrice,
      required this.cusName,
      required this.cusTel,
      required this.menuName,
      required this.qty,
      required this.private_digital_wallet});
  @override
  _RiderDeliveryDateState createState() => _RiderDeliveryDateState();
}

class _RiderDeliveryDateState extends State<RiderDeliveryDate> {
  late Client httpClient;
  late Web3Client ethClient;
  bool data = false;
  final myAddress =
      "0xE70D6D9c9aCEa718De2D126617Cd5E94d16d072a"; //หมายเลขกระเป๋าตัง Rider
  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(
        "https://kovan.infura.io/v3/ea6f8a087ef041da9aa38a52779c1af3",
        httpClient);
  }

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("lib/assets/abi.json");
    String contractAddress =
        "0xF1820c9873aEd059809c0B2CFa8031F8B67C5249"; //contractAddress
    final contract = DeployedContract(ContractAbi.fromJson(abi, "FoodDelivery"),
        EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(55, 60, 75, 1),
      appBar: AppBar(
        centerTitle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color.fromRGBO(255, 191, 64, 1),
        toolbarHeight: 80,
        automaticallyImplyLeading: true,
        title: Container(
          alignment: Alignment.center,
          child: const Text(
            "ส่งคำสั่งซื้อ",
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
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 371,
              height: 118,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10, top: 10),
                        child: Text(
                          "ลูกค้า",
                          style: TextStyle(
                              fontSize: 18, fontFamily: 'NotoSansThai-Regular'),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10, top: 10),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("images/profile.png"),
                                fit: BoxFit.cover)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20, top: 5),
                            child: Text(
                              widget.cusName,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'NotoSansThai-Regular'),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, top: 5),
                            child: Text(
                              widget.cusTel,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'NotoSansThai-Regular'),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              width: 371,
              height: 131,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, top: 10),
                    child: Text(
                      "รายการอาหาร",
                      style: TextStyle(
                          fontSize: 18, fontFamily: 'NotoSansThai-Regular'),
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
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 10, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "${widget.qty}x",
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'NotoSansThai-Regular'),
                          ),
                        ),
                        Container(
                          width: 250,
                          margin: EdgeInsets.only(right: 20),
                          child: Text(
                            widget.menuName,
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'NotoSansThai-Regular'),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Text(
                            widget.MenuPrice,
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
            ),
            SizedBox(
              height: 200,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 160,
        decoration:
            BoxDecoration(color: Color.fromRGBO(44, 47, 57, 1), boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(44, 47, 57, 1).withOpacity(0.5),
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
                    deliveryDateFail(BuildContext context) async {
                      EthPrivateKey credentials = EthPrivateKey.fromHex(
                          widget.private_digital_wallet); //PrivateKey Rider
                      var apiurl =
                          "https://kovan.infura.io/v3/ea6f8a087ef041da9aa38a52779c1af3";
                      var ethClient = Web3Client(apiurl, httpClient);
                      DeployedContract contract = await loadContract();
                      final ethFunction = contract.function("deliveryDate");

                      var result = await ethClient.sendTransaction(
                          credentials,
                          Transaction.callContract(
                              maxGas: 800000,
                              contract: contract,
                              function: ethFunction,
                              parameters: [
                                BigInt.tryParse(widget.dataID),
                                BigInt.tryParse(status)
                              ]),
                          chainId: 42);

                      return result;
                    }

                    // print(widget.dataId);
                    // //เรียกใช้ ฟังก์ชั้นรับออเดอร์
                    deliveryDateFail(context);
                    print(deliveryDateFail.runtimeType);
                    print("ส่งอาหารไม่สำเร็จ");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return RiderFinish(
                          menuName: widget.menuName.toString(),
                          menuPrice: widget.MenuPrice.toString(),
                          qty: widget.qty.toString());
                    }));
                  },
                  child: const Text(
                    "ส่งอาหารไม่สำเร็จ",
                    style: TextStyle(
                        fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
                  )),
            ),
            Container(
              // margin: const EdgeInsets.all(17),
              width: 371,
              height: 51,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(0, 177, 62, 1),
                  ),
                  onPressed: () async {
                    String status = "1";
                    deliveryDate(BuildContext context) async {
                      EthPrivateKey credentials = EthPrivateKey.fromHex(
                          widget.private_digital_wallet); //PrivateKey Rider
                      var apiurl =
                          "https://kovan.infura.io/v3/ea6f8a087ef041da9aa38a52779c1af3";
                      var ethClient = Web3Client(apiurl, httpClient);
                      DeployedContract contract = await loadContract();
                      final ethFunction = contract.function("deliveryDate");

                      var result = await ethClient.sendTransaction(
                          credentials,
                          Transaction.callContract(
                              maxGas: 800000,
                              contract: contract,
                              function: ethFunction,
                              parameters: [
                                BigInt.tryParse(widget.dataID),
                                BigInt.tryParse(status)
                              ]),
                          chainId: 42);

                      return result;
                    }

                    // print(widget.dataId);
                    // //เรียกใช้ ฟังก์ชั้นรับออเดอร์
                    deliveryDate(context);
                    print(deliveryDate.runtimeType);
                    print("ส่งอาหารแล้ว");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return RiderFinish(
                          menuName: widget.menuName.toString(),
                          menuPrice: widget.MenuPrice.toString(),
                          qty: widget.qty.toString());
                    }));
                  },
                  child: const Text(
                    "ส่งอาหารสำเร็จ",
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
