// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:projectfood/about_restuarant/restuarant_home.dart';
import 'package:projectfood/widgets/customshape.dart';

class ResAccountInfo extends StatefulWidget {
  //ประกาศ Constructor เพื่อรับค่าจากหน้าอื่น
  final String digitalWallet;
  final String privateWallet;

  ResAccountInfo({required this.digitalWallet, required this.privateWallet});

  @override
  State<ResAccountInfo> createState() => _ResAccountInfoState();
}

class _ResAccountInfoState extends State<ResAccountInfo> {
  TextEditingController digitalWalletController = TextEditingController();
  TextEditingController privateWalletController = TextEditingController();

  //Set ค่าตั้งที่รับมาให้กับตัวแปร
  @override
  void initState() {
    super.initState();
    digitalWalletController.text = widget.digitalWallet;
    privateWalletController.text = widget.privateWallet;
  }

//เป็นส่วนของ UI แสดงผลบนหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(37, 37, 37, 1),
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
              return const RestuarantHome();
            }));
          },
        ),
        title: Container(
          alignment: Alignment.center,
          child: const Text(
            "บัญชีผู้ใช้งาน",
            style: TextStyle(fontFamily: 'NotoSansThai-Regular'),
          ),
          width: 189,
          height: 37,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: const Color.fromRGBO(118, 115, 217, 1),
          ),
        ),
      ),
      body: Container(
        // ignore: prefer_const_constructors
        color: Colors.white,

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: ClipPath(
                  clipper: Customshape(),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 25),
                        width: 450,
                        height: 220,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.elliptical(
                                    MediaQuery.of(context).size.width, 100)),
                            color: const Color.fromRGBO(37, 37, 37, 1)),
                        child: Image.asset(
                          "images/profile.png",
                          scale: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 450,
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "บัญชีกระเป๋าเงินดิจิทัล",
                      style: TextStyle(
                          fontSize: 18, fontFamily: 'NotoSansThai-Regular'),
                    ),
                    Container(
                      width: 371,
                      height: 50,
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(241, 241, 241, 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: TextField(
                        readOnly: true,
                        style: const TextStyle(
                          color: Color.fromRGBO(178, 178, 178, 1),
                          fontSize: 18,
                          fontFamily: 'NotoSansThai-Regular',
                        ),
                        controller: digitalWalletController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: "บัญชีกระเป๋าเงินดิจิทัล",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontSize: 20,
                              fontFamily: 'NotoSansThai-Regular',
                              color: Color.fromRGBO(178, 178, 178, 1)),
                        ),
                      ),
                    ),
                    const Text(
                      "รหัสกระเป๋าเงินดิจิทัล",
                      style: TextStyle(
                          fontSize: 18, fontFamily: 'NotoSansThai-Regular'),
                    ),
                    Container(
                      width: 371,
                      height: 50,
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(241, 241, 241, 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: TextField(
                        readOnly: true,
                        style: const TextStyle(
                          color: Color.fromRGBO(178, 178, 178, 1),
                          fontSize: 18,
                          fontFamily: 'NotoSansThai-Regular',
                        ),
                        controller: privateWalletController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: "รหัสกระเป๋าเงินดิจิทัล",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontSize: 20,
                              fontFamily: 'NotoSansThai-Regular',
                              color: Color.fromRGBO(178, 178, 178, 1)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
