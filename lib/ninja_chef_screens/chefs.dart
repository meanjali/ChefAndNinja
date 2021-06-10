import 'package:flutter/material.dart';
import 'package:food_delivery_app/ninja_chef_screens/chef_details.dart';
import 'package:food_delivery_app/services/firebase_db.dart';
import 'package:food_delivery_app/widgets/alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:food_delivery_app/widgets/ninja_chef_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Chefs extends StatefulWidget {
  final String screenName = 'Chefs';
  @override
  _ChefsState createState() => _ChefsState();
}

class _ChefsState extends State<Chefs> {
  Stream chefs;
  bool loading = true;

  Future<void> fetchData() async {
    chefs = FirebaseMethods().getChefDetails();
    setState(() => loading = false);
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          widget.screenName,
          style: GoogleFonts.lexendDeca(
              color: Color(0xff002140),
              fontWeight: FontWeight.w800,
              fontSize: 22),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.logout, color: Colors.black, size: 25),
              onPressed: () async {
                AlertMessage()
                    .logOutAlert(context, "Are you sure you want to Logout");
              })
        ],
      ),
      drawer: NinjaChefDrawer(widget.screenName),
      body: Container(
        margin: EdgeInsets.all(10),
        child: loading == false
            ? StreamBuilder(
                stream: chefs,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFFFF785B),
                        ),
                      ),
                    );
                  } else {
                    if (snapshot.hasData && snapshot.data.docs.length > 0) {
                      return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot ds = snapshot.data.docs[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              margin: EdgeInsets.all(6),
                              padding: EdgeInsets.all(5),
                              child: ListTile(
                                tileColor: Colors.white,
                                leading: CircleAvatar(
                                  radius:
                                      MediaQuery.of(context).size.width * 0.06,
                                  backgroundImage: ds.data()["imageUrl"] == ""
                                      ? AssetImage("assets/images/dummy.png")
                                      : NetworkImage(
                                          ds.data()["imageUrl"],
                                        ),
                                ),
                                title: Text(
                                  '${ds.data()["fname"]} ${ds.data()["lname"]}',
                                  style: GoogleFonts.lexendDeca(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                subtitle: RatingBarIndicator(
                                  rating: ds.data()["rating"].toDouble(),
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 20,
                                  unratedColor: Colors.grey[300],
                                  direction: Axis.horizontal,
                                ),
                                trailing: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Color(0xFFFF785B),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChefDetails(
                                          ds.data()["fname"] +
                                              " " +
                                              ds.data()["lname"],
                                          ds.data()["rating"],
                                          ds.data()["totalEarning"],
                                          ds.data()["orderServed"],
                                          ds.data()["imageUrl"],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Details',
                                    style: GoogleFonts.lexendDeca(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ),
                              ),
                            );
                          });
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/no_sub.png',
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "No chefs",
                              style: GoogleFonts.lexendDeca(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
              )
            : Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFFFF785B),
                  ),
                ),
              ),
      ),
    );
  }
}
