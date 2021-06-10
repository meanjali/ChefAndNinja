// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/widgets/alert.dart';
import 'package:google_fonts/google_fonts.dart';

const kMainColor = Color(0xFFFF785B);
const kSubMainColor = Color(0xFFDEE8FF);
const headingColor = Color(0xFF002140);

class ChefAppbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(55);
  final screenName;
  ChefAppbar(this.screenName);
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return AppBar(
        title: Text(screenName,
            style: GoogleFonts.lobster(
                  color: Color(0xff002140),
                  //fontWeight: FontWeight.w600,
                  fontSize: screenHeight*0.034)),
        backgroundColor: Colors.white,
        // shadowColor: kMainCol
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context, "");
              Navigator.of(context).pushNamed('/my_listings');
            },
            child: Icon(Icons.arrow_back // add custom icons also
                ),
          ),
         centerTitle: true,
        iconTheme: IconThemeData(color: headingColor),
        actions: <Widget>[
          //  Icon(Icons.person, size: 32),
          IconButton(
            padding: EdgeInsets.only(left: 5.0),
            iconSize: 30,
           icon: Icon(Icons.exit_to_app, color: headingColor),
                onPressed: () async {
                  AlertMessage()
                      .logOutAlert(context, "Are you sure you want to Logout");
                })
        ]);
  }
}

