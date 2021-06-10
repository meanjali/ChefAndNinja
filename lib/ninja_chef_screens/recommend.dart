import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/services/firebase_db.dart';
import 'package:food_delivery_app/widgets/alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:food_delivery_app/widgets/ninja_chef_drawer.dart';

class Recommend extends StatefulWidget {
  @override
  _RecommendState createState() => _RecommendState();
}

class _RecommendState extends State<Recommend> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _cookingExpController = TextEditingController();
  TextEditingController _professionController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _kitchenPrefController = TextEditingController();
  TextEditingController _typeOfVehicleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    bool dark = media.platformBrightness == Brightness.dark;

    final _formKey = GlobalKey<FormState>();

    Widget formRow(
        String title, String placeholder, TextEditingController controller,
        {TextInputType board, Function valid}) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          decoration: BoxDecoration(
            color: dark ? Colors.grey[700] : Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Container(
                //remove this width property if you dont want fixed size here
                width: 80,
                child: Text('$title: '),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                    color: dark ? Colors.grey[500] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextFormField(
                    controller: controller,
                    autocorrect: false,
                    validator: valid ??
                        (value) {
                          if (value.isEmpty) {
                            return 'This field can\'t be empty';
                          }
                          return null;
                        },
                    keyboardType: board ?? TextInputType.name,
                    decoration: InputDecoration(
                      hintText: '$placeholder',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text('Recommend',
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
      drawer: NinjaChefDrawer('Recommend'),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
              child: Form(
                key: _formKey,
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  children: [
                    formRow('Name', 'Enter your name', _nameController),
                    formRow('Contact No.', 'Enter your contact number',
                        _contactController, board: TextInputType.number,
                        valid: (String value) {
                      if (value.isEmpty) {
                        return 'This field can\'t be empty';
                      } else if (value.length == 10) {
                        return 'This number should be of 10 digits';
                      }
                      return null;
                    }),
                    formRow('Cooking Exp', 'Experience in cooking',
                        _cookingExpController),
                    formRow('Profession', 'Your profession here',
                        _professionController),
                    formRow(
                        'Address', 'Enter your address', _addressController),
                    formRow('Kitchen Pref.', 'type anything here',
                        _kitchenPrefController),
                    formRow('Type of vehicle', 'type anything here',
                        _typeOfVehicleController)
                  ],
                ),
              ),
            ),
          ),
          Platform.isIOS
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: CupertinoButton.filled(
                    borderRadius: BorderRadius.circular(12),
                    child: Text('Submit'),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await FirebaseMethods().submitRecommendation(
                            context,
                            _nameController.text,
                            _contactController.text,
                            _cookingExpController.text,
                            _professionController.text,
                            _addressController.text,
                            _kitchenPrefController.text,
                            _typeOfVehicleController.text);
                      }
                    },
                  ),
                )
              : TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFFFF785B))),
                  child: Text(
                    'Submit',
                    style: GoogleFonts.montserrat(
                        fontSize: 16, color: Colors.white),
                  ),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {}
                  },
                )
        ],
      ),
    );
  }
}
