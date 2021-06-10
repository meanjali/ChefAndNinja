import 'package:flutter/material.dart';
import 'package:food_delivery_app/chef_screens/my_listings.dart';
import 'package:food_delivery_app/ninja_chef_screens/chefs.dart';
import 'package:food_delivery_app/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_delivery_app/auth_screens/sign_in.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool showNinja = false;
  bool loading = true;

  void checkIfUserIsChefOrNinja() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('role')) {
      String role = prefs.getString('role');
      if (role != 'Chef') {
        showNinja = true;
      }
      loading = false;
      setState(() {});
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => SignIn(),
          ),
          (route) => false);
    }
  }

  @override
  void initState() {
    checkIfUserIsChefOrNinja();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Loading();
    } else {
      if (showNinja) {
        return Chefs();
      } else {
        return MyListings();
      }
    }
  }
}
