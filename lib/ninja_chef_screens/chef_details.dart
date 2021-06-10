import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

const kMainColor = Color(0xFFFF785B);
const kSubMainColor = Color(0xFFDEE8FF);
const headingColor = Color(0xFF002140);

class ChefDetails extends StatefulWidget {
  final String chefName;
  final dynamic rating;
  final dynamic totalEarning;
  final int orderServed;
  final String imageUrl;
  ChefDetails(this.chefName, this.rating, this.totalEarning, this.orderServed,
      this.imageUrl);
  @override
  _ChefDetailsState createState() => _ChefDetailsState();
}

class _ChefDetailsState extends State<ChefDetails> {
  String type;
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  String leaveType;
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  String desc;
  final from = TextEditingController(); //from
  final to = TextEditingController(); //to
  int differ = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                color: Colors.white,
                child: Container(
                  // width: double.infinity,
                  width: (MediaQuery.of(context).size.width),
                  //height: 350.0,
                  height: (MediaQuery.of(context).size.height),
                  child: Center(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: widget.imageUrl == ""
                              ? AssetImage("assets/images/dummy.png")
                              : NetworkImage(
                                  widget.imageUrl,
                                ),
                          radius: MediaQuery.of(context).size.width * 0.15,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(widget.chefName,
                            style: GoogleFonts.lexendDeca(
                                fontSize: 25, fontWeight: FontWeight.w600)),
                        SizedBox(
                          height: 10.0,
                        ),
                        Card(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          clipBehavior: Clip.antiAlias,
                          color: kSubMainColor,
                          elevation: 5.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 22.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Text("Ratings",
                                          style: GoogleFonts.lexendDeca(
                                              fontSize: 25,
                                              color: kMainColor,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      RatingBarIndicator(
                                        rating: widget.rating.toDouble(),
                                        itemBuilder: (context, index) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        itemCount: 5,
                                        itemSize: 40,
                                        unratedColor: Colors.grey[500],
                                        direction: Axis.horizontal,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Card(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          clipBehavior: Clip.antiAlias,
                          color: kSubMainColor,
                          elevation: 5.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 22.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Text("Orders Served",
                                          style: GoogleFonts.lexendDeca(
                                              fontSize: 25,
                                              color: kMainColor,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(widget.orderServed.toString(),
                                          style: GoogleFonts.lexendDeca(
                                              fontSize: 22,
                                              color: headingColor,
                                              fontWeight: FontWeight.w500))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Card(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          clipBehavior: Clip.antiAlias,
                          color: kSubMainColor,
                          elevation: 5.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 22.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Text("Income",
                                          style: GoogleFonts.lexendDeca(
                                              fontSize: 25,
                                              color: kMainColor,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          // Text("From",
                                          //     style: GoogleFonts.lexendDeca(
                                          //         fontSize: 15,
                                          //         color: headingColor,
                                          //         fontWeight: FontWeight.bold),
                                          //     textAlign: TextAlign.left),
                                          // Center(
                                          //   child: TextField(
                                          //       readOnly: true,
                                          //       controller: from,
                                          //       decoration: InputDecoration(
                                          //           hintText:
                                          //               'Pick your Start Date',
                                          //           hintStyle: GoogleFonts
                                          //               .lexendDeca()),
                                          //       onTap: () async {
                                          //         var date =
                                          //             await showDatePicker(
                                          //                 context: context,
                                          //                 initialDate:
                                          //                     DateTime.now(),
                                          //                 firstDate:
                                          //                     DateTime(1900),
                                          //                 lastDate:
                                          //                     DateTime(2100));
                                          //         from.text =
                                          //             formatter.format(date);
                                          //         fromDate = date;
                                          //       }),
                                          // ),
                                        ], //contianer
                                      ), //column
                                      // Column(
                                      //   children: <Widget>[
                                      //     SizedBox(
                                      //       height: 8.0,
                                      //     ),
                                      //     Text("To",
                                      //         style: TextStyle(
                                      //             fontSize: 15,
                                      //             color: headingColor,
                                      //             fontWeight: FontWeight.bold),
                                      //         textAlign: TextAlign.left),
                                      //     Center(
                                      //       child: TextField(
                                      //           readOnly: true,
                                      //           controller: to,
                                      //           decoration: InputDecoration(
                                      //               hintText:
                                      //                   'Pick your End  Date',
                                      //               hintStyle: GoogleFonts
                                      //                   .lexendDeca()),
                                      //           onTap: () async {
                                      //             var date =
                                      //                 await showDatePicker(
                                      //                     context: context,
                                      //                     initialDate:
                                      //                         DateTime.now(),
                                      //                     firstDate:
                                      //                         DateTime(1900),
                                      //                     lastDate:
                                      //                         DateTime(2100));
                                      //             to.text =
                                      //                 formatter.format(date);
                                      //             toDate = date;
                                      //           }),
                                      //     ),
                                      //   ], //contianer
                                      // ),
                                      SizedBox(
                                        height: 15.0,
                                      ),
                                      Text(
                                          "Rs. " +
                                              widget.totalEarning.toString(),
                                          style: GoogleFonts.lexendDeca(
                                              fontSize: 22,
                                              color: headingColor,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
