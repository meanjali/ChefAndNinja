import 'package:flutter/material.dart';
import 'package:food_delivery_app/widgets/alert.dart';
import 'package:google_fonts/google_fonts.dart';

const kMainColor = Color(0xFFFF785B);
const kSubMainColor = Color(0xFFDEE8FF);
const headingColor = Color(0xFF002140);

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: kSubMainColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'FOOD APP',
                      style: GoogleFonts.titanOne(
                          color: headingColor, fontSize: 28),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    CircleAvatar(
                      maxRadius: 35,
                      backgroundColor: kMainColor,
                      child: Text(
                        "C",
                        style: TextStyle(color: headingColor, fontSize: 40.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.menu,
                color: kMainColor,
              ),
              title: Text('My Listing'),
              onTap: () =>
                  {Navigator.of(context).pushReplacementNamed('/my_listings')},
            ),
            Divider(color: kMainColor),
            ListTile(
                leading: Icon(
                  Icons.add_box,
                  color: kMainColor,
                ),
                title: Text('Add item '),
                onTap: () =>
                    {Navigator.of(context).pushReplacementNamed('/add_item')}
                // .pushNamedAndRemoveUntil('/add_item', (Route<dynamic> route) => false)}
                ),
            Divider(color: kMainColor),
            ListTile(
              leading: Icon(
                Icons.restaurant_menu,
                color: kMainColor,
              ),
              title: Text('Orders'),
              onTap: () =>
                  {Navigator.of(context).pushReplacementNamed('/my_orders')},
            ),
            Divider(color: kMainColor),
            ListTile(
              leading: Icon(
                Icons.account_balance_wallet,
                color: kMainColor,
              ),
              title: Text('My Account'),
              onTap: () =>
                  {Navigator.of(context).pushReplacementNamed('/my_account')},
            ),
            Divider(color: kMainColor),
            ListTile(
              leading: Icon(
                Icons.check_box,
                color: kMainColor,
              ),
              title: Text('QC Data'),
              onTap: () =>
                  {Navigator.of(context).pushReplacementNamed('/oc_data')},
            ),
            Divider(color: kMainColor),
            ListTile(
              leading: Icon(
                Icons.star,
                color: kMainColor,
              ),
              title: Text('My Reviews'),
              onTap: () =>
                  {Navigator.of(context).pushReplacementNamed('/my_reviews')},
            ),
            Divider(color: kMainColor),
            ListTile(
              leading: Icon(
                Icons.phone,
                color: kMainColor,
              ),
              title: Text('Contact Services'),
              onTap: () => {
                Navigator.of(context).pushReplacementNamed('/contact_service')
              },
            ),
            Divider(
              color: kMainColor,
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: kMainColor,
              ),
              title: Text('Logout', style: TextStyle(color: headingColor)),
              onTap: () async {
                AlertMessage()
                    .logOutAlert(context, "Are you sure you want to Logout");
              },
            ),
          ],
        ),
      ),
    );
  }
}
