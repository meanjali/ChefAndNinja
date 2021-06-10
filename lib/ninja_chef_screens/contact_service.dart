import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/services/firebase_db.dart';
import 'package:food_delivery_app/widgets/alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:food_delivery_app/widgets/ninja_chef_drawer.dart';

class ContactServiceNinja extends StatefulWidget {
  @override
  _ContactServiceNinjaState createState() => _ContactServiceNinjaState();
}

class _ContactServiceNinjaState extends State<ContactServiceNinja> {
  TextEditingController _feedbackController = new TextEditingController();
  bool error = false;
  bool validFeedback() {
    if (_feedbackController.text == null || _feedbackController.text == "") {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text('Contact Service',
              style: GoogleFonts.lexendDeca(
                  color: Color(0xff002140), fontWeight: FontWeight.w800)),
          centerTitle: true,
          actions: [
            IconButton(
                icon: Icon(Icons.logout, color: Colors.black, size: 25),
                onPressed: () async {
                  AlertMessage()
                      .logOutAlert(context, "Are you sure you want to Logout");
                })
          ]),
      drawer: NinjaChefDrawer('Contact Service'),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
        child: Column(
          children: [
            SizedBox(height: 30),
            Text('Write to us',
                style: GoogleFonts.montserrat(
                    fontSize: 20, fontWeight: FontWeight.w500)),
            SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.black),
                  right: BorderSide(color: Colors.black),
                  bottom: BorderSide(color: Colors.black),
                  left: BorderSide(color: Colors.black),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.only(left: 12),
              child: TextField(
                onChanged: (value) => setState(() => error = false),
                controller: _feedbackController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Write a feedback / question',
                  hintStyle: GoogleFonts.montserrat(),
                ),
              ),
            ),
            SizedBox(height: 12),
            error
                ? Text(
                    "Feedback cannot be empty!",
                    style: TextStyle(color: Colors.red),
                  )
                : SizedBox(),
            SizedBox(height: 12),
            TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFFFF785B))),
              onPressed: () async {
                if (validFeedback()) {
                  FirebaseMethods().ninjaChefFeedback(
                      context,
                      _feedbackController.text,
                      FirebaseAuth.instance.currentUser.uid);
                } else {
                  setState(() => error = true);
                }
              },
              child: Text(
                'Submit',
                style:
                    GoogleFonts.montserrat(color: Colors.white, fontSize: 15),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'OR',
              style: GoogleFonts.montserrat(fontSize: 18),
            ),
            SizedBox(height: 12),
            Platform.isIOS
                ? CupertinoButton.filled(
                    borderRadius: BorderRadius.circular(12),
                    child: Text(
                      'Call: 8097161996',
                      style: GoogleFonts.montserrat(fontSize: 16),
                    ),
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) {
                          return CupertinoActionSheet(
                            actions: [
                              CupertinoActionSheetAction(
                                child: Text(
                                  'Call 8097161996',
                                  style: GoogleFonts.montserrat(fontSize: 16),
                                ),
                                isDefaultAction: true,
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.montserrat(fontSize: 16),
                              ),
                              isDestructiveAction: true,
                              onPressed: () => Navigator.pop(context),
                            ),
                          );
                        },
                      );
                    },
                  )
                : TextButton(
                    child: Text(
                      'Call: 8097161996',
                      style: GoogleFonts.montserrat(fontSize: 16),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                  'Call 8097161996',
                                  style: GoogleFonts.montserrat(fontSize: 16),
                                ),
                                onTap: () => Navigator.pop(context),
                              ),
                              ListTile(
                                title: Text(
                                  'Cancel',
                                  style: GoogleFonts.montserrat(fontSize: 16),
                                ),
                                onTap: () => Navigator.pop(context),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
