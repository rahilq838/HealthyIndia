

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthyindia/homescreen.dart';

void main() {
  runApp(MaterialApp(
    home: HealthyIndia(),
  ));
}

class HealthyIndia extends StatefulWidget {
  @override
  _HealthyIndiaState createState() => _HealthyIndiaState();
}

class _HealthyIndiaState extends State<HealthyIndia> {
  String mobileNo;
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  // ignore: missing_return

  // login using mob no functioning

  Future<bool> loginUser(String mobileNo, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: mobileNo,
        timeout: Duration(seconds: 60),

        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();
          try {
         AuthResult result = await _auth.signInWithCredential(credential);
         FirebaseUser user = result.user;
         if (user != null) {
           Navigator.pushReplacement(
               context,
               MaterialPageRoute(
                   builder: (context) =>
                       HomeScreen(
                           user: user
                       )
               )
           );
         }
       }catch(error){

          }
        },
        //this call back will be called back when the verification is done auto retrieval
        verificationFailed: (AuthException exception) {
          print(exception.toString());
          showDialog(context: context,barrierDismissible: true,builder: (context)
          =>
              AlertDialog(title: Text('{$exception}'),));
        },
        codeSent: (String verficationId, [int forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) =>
                  AlertDialog(
                    title: Text(
                      'Give the code?',
                      style: TextStyle(color: Colors.orange),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: _codeController,
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () async {
                          final code = _codeController.text.trim();
                          AuthCredential credential =
                          PhoneAuthProvider.getCredential(
                              verificationId: verficationId, smsCode: code);
                          AuthResult result =
                          await _auth.signInWithCredential(credential);
                          FirebaseUser user = result.user;
                          if (user != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomeScreen(
                                          user: user,
                                        )));
                          } else {
                            print('error');
                          }
                        },
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                            color: Colors.white,
                            backgroundColor: Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ));
        },
        codeAutoRetrievalTimeout: null);
  }

  //login screen with mobile number

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Healthy India',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orange,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.0),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                Colors.orange[800],
                Colors.white,
                Colors.green,
              ]),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Login Using Your mobile',
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  'Include country code example India +91',
                  style: TextStyle(fontSize: 10.0, color: Colors.white),
                ),

                //Form for Signing In
                Form(
                  key: _formKey,
                  child: TextFormField(
                    autofocus: true,
                    style: TextStyle(color: Colors.white),
                    showCursor: true,
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                    value.isEmpty ? 'it cannot be empty' : null,
                    onChanged: (value) {
                      this.mobileNo = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Mobile Number',
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 2.0,),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2.0,),
                      ),
                      errorMaxLines: 14,
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0,),
                FlatButton(
                  textColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      loginUser(mobileNo, context);
                    }
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  color: Colors.orange,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
