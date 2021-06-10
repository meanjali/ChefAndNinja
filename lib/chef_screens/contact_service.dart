import 'package:flutter/material.dart';
// import 'package:food_delivery_app/chef_screens/order_details.dart';
import 'package:food_delivery_app/widgets/chef_nav-drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:food_delivery_app/widgets/chef_appbar.dart';
import 'package:food_delivery_app/services/firebase_db.dart';
import 'package:food_delivery_app/widgets/alert.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_auth/firebase_auth.dart';

const kMainColor = Color(0xFFFF785B);
const kSubMainColor = Color(0xFFDEE8FF);
const headingColor = Color(0xFF002140);
_makingPhoneCall() async {
  const url = 'tel:8097161996';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class ContactService extends StatefulWidget {
  @override
  _ContactServiceState createState() => _ContactServiceState();
}

class _ContactServiceState extends State<ContactService> {
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
      drawer: NavDrawer(),
      appBar: ChefAppbar('Contact services'),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 40.0,
            ),
            ElevatedButton(
              child: Text(
                'Contact : 809716191996',
                style: TextStyle(fontSize: 20.0, color: headingColor),
              ),
              onPressed: _makingPhoneCall,
            ),
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Text("OR",
                  style: TextStyle(color: headingColor, fontSize: 20)),
            ),
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Text("Write to Us",
                  style: TextStyle(color: headingColor, fontSize: 20)),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                onChanged: (value) => setState(() => error = false),
                controller: _feedbackController,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: kSubMainColor,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                    ),
                    primary: kMainColor),
                onPressed: () async {
                  if (validFeedback()) {
                    FirebaseMethods().contactService(
                        context,
                        _feedbackController.text,
                        FirebaseAuth.instance.currentUser.uid);
                  } else {
                    setState(() => error = true);
                  }
                },
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 20, color: headingColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
