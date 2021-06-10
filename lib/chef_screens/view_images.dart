import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class GalleryScreen extends StatefulWidget {
  final String text;
  GalleryScreen({Key key, @required this.text}) : super(key: key);
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

const kMainColor = Color(0xFFFF785B);
const kSubMainColor = Color(0xFFDEE8FF);
const headingColor = Color(0xFF002140);

class _GalleryScreenState extends State<GalleryScreen> {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
          title: Text(widget.text ?? "All cusines",
              style: GoogleFonts.lobster(
                  color: Color(0xff002140),
                  
                  fontSize: screenHeight * 0.034)),
          iconTheme: IconThemeData(color: headingColor),
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context, "");
            },
            child: Icon(Icons.arrow_back 
                ),
          )),
      backgroundColor: kSubMainColor,
      body: Container(
        padding: const EdgeInsets.all(8),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firebaseFirestore
              .collection("Food_images")
              .where("cuisine", isEqualTo: widget.text)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("There is some problem loading your images"),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Lottie.asset(
                    "assets/images/food-loading-animation.json",
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            } else if (snapshot.hasData) {
              List x = snapshot.data.docs;
              return GridView.builder(
                itemCount: x.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        (orientation == Orientation.portrait) ? 2 : 3),
                itemBuilder: (BuildContext context, int index) {
                  return new Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context, x[index]["imageurl"]);
                      },
                      child: new GridTile(
                          footer: Container(
                            color: Colors.black.withOpacity(0.7),
                            child: Center(
                                child: Text(x[index].id,
                                    style: GoogleFonts.oswald(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ))),
                          ),
                          child: Image.network(x[index][
                              "imageurl"]) //just for testing, will fill with image later
                          ),
                    ),
                  );
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
