import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/widgets/alert.dart';

class FirebaseMethods {
  // Add details of Chef/Ninja in firestore
  storeUserDetails(
      String uid, String fname, String lname, String phoneNum, String role,
      [String address]) async {
    if (role == 'Chef') {
      FirebaseFirestore.instance.collection('Chef').doc(uid).set({
        'fname': fname,
        'lname': lname,
        'phoneNum': phoneNum,
        'rating': 0,
        'orderServed': 0,
        'imageUrl': "",
        'totalEarning': 0,
        'chefAddress': address
      });
    } else {
      return FirebaseFirestore.instance
          .collection('Ninja')
          .doc(uid)
          .set({'fname': fname, 'lname': lname, 'phoneNum': phoneNum});
    }
  }

  // check whether user already exists
  Future<bool> userExists(
      BuildContext context, String phoneNum, String role) async {
    bool retVal = true;
    await FirebaseFirestore.instance
        .collection(role)
        .where('phoneNum', isEqualTo: phoneNum)
        .get()
        .then((ninja) async {
      if (ninja.docs.isEmpty) {
        retVal = false;
      }
    });
    return retVal;
  }

  // get chef detalis
  Stream<QuerySnapshot> getChefDetails() {
    return FirebaseFirestore.instance.collection('Chef').snapshots();
  }

  // update profile picture of Ninja
  Future<void> updateNinjaProfilePic(
      BuildContext context, String uid, String url) async {
    await FirebaseFirestore.instance
        .collection('Ninja')
        .doc(uid)
        .update({"imageUrl": url}).catchError(
      (error) => AlertMessage()
          .showAlertDialog(context, "Error", "Something went wrong"),
    );
  }

  // feedback by ninja
  ninjaChefFeedback(BuildContext context, String feedback, String uid) async {
    await FirebaseFirestore.instance
        .collection("NinjaFeedback")
        .add({"ninja_uid": uid, "feedback": feedback})
        .then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Feedback Submitted!"),
            ),
          ),
        )
        .catchError((error) {
          AlertMessage()
              .showAlertDialog(context, "Error", "Something went wrong");
        });
  }

  // recommendation by ninja
  submitRecommendation(
      BuildContext context,
      String name,
      String contactNo,
      String cookingExp,
      String profession,
      String address,
      String kitchenPref,
      String typeOfVehicle) async {
    await FirebaseFirestore.instance
        .collection('Recommendation')
        .add({
          'name': name,
          'contactNo': contactNo,
          'cookingExp': cookingExp,
          'profession': profession,
          'address': address,
          'kitchenPref': kitchenPref,
          'typeOfVehicle': typeOfVehicle
        })
        .then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Submitted successfully"),
            ),
          ),
        )
        .catchError(
          () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Something went wrong'),
            ),
          ),
        );
  }

  Stream<QuerySnapshot> getQCData(String date) {
    return FirebaseFirestore.instance
        .collection('QCData')
        .where('date', isEqualTo: date)
        .snapshots();
  }

  Future<void> reviewQCData(String chefId, String status, String remark) async {
    await FirebaseFirestore.instance
        .collection('QCData')
        .doc(chefId)
        .update({'status': status, 'comment': remark});
  }

  contactService(BuildContext context, String feedback, String chefId) async {
    await FirebaseFirestore.instance
        .collection("Contact_service_chef")
        .add({"chefId": chefId, "feedback": feedback})
        .then((value) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Feedback Submitted!"))))
        .catchError((error) {
          AlertMessage()
              .showAlertDialog(context, "Error", "Something went wrong");
        });
  }
}
