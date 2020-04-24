import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthyindia/database.dart';
import 'package:healthyindia/questions.dart';

//home screen widget
class HomeScreen extends StatefulWidget {
  final FirebaseUser user;

  HomeScreen({this.user});

  getUser() {
    return user;
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DropdownMenuItem<String>> setDropItems(index) {
    if (questions[index].question == 'Gender?') {
      return <String>['Male', 'Female']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value),
        );
      }).toList();
    } else {
      return <String>['Yes', 'No']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value),
        );
      }).toList();
    }
  }

//list of questions to be asked of type question
  List<Question> questions = [
    Question(question: 'Gender?', answerTo: null),
    Question(
        question: 'You have any domestic Travel history from last 15 days?',
        answerTo: null),
    Question(
        question:
            'You have any internaltional Travel history from last 15 days?',
        answerTo: null),
    Question(
        question:
            'Do you came in contact with a person that has been tested Covid-19 Positive ',
        answerTo: null),
    Question(question: 'Do you have cough?', answerTo: null),
    Question(question: 'Do you have Fever?', answerTo: null),
    Question(
        question: 'Are you sufferring from Breathlessness?', answerTo: null),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, colors: [
            Colors.orange,
            Colors.white,
            Colors.green,
          ]),
        ),
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.orange,
              padding: EdgeInsets.all(10.0),
              child: SafeArea(
                child: Text(
                  'Answer simple questions correctly',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) => Card(
                  color: Colors.white,
                  elevation: 0.0,
                  child: ListTile(
                    title: Column(
                      children: <Widget>[
                        Text(questions[index].question),
                        DropdownButton<String>(
                          value: questions[index].answerTo,
                          onChanged: (String newValue) {
                            setState(() {
                              questions[index].answerTo = newValue;
                            });
                          },
                          items: setDropItems(index),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            RaisedButton(
              onPressed: () async {
                print('${widget.getUser().uid}');
                submit(widget.getUser(), questions);

                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => AlertDialog(
                          title: Text('Succesfully Submitted',style: TextStyle(color: Colors.orange),),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'OK',
                                style: TextStyle(color: Colors.orange),
                              ),
                            ),
                          ],
                        ));
              },
              child: Text('Submit'),
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}

submit(FirebaseUser user, List<Question> questions) async {
  //create a new document for the user with the uid
  await DatabaseService(uid: user.uid).updateUserData(questions);
  return true;
}
