import 'package:flutter/material.dart';
import 'package:projectfood/about_restuarant/restuarant_login.dart';
import 'package:projectfood/about_restuarant/restuarant_register.dart';
import 'package:projectfood/main.dart';

class Restuarant extends StatefulWidget {
  const Restuarant({Key? key}) : super(key: key);

  @override
  _RestuarantState createState() => _RestuarantState();
}

class _RestuarantState extends State<Restuarant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 191, 64, 1),
      // appBar: AppBar(
      //   title: const Text("ร้านอาหาร"),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 60),
              width: 350,
              height: 120,
              child: Image.asset(
                'images/logoAppRes.png',
                fit: BoxFit.cover,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const MyApp();
                }));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 3),
                width: 240,
                height: 260,
                child: Image.asset(
                  'images/Reslogo.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 420,
                  height: 365,
                  padding: EdgeInsets.only(bottom: 15),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: ExactAssetImage('images/shapeLoginRes.png'),
                    fit: BoxFit.fitWidth,
                  )),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 45),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 50,
                          padding: const EdgeInsets.only(
                            left: 35,
                          ),
                          alignment: Alignment.bottomLeft,
                          child: const Text(
                            "Let's Cook the Order ",
                            style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'NotoSansThai-Medium',
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Container(
                          width: 343,
                          height: 50,
                          margin: const EdgeInsets.only(bottom: 20, top: 20),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: const Color.fromRGBO(255, 170, 0, 1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              onPressed: () {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const RestuarantLogin();
                                }));
                              },
                              child: const Text(
                                "เข้าสู่ระบบ",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'NotoSansThai-Regular'),
                              )),
                        ),
                        // ignore: sized_box_for_whitespace
                        Container(
                          width: 343,
                          height: 50,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: const Color.fromRGBO(37, 37, 37, 1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: const BorderSide(
                                          color: Color.fromRGBO(255, 170, 0, 1),
                                          width: 3))),
                              onPressed: () {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const RestuarantRegister();
                                }));
                              },
                              child: const Text("สมัครสมาชิก",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'NotoSansThai-Regular',
                                    color: Color.fromRGBO(255, 170, 0, 1),
                                  ))),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
