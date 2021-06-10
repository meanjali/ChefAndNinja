import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/ninja_chef_screens/contact_service.dart';
import 'package:food_delivery_app/ninja_chef_screens/qc_data.dart';
import 'package:food_delivery_app/ninja_chef_screens/chefs.dart';
import 'package:food_delivery_app/ninja_chef_screens/recommend.dart';
import 'package:food_delivery_app/services/firebase_db.dart';
import 'package:food_delivery_app/widgets/alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class NinjaChefDrawer extends StatefulWidget {
  final String activePageName;
  NinjaChefDrawer(this.activePageName);
  @override
  _NinjaChefDrawerState createState() => _NinjaChefDrawerState();
}

class _NinjaChefDrawerState extends State<NinjaChefDrawer> {
  DocumentSnapshot ninja;
  String profilePicUrl;

  fetchData() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection('Ninja')
        .where('phoneNum',
            isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber)
        .get();
    if (qs.docs.isEmpty == false) {
      ninja = qs.docs[0];
    }
    setState(() => profilePicUrl = ninja.data()["imageUrl"]);
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: MediaQuery.of(context).size.width * 0.55,
      child: Drawer(
        child: ListView(children: [
          DrawerHeader(
            child: Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: width * 0.08,
                        backgroundImage:
                            (profilePicUrl == null || profilePicUrl == "")
                                ? AssetImage("assets/images/dummy.png")
                                : NetworkImage(profilePicUrl),
                      ),
                      Positioned(
                        child: GestureDetector(
                            child: Image.asset(
                              'assets/images/camera.png',
                              width: width * 0.05,
                            ),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: ((builder) =>
                                    bottomSheet(context, profilePicUrl)),
                              );
                            }),
                        top: width * 0.11,
                        left: width * 0.11,
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    ninja == null
                        ? ""
                        : (ninja.data()["fname"] + " " + ninja.data()["lname"]),
                    style: GoogleFonts.lexendDeca(
                        fontSize: 18,
                        color: Color(0xff002140),
                        fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Color(0xFFFF785B),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.local_dining,
                color: widget.activePageName == 'Chefs'
                    ? Color(0xff002140)
                    : Colors.grey,
                size: 25),
            title: Text(
              'Chefs',
              style: GoogleFonts.lexendDeca(
                  color: widget.activePageName == 'Chefs'
                      ? Color(0xff002140)
                      : Colors.grey,
                  fontSize: 17,
                  fontWeight: widget.activePageName == 'Chefs'
                      ? FontWeight.w800
                      : FontWeight.w500),
            ),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Chefs(),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check_circle,
                color: widget.activePageName == 'QC Data'
                    ? Color(0xff002140)
                    : Colors.grey,
                size: 25),
            title: Text(
              'QC Data',
              style: GoogleFonts.lexendDeca(
                  color: widget.activePageName == 'QC Data'
                      ? Color(0xff002140)
                      : Colors.grey,
                  fontSize: 17,
                  fontWeight: widget.activePageName == 'QC Data'
                      ? FontWeight.w800
                      : FontWeight.w500),
            ),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => QCDataNinja(),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.thumb_up,
              color: widget.activePageName == 'Recommend'
                  ? Color(0xff002140)
                  : Colors.grey,
              size: 25,
            ),
            title: Text(
              'Recommend',
              style: GoogleFonts.lexendDeca(
                  color: widget.activePageName == 'Recommend'
                      ? Color(0xff002140)
                      : Colors.grey,
                  fontSize: 17,
                  fontWeight: widget.activePageName == 'Recommend'
                      ? FontWeight.w800
                      : FontWeight.w500),
            ),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Recommend(),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.contact_phone,
                color: widget.activePageName == 'Contact Service'
                    ? Color(0xff002140)
                    : Colors.grey,
                size: 25),
            title: Text(
              'Contact Service',
              style: GoogleFonts.lexendDeca(
                  color: widget.activePageName == 'Contact Service'
                      ? Color(0xff002140)
                      : Colors.grey,
                  fontSize: 17,
                  fontWeight: widget.activePageName == 'Contact Service'
                      ? FontWeight.w800
                      : FontWeight.w500),
            ),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ContactServiceNinja(),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  uploadImage() async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile photo;
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      try {
        photo = await _picker.getImage(source: ImageSource.gallery);
        var file = File(photo.path);
        if (photo != null) {
          final Reference firebaseStorageRef = _storage
              .ref()
              .child("ninjas/${FirebaseAuth.instance.currentUser.uid}");
          final TaskSnapshot taskSnapshot =
              await firebaseStorageRef.putFile(file);
          String url = await taskSnapshot.ref.getDownloadURL();
          await FirebaseMethods().updateNinjaProfilePic(
              context, FirebaseAuth.instance.currentUser.uid, url);
          setState(() => profilePicUrl = url);
        }
      } catch (error) {
        AlertMessage()
            .showAlertDialog(context, "Error", "Something went wrong");
      }
    } else {
      AlertMessage().showAlertDialog(
          context, "Error", "We require the permission to access your gallery");
    }
  }

  // provides the user options for removing profile pic and add new profile pic
  Widget bottomSheet(BuildContext context, String imageUrl) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: imageUrl == null
                  ? null
                  : () async {
                      await FirebaseMethods().updateNinjaProfilePic(
                          context, FirebaseAuth.instance.currentUser.uid, "");
                      setState(() => profilePicUrl = "");
                      Navigator.pop(context);
                    },
              child: Text(
                "REMOVE PROFILE PICTURE",
                style: TextStyle(
                  color: imageUrl == "" || imageUrl == null
                      ? Colors.grey
                      : Color(0xff002140),
                ),
              ),
            ),
          ),
          Expanded(
            child: TextButton.icon(
              onPressed: () async {
                await uploadImage();
                Navigator.pop(context);
              },
              icon: Icon(Icons.camera, color: Color(0xff002140)),
              label: Text(
                "CHOOSE IMAGE",
                style: TextStyle(
                  color: Color(0xff002140),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
