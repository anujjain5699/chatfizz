import 'package:chatfizz/helper/constants.dart';
import 'package:chatfizz/helper/helperFunctions.dart';
import 'package:chatfizz/modal/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AuthMethods{

  static String sharedPreferenceUserLoggedInKey="ISLOGGEDIN";
  static String sharedPreferenceUserNameKey="USERNAMEKEY";
  static String sharedPreferenceUserEmailKey="USEREMAILKEY";


  final FirebaseAuth _auth=FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn=new GoogleSignIn();

  UserId _userFromFirebaseUser(User user){
    print("userId: ${UserId(userId: user.uid)}");
    return user!=null? UserId(userId: user.uid):null;
  }

  Future signInWithEmailAndPassword(String email, String password) async{
    try{
          UserCredential userCredential=await _auth.signInWithEmailAndPassword(
              email: email, password: password);
          User firebaseUser=userCredential.user;
         if(firebaseUser!=null)
           return _userFromFirebaseUser(firebaseUser);
    }catch(e){
      print(e.toString());
    }
  }

  Future signInWithGoogle(BuildContext context)async{
    GoogleSignInAccount googleSignInAccount= _googleSignIn.currentUser;
    if(googleSignInAccount==null)
      googleSignInAccount=await _googleSignIn.signInSilently();
    if(googleSignInAccount==null)
      googleSignInAccount=await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication=await googleSignInAccount.authentication;
      final AuthCredential authCredential= GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken
      );
      UserCredential userCredential=await _auth.signInWithCredential(authCredential);
      User firebaseUser=userCredential.user;
      if(firebaseUser!=null){
        assert(!firebaseUser.isAnonymous);
        assert(await firebaseUser.getIdToken()!=null);
        return firebaseUser;
      }
      return null;

  }

  Future signUpWithEmailAndPassword(String email,String password) async{
    try{
      UserCredential userCredential=await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
        User firebaseUser=userCredential.user;
        return _userFromFirebaseUser(firebaseUser);
    }catch(e){
      print(e.toString());
    }
  }

  Future resetPassword(String email) async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e.toString());
    }
  }

  Future signOut(BuildContext context) async{
    try{
      await _auth.signOut();
      await _googleSignIn.signOut();
      SharedPreferences prefs=await SharedPreferences.getInstance();
      prefs.remove(sharedPreferenceUserNameKey);
      prefs.remove(sharedPreferenceUserEmailKey);
      prefs.remove(sharedPreferenceUserLoggedInKey);
      Constants.myEmail=null;
      Constants.myName=null;
      await prefs.clear();
      FlushbarHelper.createInformation(
          message: "Logged out successfully!!",
        duration: Duration(seconds: 1)
      ).show(context);
    }catch(e){
      print(e.toString());
    }
  }

}