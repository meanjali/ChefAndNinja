// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_delivery_app/auth_screens/sign_in.dart';

// import 'package:food_delivery_app/auth_screens/temp.dart';

import 'package:food_delivery_app/chef_screens/add_item_form.dart';
import 'package:food_delivery_app/chef_screens/my_account.dart';
import 'package:food_delivery_app/chef_screens/my_listings.dart';
import 'package:food_delivery_app/chef_screens/my_orders.dart';
import 'package:food_delivery_app/chef_screens/contact_service.dart';
import 'package:food_delivery_app/chef_screens/my_reviews.dart';
import 'package:food_delivery_app/chef_screens/qc_data.dart';
import 'package:food_delivery_app/ninja_chef_screens/chefs.dart';
import 'package:food_delivery_app/services/firebase_auth.dart';
import 'package:food_delivery_app/widgets/loading.dart';
import 'package:food_delivery_app/widgets/wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          // '/': (context) => Chefs(),
          '/chef': (context) => MyListings(),
          '/my_listings': (context) => MyListings(),
          '/add_item': (context) => AddItem(),
          '/my_orders': (context) => MyOrders(),
          '/my_account': (context) => MyAccount(),
          '/oc_data': (context) => QCData(),
          '/my_reviews': (context) => MyReviews(),
          '/contact_service': (context) => ContactService(),
          '/chefs': (context) => Chefs()
        },
        home: FutureBuilder(
            future: FirebaseServices().getCurrentUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loading();
              } else {
                if (snapshot.hasData) {
                  return Wrapper();
                } else {
                  return SignIn();
                }
              }
            }));
  }
}
