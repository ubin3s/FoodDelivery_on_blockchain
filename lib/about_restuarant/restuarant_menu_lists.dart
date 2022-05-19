// ignore_for_file: avoid_unnecessary_containers, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectfood/about_restuarant/restuarant_menu_edit_form.dart';

// ignore: must_be_immutable
class MenuLists extends StatelessWidget {
  var firebaseUser = FirebaseAuth.instance.currentUser;

  MenuLists({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      //query ข้อมูลรายการอาหารมาแสดงเป็น Listview
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("menus")
              .where("restuarant_menu_id", isEqualTo: firebaseUser!.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              children: snapshot.data!.docs.map((document) {
                return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context) {
                        return MenuEditForm(
                          menuId: document["menu_id"],
                          menuName: document["menu_name"],
                          menuPrice: document["menu_price"],
                          menuDescript: document["menu_descript"],
                          urlPicture: document["uriPicture"],
                        );
                      }));
                    },
                    child: Column(
                      children: [
                        Container(
                          child: ListTile(
                            title: Row(
                              children: [
                                Container(
                                    width: 120,
                                    height: 90,
                                    margin: const EdgeInsets.only(
                                        right: 10, top: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  document["uriPicture"]))),
                                    )),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        document["menu_name"],
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'NotoSansThai-Regular'),
                                      ),
                                    ),
                                    Container(
                                        child: Text(
                                      document["menu_price"].toString(),
                                      style: const TextStyle(
                                          fontFamily: 'NotoSansThai-Regular'),
                                    )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ));
              }).toList(),
            );
          }),
    );
  }
}
