// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, file_names, prefer_const_constructors, unused_element, prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

import 'package:projectfood/about_rider/rider_photo.dart';
import 'package:web3dart/web3dart.dart';

class RiderSetMenu extends StatefulWidget {
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
  RiderSetMenu(
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
  _RiderSetMenuState createState() => _RiderSetMenuState();
}

class _RiderSetMenuState extends State<RiderSetMenu> {
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
        "0x52e822C87e5d993123812e22B813F9A236D6929a"; //contractAddess
    final contract = DeployedContract(ContractAbi.fromJson(abi, "FoodDelivery"),
        EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(220, 220, 220, 1),
      appBar: AppBar(
        centerTitle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color.fromRGBO(255, 191, 64, 1),
        toolbarHeight: 80,
        automaticallyImplyLeading: true,
        title: Container(
          alignment: Alignment.center,
          child: const Text(
            "คำสั่งซื้อ",
            style: TextStyle(fontFamily: 'NotoSansThai-Regular'),
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
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/map.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 330),
              width: 370,
              height: 208,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(44, 47, 57, 1),
                  borderRadius: BorderRadius.circular(7)),
              child: Column(
                children: [
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
                          margin: const EdgeInsets.only(right: 10, left: 10),
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
          ],
        ),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return RiderPhoto(
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
                        widget.private_digital_wallet.toString(),
                  );
                }));
              },
              child: const Text(
                "รับอาหาร",
                style:
                    TextStyle(fontSize: 20, fontFamily: 'NotoSansThai-Regular'),
              )),
        ),
      ),
    );
  }
}
