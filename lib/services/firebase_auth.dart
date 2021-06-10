import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/widgets/alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_db.dart';

class FirebaseServices {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  String getUserId() {
    return _firebaseAuth.currentUser.uid;
  }

  // otp verification
  Future<void> phoneNumberVerification(
      String phoneNumber, String role, bool register, BuildContext context,
      [String fname, String lname, String address]) async {
    final TextEditingController _codeController = TextEditingController();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        // timeout: Duration(seconds: 60),
        verificationCompleted: null, // no auto complete
        verificationFailed: (FirebaseAuthException authException) {
          AlertMessage().showAlertDialog(context, "Error", authException.code);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                String errorText = "";
                return StatefulBuilder(builder: (context, setState) {
                  return AlertDialog(
                    title: Center(
                      child: Text(
                        "Enter Verification Code",
                        style: GoogleFonts.lexendDeca(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          style: GoogleFonts.lexendDeca(
                              fontWeight: FontWeight.bold),
                          controller: _codeController,
                          maxLength: 6,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            setState(() => errorText = "");
                          },
                        ),
                        errorText == ""
                            ? SizedBox()
                            : Text(
                                errorText,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 14),
                              )
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () async {
                          final code = _codeController.text.trim();
                          AuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: code);
                          UserCredential userCredential = await _auth
                              .signInWithCredential(credential)
                              .catchError((error) {
                            if (error.code == "session-expired") {
                              // when user enters incorrect otp for 3 times
                              Navigator.pop(context);
                              AlertMessage().showAlertDialog(context, "Error",
                                  "Session Expired! Please try again");
                            } else {
                              setState(() => errorText = error.code);
                            }
                          });
                          if (userCredential != null) {
                            setState(() => errorText = "");
                            if (register) {
                              User user = userCredential.user;
                              // store details of new user
                              await FirebaseMethods().storeUserDetails(user.uid,
                                  fname, lname, phoneNumber, role, address);
                            }

                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setString('role', role);
                            if (role == 'Chef') {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/my_account', (route) => false);
                            } else {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/chefs', (route) => false);
                            }
                          }
                        },
                        child: Center(
                          child: Text(
                            "Confirm",
                            style: GoogleFonts.lexendDeca(color: Colors.white),
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFFFF785B)),
                        ),
                      )
                    ],
                  );
                });
              });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print(verificationId);
        });
  }

  // get current logged in user
  Future<User> getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }
}
