// ignore_for_file: non_constant_identifier_names, use_key_in_widget_constructors, unnecessary_this, avoid_unnecessary_containers

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectfood/about_rider/rider_confirmPhoto.dart';

class RiderPhoto extends StatefulWidget {
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

  const RiderPhoto(
      {required this.dataID,
      required this.MenuPrice,
      required this.cusAddress,
      required this.cusName,
      required this.cusTel,
      required this.menuName,
      required this.private_digital_wallet,
      required this.qty,
      required this.resAddress,
      required this.resName});

  @override
  State<RiderPhoto> createState() => _RiderPhotoState();
}

class _RiderPhotoState extends State<RiderPhoto> {
  late File image;

  Future pickImage() async {
    try {
      final Image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (Image == null) return;

      final imageTemporary = File(Image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print("failed to pick image: $e");
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RiderConfirmPhoto(
        Image: image,
        dataID: widget.dataID.toString(),
        cusAddress: widget.cusAddress.toString(),
        resAddress: widget.resAddress.toString(),
        resName: widget.resName.toString(),
        cusName: widget.cusName.toString(),
        cusTel: widget.cusTel.toString(),
        menuName: widget.menuName.toString(),
        MenuPrice: widget.MenuPrice.toString(),
        qty: widget.qty.toString(),
        private_digital_wallet: widget.private_digital_wallet.toString(),
      );
    }));
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
          child: const Text("ถ่ายรูป"),
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
          margin: const EdgeInsets.only(bottom: 30),
          width: 371,
          height: 600,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromRGBO(44, 47, 57, 1)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  pickImage();
                },
                child: Container(
                  child: Image.asset(
                    "images/takePhoto.png",
                    scale: 1.8,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
