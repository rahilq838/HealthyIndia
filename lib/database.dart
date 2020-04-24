import 'package:cloud_firestore/cloud_firestore.dart';
import 'questions.dart';
import '';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference qACollection= Firestore.instance.collection('qACollection');

  Future updateUserData(List<Question> questions )async{
    return await qACollection.document(uid).setData({
      'Gender?' :questions[0].answerTo,
      'Do you have any Travel history from last 15 days?':questions[1].answerTo,
      'Do you have any International Travel history from last 15 days':questions[2].answerTo,
      'Do you came in contact with a person that has been tested Covid-19 Positive Now':questions[3].answerTo,
      'Do you have cough?':questions[4].answerTo,
      'Do you have Fever?':questions[5].answerTo,
      'Are you sufferring from Breathlessness?':questions[6].answerTo,
    });
  }
}