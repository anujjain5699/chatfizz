import 'package:chatfizz/helper/constants.dart';
import 'package:chatfizz/services/database.dart';
import 'package:chatfizz/views/conversationScreen.dart';
import 'package:chatfizz/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}


class _SearchScreenState extends State<SearchScreen> {

  TextEditingController searchTextEditingController=new TextEditingController();
  DatabaseMethods databaseMethods=new DatabaseMethods();

  QuerySnapshot searchSnapshot;


  initiateSearch(){
    databaseMethods.getUserByUsername(searchTextEditingController.text).then((val){
      setState(() {
        searchSnapshot=val;
      });
    });
  }

  Widget searchList(){
    return searchSnapshot!=null?ListView.builder(
      shrinkWrap: true,
      itemCount: searchSnapshot.docs.length,
      itemBuilder: (context,index){
        return SearchTile(
          userName: searchSnapshot.docs[index].data()["name"],
          userEmail: searchSnapshot.docs[index].data()["email"],
        );
      },
    ):Container();
  }
  createChatroomAndStartConversation({String username,String useremail}){
    if(username!=Constants.myName && useremail!=Constants.myEmail){
      String chatRoomId=getChatRoomId(Constants.myEmail,useremail);
      List<String> users=[Constants.myName,username];
      Map<String,dynamic> chatRoomMap={
        "users":users,
        "chatRoomId":chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
          builder: (context)=>ConversationScreen(
            chatRoomId
          )
      ));
    }else{
      FlushbarHelper.createError(message: "you cannot send message to yourself")
          .show(context);
      print("you cannot send message to yourself");
    }
  }

  Widget SearchTile({String userName, String userEmail}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName,style: simpleTextStyle(),),
              Text(userEmail,style: simpleTextStyle(),)
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
               createChatroomAndStartConversation(
                username: userName,
                 useremail: userEmail
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
              child: Text("Message"),
            ),
          ),
        ],
      ),
    );
}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24,vertical: 15),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: searchTextEditingController,
                        style: TextStyle(
                          color: Colors.white
                        ),
                        decoration: InputDecoration(
                          hintText: "Search username...",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Colors.white54,
                          )
                        ),
                      ),
                  ),
                  GestureDetector(
                    onTap: (){
                      if(searchTextEditingController.text.isNotEmpty){
                        if(searchTextEditingController.text==Constants.myName){
                          FlushbarHelper.createError(message: "you cannot send message to yourself")
                              .show(context);
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //     new SnackBar(content: new Text('you cannot send message to yourself')))
                        }else {
                          initiateSearch();
                        }
                      }else{
                        FlushbarHelper.createError(message: "invalid username")
                            .show(context);
                      }
                    },
                    child: Container(
                      width: 40,
                        height: 40,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0x36FFFFFF),
                              const Color(0x8FFFFFF),
                            ]
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Image.asset("assets/images/search_white.png",
                        )),
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a,String b){
  a=a.substring(0,a.lastIndexOf("@"));
  b=b.substring(0,b.lastIndexOf("@"));
  if(a.substring(0,1).codeUnitAt(0)>b.substring(0,1).codeUnitAt(0)){
    return "$b\_$a";
  }else{
    return "$a\_$b";
  }
}

