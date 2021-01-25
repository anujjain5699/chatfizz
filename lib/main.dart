import 'package:chatfizz/helper/authenticate.dart';
import 'package:chatfizz/helper/helperFunctions.dart';
import 'package:chatfizz/views/chatroomsScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

   bool userIsLoggedIn=false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async{
    await HelperFunction.getUserLoggedInSharedPreference().
    then((value){
      setState(() {
        userIsLoggedIn=value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:userIsLoggedIn==true?ChatRoom():
      Authenticate(),
    );
  }
}
