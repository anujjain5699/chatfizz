import 'package:chatfizz/helper/helperFunctions.dart';
import 'package:chatfizz/services/auth.dart';
import 'package:chatfizz/services/database.dart';
import 'package:chatfizz/views/chatroomsScreen.dart';
import 'package:chatfizz/widgets/widget.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {

  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoading=false;

  AuthMethods authMethods=new AuthMethods();
  DatabaseMethods databaseMethods=new DatabaseMethods();

  final GlobalKey<FormState> formkey=GlobalKey<FormState>();
  TextEditingController userNameTextEditingController=new TextEditingController();
  TextEditingController emailTextEditingController=new TextEditingController();
  TextEditingController passwordTextEditingController=new TextEditingController();

  signMeUp(){
    if(formkey.currentState.validate()){

      Map<String,String> userInfoMap={
        "name":userNameTextEditingController.text,
        "email":emailTextEditingController.text,
      };

      HelperFunction.saveUserNameSharedPreference(userNameTextEditingController.text);
      HelperFunction.saveUserEmailSharedPreference(emailTextEditingController.text);

      setState(() {
        isLoading=true;
      });
      authMethods.signUpWithEmailAndPassword(
          emailTextEditingController.text, passwordTextEditingController.text).then((val){

          databaseMethods.uploadUserInfo(userInfoMap);
          HelperFunction.saveuserLoggedInSharedPreference(true);
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context)=>ChatRoom()
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading?
      Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),)
          :Container(
        //height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: [
            Spacer(),
            Form(
              key: formkey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (val){
                      return val.isEmpty || val.length<4?"Invalid UserName":null;
                    },
                    controller: userNameTextEditingController,
                    style: simpleTextStyle(),
                    decoration: textFieldInputDecoration("username"),
                  ),
                  TextFormField(
                    validator: (val){
                      return RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)
                          ? null : "Enter correct email";
                    },
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
            SizedBox(height: 10,),
            GestureDetector(
              onTap: (){
                signMeUp();
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 15),
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
                child: Text("Sign Up",style: mediumTextStyle()),
              ),
            ),
            SizedBox(height: 8,),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 15),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              child: Text("Sign Up with Google",style: TextStyle(
                color: Colors.black,
                fontSize: 17,
              ),),
            ),
            SizedBox(height: 16,),
            Row(
              //mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account? ",style: mediumTextStyle(),),
                GestureDetector(
                  onTap: (){
                    widget.toggle();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text("SignIn now",style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      decoration: TextDecoration.underline,
                    ),
                    ),
                  ),
                ),
              ],
            ),
            // SizedBox(height: 50,),
          ],
        ),
      ),
    );
  }
}
