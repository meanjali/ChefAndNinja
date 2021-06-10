import 'package:flutter/material.dart';
import 'package:food_delivery_app/widgets/alert.dart';
import 'package:food_delivery_app/widgets/chef_nav-drawer.dart';
import 'package:food_delivery_app/services/firebase_db_chef.dart';
import 'package:food_delivery_app/widgets/custom_listtile.dart';
import 'package:food_delivery_app/chef_screens/my_listing_now.dart';
import 'package:food_delivery_app/chef_screens/my_listing_later.dart';
import 'package:food_delivery_app/chef_screens/my_listing_today.dart';
import 'package:food_delivery_app/chef_screens/my_listing_tomorrow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:food_delivery_app/chef_screens/my_listing_meal_daily.dart';

const kMainColor = Color(0xFFFF785B);
const kSubMainColor = Color(0xFFDEE8FF);
const headingColor = Color(0xFF002140);

class MyListings extends StatefulWidget {
  final String screenName = 'My Listings';
  @override
  _MyListingsState createState() => _MyListingsState();
}

class _MyListingsState extends State<MyListings> {
  final FirebaseMethodsChef _firebaseMethodsChef = FirebaseMethodsChef();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: headingColor),
          backgroundColor: Colors.white,
          title: Text(widget.screenName,
              style: GoogleFonts.lobster(
                  color: Color(0xff002140),
                  fontSize: screenHeight * 0.034)),
          centerTitle: true,
          actions: [
            IconButton(
                padding: EdgeInsets.only(left: 5.0),
                iconSize: 30,
                icon: Icon(Icons.exit_to_app, color: headingColor),
                onPressed: () async {
                  AlertMessage()
                      .logOutAlert(context, "Are you sure you want to Logout");
                })
          ],
          bottom: TabBar(
            isScrollable: true,
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: kMainColor, width: 5.0)),
            tabs: <Widget>[
              Tab(
                  child:
                      Text('   NOW   ', style: TextStyle(color: kMainColor))),
              Tab(
                  child:
                      Text('  LATER  ', style: TextStyle(color: kMainColor))),
              // Tab(
              //     child:
              //         Text('  TODAY  ', style: TextStyle(color: kMainColor))),
              Tab(
                  child:
                      Text(' TOMORROW ', style: TextStyle(color: kMainColor))),
              Tab(
                  child: Text(' MEAL DAILY ',
                      style: TextStyle(color: kMainColor))),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            MyListingNow(),
            MyListingLater(),
            //MyListingToday(),
            MyListingTomorrow(),
            MyListingMealDaily(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
          child: SizedBox(
            width: screenWidth * 0.15,
            height: screenHeight * 0.077,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).popAndPushNamed('/add_item');
              },
              child: Icon(
                Icons.add,
                size: screenHeight * 0.05,
              ),
              elevation: 10.0,
              backgroundColor: kMainColor,
            ),
          ),
        ),
      ),
    );
  }
}
