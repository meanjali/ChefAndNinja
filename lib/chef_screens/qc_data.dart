import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/services/firebase_db_chef.dart';
import 'package:food_delivery_app/widgets/alert.dart';
import 'package:food_delivery_app/widgets/chef_appbar.dart';
import 'package:food_delivery_app/widgets/chef_nav-drawer.dart';
import 'package:food_delivery_app/widgets/loading.dart';
import 'package:intl/intl.dart';

const kMainColor = Color(0xFFFF785B);
const kSubMainColor = Color(0xFFDEE8FF);
const headingColor = Color(0xFF002140);

class QCData extends StatefulWidget {
  @override
  _QCDataState createState() => _QCDataState();
}

class _QCDataState extends State<QCData> {
  Map<String, bool> questions = {
    "Question 1": false,
    "Question 2": false,
    "Question 3": false,
    "Question 4": false,
    "Question 5": false,
    "Question 6": false,
  };
  bool valuefirst = false;
  bool valuesecond = false;
  bool qcDataSubmitted;
  bool loading = true;
  DocumentSnapshot qcdata;
  DocumentSnapshot chef;

  fetchData() async {
    qcdata = await FirebaseMethodsChef()
        .fetchQCData(FirebaseAuth.instance.currentUser.uid);
    if (qcdata.exists) {
      qcDataSubmitted = true;
      var keys = questions.keys.toList();
      for (int i = 0; i < 6; i++) {
        questions[keys[i]] = qcdata.data()['values'][i];
      }
    } else {
      qcDataSubmitted = false;
      chef = await FirebaseFirestore.instance
          .collection('Chef')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get();
    }
    setState(() => loading = false);
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> _confirmSubmission() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Are you sure you want to submit ?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                await FirebaseMethodsChef()
                    .submitQCData(
                        FirebaseAuth.instance.currentUser.uid,
                        questions.values.toList(),
                        DateFormat('dd MMM y')
                            .format(DateTime.now())
                            .toString(),
                        chef.data()['fname'] + " " + chef.data()['lname'])
                    .then((value) {
                  setState(() => loading = true);
                  fetchData();
                });
                AlertMessage().showSnackBar(context, "Submitted successfully");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            drawer: NavDrawer(),
            appBar: ChefAppbar('QC Data'),
            body: Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: ListView(
                    children: questions.keys.map((String key) {
                      return new CheckboxListTile(
                        title: new Text(key),
                        secondary:
                            Icon(Icons.question_answer, color: kMainColor),
                        value: questions[key],
                        activeColor: kMainColor,
                        checkColor: kSubMainColor,
                        onChanged: (bool value) {
                          setState(() {
                            questions[key] = value;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: qcDataSubmitted
                        ? Text("You have submitted this form")
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(20.0),
                                ),
                                primary: kMainColor),
                            onPressed: () async {
                              await _confirmSubmission();
                            },
                            child: Text(
                              'Submit',
                              style:
                                  TextStyle(fontSize: 20, color: headingColor),
                            ),
                          ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: <Widget>[
                      Divider(
                        color: headingColor,
                        height: 30,
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Center(
                        child: Text(
                          'Status',
                          style: TextStyle(fontSize: 20, color: kMainColor),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              qcDataSubmitted
                                  ? qcdata.data()['status']
                                  : 'You have not submitted QC Data',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            qcDataSubmitted && qcdata.data()['comment'] != ""
                                ? Text(qcdata.data()['comment'])
                                : SizedBox()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
