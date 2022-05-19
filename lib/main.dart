import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projectfood/about_customer/customer.dart';
import 'package:projectfood/about_restuarant/restuarant.dart';
import 'package:projectfood/about_rider/rider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}
 
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Food Delivery"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Builder(
            builder: (context) => Center(
              // ignore: deprecated_member_use
              child: RaisedButton(
                child: const Text("ร้านอาหาร"),
                onPressed: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Restuarant()))
                },
              ),
            ),
          ),
          Builder(
            builder: (context) => Center(
              // ignore: deprecated_member_use
              child: RaisedButton(
                child: const Text("ลูกค้า"),
                onPressed: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Customer()))
                },
              ),
            ),
          ),
          Builder(
            builder: (context) => Center(
              // ignore: deprecated_member_use
              child: RaisedButton(
                child: const Text("พนักงานขนส่งอาหาร"),
                onPressed: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Rider()))
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
