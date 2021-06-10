import 'package:flutter/material.dart';
import 'package:food_delivery_app/services/firebase_db.dart';
import 'package:food_delivery_app/widgets/alert.dart';
import 'package:food_delivery_app/widgets/loading.dart';
import 'package:google_fonts/google_fonts.dart';

class Checklist extends StatefulWidget {
  final List values;
  final String chefId;
  Checklist(this.values, this.chefId);
  @override
  _ChecklistState createState() => _ChecklistState();
}

class _ChecklistState extends State<Checklist> {
  bool loading = true;
  Future<void> _giveRemark(BuildContext context) async {
    TextEditingController _remarkController = TextEditingController();
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.all(10),
          title: Text(
            'Enter Remark',
            style: GoogleFonts.lexendDeca(fontWeight: FontWeight.w500),
          ),
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.black),
                  right: BorderSide(color: Colors.black),
                  bottom: BorderSide(color: Colors.black),
                  left: BorderSide(color: Colors.black),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _remarkController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Write your remark here',
                  hintStyle: GoogleFonts.lexendDeca(),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFFFF785B))),
              child: Text(
                'Submit',
                style:
                    GoogleFonts.lexendDeca(fontSize: 16, color: Colors.white),
              ),
              onPressed: () async {
                if (_remarkController.text == null ||
                    _remarkController.text == "") {
                } else {
                  await FirebaseMethods()
                      .reviewQCData(
                          widget.chefId, "Rejected", _remarkController.text)
                      .then((value) => AlertMessage()
                          .showSnackBar(context, "Reviewed successfully"));
                  Navigator.pop(context);
                }
              },
            )
          ],
        );
      },
    );
  }

  Map<String, bool> questions = {
    "Question 1": false,
    "Question 2": false,
    "Question 3": false,
    "Question 4": false,
    "Question 5": false,
    "Question 6": false,
  };

  fetchData() {
    var keys = questions.keys.toList();
    for (int i = 0; i < 6; i++) {
      questions[keys[i]] = widget.values[i];
    }
    setState(() => loading = false);
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
                title: Text(
                  'QC Data',
                  style: GoogleFonts.lexendDeca(
                      color: Color(0xff002140), fontWeight: FontWeight.w800),
                ),
                iconTheme: IconThemeData(color: Colors.black),
                backgroundColor: Colors.white),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: ListView(
                      children: questions.keys.map((String key) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: Colors.white,
                            child: new CheckboxListTile(
                              activeColor: Color(0xFFFF785B),
                              checkColor: Colors.white,
                              title: new Text(
                                key,
                                style: GoogleFonts.lexendDeca(
                                  fontSize: 18.0,
                                ),
                              ),
                              secondary: Icon(Icons.question_answer,
                                  color: Color(0xFFFF785B)),
                              value: questions[key],
                              onChanged: null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.green),
                            ),
                            child: Text(
                              'Approve',
                              style: GoogleFonts.lexendDeca(
                                  color: Colors.white, fontSize: 18),
                            ),
                            onPressed: () async {
                              await FirebaseMethods()
                                  .reviewQCData(widget.chefId, "Approved", "")
                                  .then((value) => AlertMessage().showSnackBar(
                                      context, "Reviewed successfully"));
                            }),
                        TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red),
                            ),
                            child: Text(
                              'Reject',
                              style: GoogleFonts.lexendDeca(
                                  color: Colors.white, fontSize: 18),
                            ),
                            onPressed: () async {
                              await _giveRemark(context);
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
