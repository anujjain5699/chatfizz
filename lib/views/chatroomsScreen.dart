import 'dart:ui';

import 'package:chatfizz/helper/authenticate.dart';
import 'package:chatfizz/helper/constants.dart';
import 'package:chatfizz/helper/helperFunctions.dart';
import 'package:chatfizz/services/auth.dart';
import 'package:chatfizz/services/database.dart';
import 'package:chatfizz/views/conversationScreen.dart';
import 'package:chatfizz/views/search.dart';
import 'package:chatfizz/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  
  DatabaseMethods databaseMethods=new DatabaseMethods();
  AuthMethods authMethods=new AuthMethods();
  Stream chatRoomsStream;
  final fb=FirebaseFirestore.instance.collection("ChatRoom");


  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){
        return snapshot.hasData?ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context,index){
            return Slidable(
              actionPane: SlidableDrawerActionPane(),
              actions: [
                IconSlideAction(
                  caption: 'Delete',
                  color: Color(0xfff25c54),
                  icon: Icons.delete,closeOnTap:true ,
                  onTap: (){
                    // fb.doc("chatRoomId").collection("chats").get().then((val){
                    //   val.forEach((e){
                    //     e.ref.delete();
                    //   });
                    // });
                    // snapshot.data.documents[index].reference.delete();
                    showDialog(
                      context: context,
                      builder: (_) => NetworkGiffyDialog(
                        key:  Key("NetworkDialog"),
                        image: Image.asset(
                        "assets/images/gif.gif",
                        fit: BoxFit.cover,
                        ),
                        entryAnimation: EntryAnimation.TOP_LEFT,
                        title: Text(
                        'Delete ChatRoom',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                        fontSize: 22.0, fontWeight: FontWeight.w600),
                        ),
                        description: Text(
                          "Do you really want to delete chatroom with ${snapshot.data.documents[index].data()["chatRoomId"]
                              .toString().replaceAll("_", "")
                              .replaceAll(Constants.myEmail.substring(0,Constants.myEmail.lastIndexOf("@")), "")} permanently ?",
                          softWrap: true,textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w500),
                        ),
                      )
                    );
                  },
                ),
              ],

              child: ChatRoomsTile(
                snapshot.data.documents[index].data()["chatRoomId"]
                    .toString().replaceAll("_", "")
                    .replaceAll(Constants.myEmail.substring(0,Constants.myEmail.lastIndexOf("@")), ""),
                  snapshot.data.documents[index].data()["chatRoomId"]
              ),
            );
          },
        ):
        Center(
        child: CircularProgressIndicator(backgroundColor:Colors.blue,),
        );
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  
  
  getUserInfo()async{
    Constants.myName=await HelperFunction.getUserNameSharedPreference();
    Constants.myEmail=await HelperFunction.getUserEmailSharedPreference();
    databaseMethods.getChatRooms(Constants.myName)
        .then((value){
      setState(() {
        chatRoomsStream=value;
      });
    });
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title :Text("ChatRooms",style: TextStyle(fontSize: 20,),),
        actions: [
          GestureDetector(
            onTap: (){
              authMethods.signOut(context);
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context)=>Authenticate()
              )
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app)),
          ),
        ],
      ),
      backgroundColor: Color(0xff161a1d),
      drawer: drawer(context),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            builder:(context)=>SearchScreen()
          ));
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {

  final String userName;
  final String chatRoomId;
  ChatRoomsTile(this.userName,this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(
          builder: (context)=>ConversationScreen(chatRoomId)
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Text("${userName.toLowerCase()}",
                  style: mediumTextStyle(),),
                ),
                SizedBox(width: 8,),
                Text(userName,style: mediumTextStyle(),),
              ],
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("swipe",
                    style: TextStyle(color: Colors.white30,fontSize: 10),
                  ),
                  Icon(Icons.arrow_right_alt_sharp,color: Colors.white30,size: 20,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

