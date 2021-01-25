import 'package:chatfizz/helper/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{

  getUserByUsername(String username)async{
   return await FirebaseFirestore.instance.collection('users')
   .where("name",isNotEqualTo:Constants.myName)
   .get();
  }

  getUserByUserEmail(String userEmail)async{
    return await FirebaseFirestore.instance.collection('users')
        .where("email",isEqualTo: userEmail)
        .get();
  }

  uploadUserInfo(userMap){
    FirebaseFirestore.instance.collection("users")
        .add(userMap).catchError((e){
          print(e);
    });
}

createChatRoom(String chatRoomId,chatRoomMap){
    FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomId).set(chatRoomMap).catchError((e) {
      print(e.toString());
    });
}

addConversationMessage(String chatRoomId,messageMap){
    FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap).catchError((e){
      print(e.toString());
    });
  }

getConversationMessage(String chatRoomId)async{
   return FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
   .orderBy("time")
        .snapshots();
}

getChatRooms(String userName)async{
    return  FirebaseFirestore.instance
        .collection("ChatRoom")
        .where("users",arrayContains: userName)
        .snapshots();
}


}