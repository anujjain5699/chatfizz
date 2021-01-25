import 'package:chatfizz/helper/constants.dart';
import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context){
  return AppBar(
    title: Image.asset(
      "assets/images/logo.png",
      height: 60,
    ),
  );
}


Widget drawer(BuildContext context){
  return Drawer(
    child:ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(color: Color(0xff43aa8b)),
          accountName: Constants.myName!=null?Text("${Constants.myName}",
            style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w600),)
          :Text("xyz...",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w600),),
          accountEmail: Constants.myEmail!=null?Text("${Constants.myEmail}")
          :Text("xyz@gmail.com"),
          currentAccountPicture: CircleAvatar(
            radius: 50,
            backgroundColor:Colors.black,
            child: Constants.myName!=null?Text(
              "${Constants.myName.substring(0,1)}",
              style: TextStyle(fontSize: 35.0,fontWeight: FontWeight.w600,color: Colors.white),
            ):Text("a",style: TextStyle(fontSize: 35.0,fontWeight: FontWeight.w600,color: Colors.white),),
          ),
        ),
        ListTile(
          title: Text("Ttem 1"),
          trailing: Icon(Icons.arrow_forward),
        ),
        ListTile(
          title: Text("Item 2"),
          trailing: Icon(Icons.arrow_forward),
        ),
      ],
    ),
  );
}


InputDecoration textFieldInputDecoration(String hinttext){
  return InputDecoration(
    hintText: hinttext,
    hintStyle: TextStyle(
      color: Colors.white54,
    ),
    focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white)
    ),
    enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white)
    ),
  );
}

TextStyle simpleTextStyle(){
  return TextStyle(
    color: Colors.white,
    fontSize: 16
  );
}
TextStyle mediumTextStyle(){
  return TextStyle(
    color: Colors.white,
    fontSize: 17
  );
}
