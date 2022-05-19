// ignore_for_file: prefer_const_constructors_in_immutables, file_names, must_be_immutable, non_constant_identifier_names, use_key_in_widget_constructors

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:projectfood/about_rider/rider_Delivery.dart';
import 'package:web3dart/web3dart.dart' as web3dart;

class RiderConfirmPhoto extends StatefulWidget {
  late File Image;
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
  RiderConfirmPhoto(
      {required this.Image,
      required this.MenuPrice,
      required this.cusAddress,
      required this.cusName,
      required this.cusTel,
      required this.dataID,
      required this.menuName,
      required this.private_digital_wallet,
      required this.qty,
      required this.resAddress,
      required this.resName});

  @override
  State<RiderConfirmPhoto> createState() => _RiderConfirmPhotoState();
}

class _RiderConfirmPhotoState extends State<RiderConfirmPhoto> {
  String urlPicture = "";
  late Client httpClient;
  late web3dart.Web3Client ethClient;
  bool data = false;

  Future<void> uploadImage() async {
    Random random = Random();
    int i = random.nextInt(10000);
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference reference =
        firebaseStorage.ref().child("TakePhoto/imageFood$i.jpg");
    UploadTask uploadTask = reference.putFile(widget.Image);

    urlPicture =
        // ignore: await_only_futures
        await (await uploadTask.then((res) => res.ref.getDownloadURL()));
    print('urlPicture = $urlPicture');
    insertUrlToFirestore();
  }

  Future<void> insertUrlToFirestore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var firebaseUser = FirebaseAuth.instance.currentUser;
    // ignore: prefer_collection_literals
    // Map<String, dynamic> map = Map();
    // map['urlPicture'] = urlPicture;

    await firestore.collection("TakePhoto").doc(firebaseUser!.uid).set(
        {"rider_id": firebaseUser.uid, "urlPicture": urlPicture}).then((value) {
      print('insert success');
    });
  }

  final myAddress =
      "0xE70D6D9c9aCEa718De2D126617Cd5E94d16d072a"; //หมายเลขกระเป๋าตัง Rider
  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = web3dart.Web3Client(
        "https://kovan.infura.io/v3/ea6f8a087ef041da9aa38a52779c1af3",
        httpClient);
  }

  Future<web3dart.DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("lib/assets/abi.json");
    String contractAddress =
        "0xF1820c9873aEd059809c0B2CFa8031F8B67C5249"; //contractAddess
    final contract = web3dart.DeployedContract(
        web3dart.ContractAbi.fromJson(abi, "FoodDelivery"),
        web3dart.EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(55, 60, 75, 1),
      appBar: AppBar(
        centerTitle: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color.fromRGBO(255, 191, 64, 1),
        toolbarHeight: 80,
        automaticallyImplyLeading: true,
        title: Container(
          alignment: Alignment.center,
          child: const Text(
            "ถ่ายรูป",
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
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(bottom: 40),
          // ignore: unnecessary_null_comparison
          child: widget.Image != null
              ? Image.file(
                  widget.Image,
                  width: 371,
                  height: 600,
                )
              : const FlutterLogo(
                  size: 60,
                ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 102,
        decoration: BoxDecoration(
            color: const Color.fromRGBO(44, 47, 57, 1),
            boxShadow: [
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
                      color: const Color.fromRGBO(0, 177, 62, 1), width: 3)),
              width: 163,
              height: 50,
              margin: const EdgeInsets.only(left: 30),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "ถ่ายใหม่",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontFamily: 'NotoSansThai-Regular'),
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
                  onPressed: () async {
                    var firebaseUser = FirebaseAuth.instance.currentUser;
                    uploadImage();
                    var result = await FirebaseFirestore.instance
                        .collection("TakePhoto")
                        .where("rider_id", isEqualTo: firebaseUser!.uid)
                        .get();
                    result.docs.forEach((rider) {
                      riderSetMenu(BuildContext context) async {
                        web3dart.EthPrivateKey credentials =
                            web3dart.EthPrivateKey.fromHex(widget
                                .private_digital_wallet); //PrivateKey Rider
                        var apiurl =
                            "https://kovan.infura.io/v3/ea6f8a087ef041da9aa38a52779c1af3";
                        var ethClient = web3dart.Web3Client(apiurl, httpClient);
                        web3dart.DeployedContract contract =
                            await loadContract();
                        final ethFunction = contract.function("riderSetMenu");

                        var result = await ethClient.sendTransaction(
                            credentials,
                            web3dart.Transaction.callContract(
                                maxGas: 800000,
                                contract: contract,
                                function: ethFunction,
                                parameters: [
                                  BigInt.tryParse(widget.dataID),
                                  rider.data()["urlPicture"].toString()
                                ]),
                            chainId: 42);

                        return result;
                      }

                      //เรียกใช้ ฟังก์ชั้นรับออเดอร์
                      riderSetMenu(context);
                      print(riderSetMenu.runtimeType);
                      print(widget.dataID);
                      print("รับอาหารแล้ว");
                    });
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return RiderDelivery(
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
                    "ส่ง",
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
