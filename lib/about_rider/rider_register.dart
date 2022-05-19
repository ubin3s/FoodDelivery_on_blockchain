// ignore_for_file: avoid_unnecessary_containers

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:projectfood/about_rider/rider.dart';

import 'package:projectfood/about_rider/rider_form.dart';
import 'package:projectfood/about_rider/rider_login.dart';
import 'package:projectfood/models/profile_model.dart';

class RiderRegister extends StatefulWidget {
  const RiderRegister({Key? key}) : super(key: key);

  @override
  _RiderRegisterState createState() => _RiderRegisterState();
}

class _RiderRegisterState extends State<RiderRegister> {
  final formKey = GlobalKey<FormState>();
  ProfileRegis profile = ProfileRegis(profileEmail: "", profilePassword: "");
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              backgroundColor: const Color.fromRGBO(255, 191, 64, 1),
              // appBar: AppBar(
              //   title: const Text("สร้างบัญชีผู้ใช้"),
              // ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 60),
                      width: 350,
                      height: 120,
                      child: Image.asset(
                        'images/logoAppRider.png',
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          width: 420,
                          height: 660,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                            image:
                                ExactAssetImage('images/shapeLoginRider.png'),
                            fit: BoxFit.fitWidth,
                          )),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Form(
                                    key: formKey,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                top: 80, left: 15),
                                            child: const Text(
                                              "สมัครสมาชิก",
                                              style: TextStyle(
                                                  fontSize: 35,
                                                  fontFamily:
                                                      'NotoSansThai-Regular',
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Center(
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  top: 20),
                                              width: 343,
                                              //  height: 50,
                                              decoration: BoxDecoration(
                                                color: const Color.fromRGBO(
                                                    108, 108, 108, 1),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20),
                                                child: TextFormField(
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                  decoration:
                                                      const InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText: 'อีเมล',
                                                          icon: Icon(
                                                            Icons
                                                                .email_outlined,
                                                            size: 30,
                                                            color:
                                                                Color.fromRGBO(
                                                                    178,
                                                                    178,
                                                                    178,
                                                                    1),
                                                          ),
                                                          hintStyle: TextStyle(
                                                              fontSize: 20,
                                                              fontFamily:
                                                                  'NotoSansThai-Regular',
                                                              color: Color
                                                                  .fromRGBO(
                                                                      178,
                                                                      178,
                                                                      178,
                                                                      1))),
                                                  validator: MultiValidator([
                                                    RequiredValidator(
                                                        errorText:
                                                            "กรุณาป้อนอีเมล"),
                                                    EmailValidator(
                                                        errorText:
                                                            "รูปแบบอีเมลไม่ถูกต้อง")
                                                  ]),
                                                  onSaved: (String? email) {
                                                    profile.profileEmail =
                                                        email!;
                                                  },
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Center(
                                            child: Container(
                                              width: 343,
                                              //  height: 50,
                                              decoration: BoxDecoration(
                                                color: const Color.fromRGBO(
                                                    108, 108, 108, 1),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20),
                                                child: TextFormField(
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                  decoration:
                                                      const InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText: 'รหัสผ่าน',
                                                          icon: Icon(
                                                            Icons.key_outlined,
                                                            size: 30,
                                                            color:
                                                                Color.fromRGBO(
                                                                    178,
                                                                    178,
                                                                    178,
                                                                    1),
                                                          ),
                                                          hintStyle: TextStyle(
                                                              fontSize: 20,
                                                              fontFamily:
                                                                  'NotoSansThai-Regular',
                                                              color: Color
                                                                  .fromRGBO(
                                                                      178,
                                                                      178,
                                                                      178,
                                                                      1))),
                                                  validator: RequiredValidator(
                                                      errorText:
                                                          "กรุณาป้อนรหัสผ่าน"),
                                                  onSaved: (String? password) {
                                                    profile.profilePassword =
                                                        password!;
                                                  },
                                                  obscureText: true,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Container(
                                              width: 343,
                                              height: 50,
                                              margin: const EdgeInsets.only(
                                                  top: 25),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary:
                                                        const Color.fromRGBO(
                                                            255,
                                                            170,
                                                            0,
                                                            1),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15))),
                                                child: const Text(
                                                  "สมัครสมาชิก",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontFamily:
                                                          'NotoSansThai-Regular'),
                                                ),
                                                onPressed: () async {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    formKey.currentState!
                                                        .save();
                                                    try {
                                                      await FirebaseAuth
                                                          .instance
                                                          .createUserWithEmailAndPassword(
                                                              email: profile
                                                                  .profileEmail,
                                                              password: profile
                                                                  .profilePassword);

                                                      formKey.currentState!
                                                          .reset();
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return RiderForm();
                                                      }));
                                                    } on FirebaseAuthException catch (e) {
                                                      print(e.code);

                                                      print(e.message);
                                                    }
                                                  }
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const Rider();
                                  }));
                                },
                                child: Container(
                                  width: 93,
                                  height: 100,
                                  margin: const EdgeInsets.only(top: 40),
                                  child: Image.asset(
                                    'images/logoAppShape.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: const Text(
                                        "หากคุณยังมีบัญชีผู้ใช้แล้วคลิก",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontFamily: 'NotoSansThai-Regular'),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return RiderLogin();
                                        }));
                                      },
                                      child: Container(
                                        child: const Text(
                                          " เข้าสู่ระบบ",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color.fromRGBO(
                                                  255, 170, 0, 1),
                                              fontFamily:
                                                  'NotoSansThai-Regular'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}