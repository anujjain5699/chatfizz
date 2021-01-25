import 'package:chatfizz/helper/helperFunctions.dart';
import 'package:chatfizz/services/auth.dart';
import 'package:chatfizz/services/database.dart';
import 'package:chatfizz/views/chatroomsScreen.dart';
import 'package:chatfizz/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final formKey=GlobalKey<FormState>();
  AuthMethods authMethods=new AuthMethods();
  DatabaseMethods databaseMethods=new DatabaseMethods();
  TextEditingController emailTextEditingController=new TextEditingController();
  TextEditingController passwordTextEditingController=new TextEditingController();
  bool isLoading=false;
  QuerySnapshot snapShotUserInfo;


  signIn(){
    if(formKey.currentState.validate()){
      HelperFunction.saveUserEmailSharedPreference(emailTextEditingController.text);
      databaseMethods.getUserByUserEmail(emailTextEditingController.text)
          .then((val){
        snapShotUserInfo=val;
        HelperFunction
            .saveUserNameSharedPreference(snapShotUserInfo.docs[0].data()["name"]);
      });
      setState(() {
        isLoading=true;
      });
      authMethods.signInWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val){
        if(val!=null){
          HelperFunction.saveuserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context)=>ChatRoom()));
        }
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: ( val){
                        return RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)
                            ? null : "Enter correct email";
                      },
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      controller: emailTextEditingController,
                      style: simpleTextStyle(),
                      decoration: textFieldInputDecoration("email"),
                    ),
                    TextFormField(
                      validator: (val){
                        return val.length>6?null:"Please provide password 6+ length";
                      },
                      obscureText: true,
                      controller: passwordTextEditingController,
                      style: simpleTextStyle(),
                      decoration: textFieldInputDecoration("password"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: (){
                  if(emailTextEditingController.text==""){
                    FlushbarHelper.createError(
                        duration: Duration(seconds: 2),
                        message: "email should be provided to reset password").show(context);
                  }
                  else{
                    authMethods.resetPassword(emailTextEditingController.text);
                    FlushbarHelper.createSuccess(
                      duration: Duration(seconds: 2),
                        message: "password reset link send to "
                            "${emailTextEditingController.text.substring(0,3)}***${emailTextEditingController.text.substring(emailTextEditingController.text.length-3)}"
                    ).show(context);
                  }
                },
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                    child: Text(
                      "Forget Password?",
                      style: simpleTextStyle(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: (){
                  signIn();
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xff007EF4),
                        const Color(0xff2A758C),
                      ]
                    ),
                  ),
                  child: Text("Sign In",style: mediumTextStyle()),
                ),
              ),
              SizedBox(height: 8,),
              //sign in with google
              GestureDetector(
                onTap: (){
                  authMethods.signInWithGoogle(context).then((firebaseUser){
                    if(firebaseUser!=null){
                      HelperFunction.saveuserLoggedInSharedPreference(true);
                      HelperFunction.saveUserEmailSharedPreference(firebaseUser.email);
                      HelperFunction.saveUserNameSharedPreference(firebaseUser.displayName);
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context)=>ChatRoom()));
                    }
                  });

                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: Text("Sign in with Google",style: TextStyle(
                    color: Colors.black,
                    fontSize: 17
                  )),
                ),
              ),
              SizedBox(height: 13,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?",style: mediumTextStyle(),),
                  GestureDetector(
                    onTap: (){
                      widget.toggle();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text("Register now",style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        decoration: TextDecoration.underline,
                      ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5,),
            ],
          ),
        ),
      ),
    );
  }
}
