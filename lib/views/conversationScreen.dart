import 'package:chatfizz/helper/constants.dart';
import 'package:chatfizz/services/database.dart';
import 'package:chatfizz/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

DatabaseMethods databaseMethods=new DatabaseMethods();
TextEditingController messageController=new TextEditingController();

Stream chatMessageStream;

  Widget ChatMessageList(){
     return StreamBuilder(
       stream: chatMessageStream,
       builder: (context,AsyncSnapshot<dynamic> snapshot){
         return snapshot.hasData?ListView.builder(
           padding: EdgeInsets.only(bottom: 75),
           itemCount: snapshot.data.documents.length,
           itemBuilder: (context,index){
             return MessageTile(snapshot.data.documents[index].data()["message"] ,
                 snapshot.data.documents[index].data()["sendBy"]==Constants.myName,
               snapshot.data.documents[index].data()["time"],
                 snapshot.data.documents[index].data()["chatRoomId"]
             );
           },
         ):Container();
       },
     );
  }
  
  sendMessage(){
    if(messageController.text.isNotEmpty){
      Map<String,dynamic> messageMap={
        "message":messageController.text,
        "sendBy":Constants.myName,
        "time":DateTime.now().millisecondsSinceEpoch,
        "chatRoomId":widget.chatRoomId
      };
      databaseMethods.addConversationMessage(widget.chatRoomId, messageMap);
     messageController.clear();
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessage(widget.chatRoomId).
    then((value){
      setState(() {
        chatMessageStream=value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Stack(
        children: [
          ChatMessageList(),
          Container(
            //height: 50,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Color(0xFF546A76),
              padding: EdgeInsets.symmetric(horizontal: 24,vertical: 15),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      style: TextStyle(
                          color: Colors.white
                      ),
                      decoration: InputDecoration(
                          hintText: "Message",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Colors.white54,
                          )
                      ),
                    ),
                  ),
                  SizedBox(width: 16,),
                  GestureDetector(
                    onTap: (){
                      sendMessage();
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
                              ],
                              begin: FractionalOffset.topLeft,
                              end: FractionalOffset.bottomRight
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Image.asset("assets/images/send.png",
                          height: 25, width: 25,
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {

  final String message;
  final int timeAgo;
  final bool isSendByMe;
  final String sendTo;

  MessageTile(this.message,this.isSendByMe,this.timeAgo,this.sendTo);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: isSendByMe ? 0 : 12,
          right: isSendByMe ? 12 : 0),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe?Alignment.centerRight:Alignment.centerLeft,
      child: Container(
        margin: isSendByMe
            ? EdgeInsets.only(left: MediaQuery.of(context).size.width*0.35)
            : EdgeInsets.only(right: MediaQuery.of(context).size.width*0.25),
        padding: EdgeInsets.only(
            top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: isSendByMe ? BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomLeft: Radius.circular(23)
          ) :
          BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomRight: Radius.circular(23)),
          gradient: LinearGradient(
            colors: isSendByMe ? [
              const Color(0xff007EF4),
              const Color(0xff2A75BC)
            ]
                : [
              const Color(0x1AFFFFFF),
              const Color(0x1AFFFFFF)
            ],
          ),
        ),
        child: isSendByMe ?Column(
          children: [
            SelectableText(message,
              cursorColor: Colors.orange,
              cursorWidth: 5,
              enableInteractiveSelection: true,
              toolbarOptions: ToolbarOptions(
                selectAll: true,
                paste: true,
                copy: true
              ),
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w300
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(DateTime.fromMillisecondsSinceEpoch(timeAgo).toString(),
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: Colors.grey
                )
            ),
              ],
            ),
          ],
        ):
        Row(
          children: [
            Container(
          height: 30,
          width: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),),
              child: Text("${sendTo.toString().replaceAll("_", "")
                  .replaceAll(Constants.myName, "")[0]}",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700
                ),
              ),
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.5,
                  child: Text(message,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w300
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(DateTime.fromMillisecondsSinceEpoch(timeAgo).toString(),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: Colors.grey
                        )
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

