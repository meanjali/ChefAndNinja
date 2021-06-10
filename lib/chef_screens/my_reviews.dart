import 'dart:ffi';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/widgets/chef_nav-drawer.dart';
import 'package:food_delivery_app/widgets/chef_appbar.dart';
import 'package:food_delivery_app/services/firebase_auth.dart';
import 'package:food_delivery_app/services/firebase_db_chef.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'dart:async';
const kMainColor = Color(0xFFFF785B);
const kSubMainColor = Color(0xFFDEE8FF);
const headingColor = Color(0xFF002140);

class MyReviews extends StatefulWidget {
  @override
  _MyReviewsState createState() => _MyReviewsState();
}

class _MyReviewsState extends State<MyReviews> {
  FirebaseServices _firebaseServices = FirebaseServices();
  final FirebaseMethodsChef _firebaseMethodsChef = FirebaseMethodsChef();
  
  @override
  Widget build(BuildContext context) {
    String chefId = _firebaseServices.getUserId();
   double _width = MediaQuery.of(context).size.width;

    return Scaffold(
        drawer: NavDrawer(),
        appBar: ChefAppbar('My Reviews'),
        body:Column( 
        children:[
          //CustomRatingBarRow(width: _width),
          Container(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Orders")
                  .where(
                    "chefId",
                    isEqualTo: chefId,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    if (snapshot.data != null) {
                      List res = List.from(snapshot.data.docs);
                      print(res);
                      var orders = [];
                      for (int i = 0; i < res.length; i++) {
                        var order = [];
                        DateFormat format = DateFormat("dd-MM-yyyy");
                        var modDate = format.format(DateFormat('d MMM yyyy')
                            .parse(res[i]['timeOrderPlaced']));
                        List dishNames = List.from(res[i]['dishName']);
                        var dishes = dishNames.join(' , ');
                        order.add(res[i]['userName']);
                        order.add(dishes);
                        order.add(res[i]['rating']);
                        order.add(res[i]['feedback']);
                        order.add(modDate.toString());
                        orders.add(order);
                      }
                      var temp = [];
                      for (int i = 0; i < orders.length - 1; i++) {
                        for (int j = 0; j < orders.length - i - 1; j++) {
                          if (orders[j][4].compareTo(orders[j + 1][4]) == -1) {
                            temp = orders[j];
                            orders[j] = orders[j + 1];
                            orders[j + 1] = temp;
                          }
                        }
                      }
                      print("heree $orders");
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: orders.length,
                          itemBuilder: (BuildContext context, int i) {
                            return ReviewTile(
                              name: orders[i][0],
                              dishname: orders[i][1],
                              stars: orders[i][2],
                              comment: orders[i][3],
                              date: orders[i][4],
                            );
                          });
                    }
                    return Container(child: Text("No reviews"));
                }
              }),
        ),
        // Container(
        // child:
        // Row(
        //    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,  
        //   children: [
        //     SizedBox(height:10,),
        //     Container(
        //        margin: EdgeInsets.all(12.0),  
        //       padding: EdgeInsets.all(20.0),  
        //       decoration:BoxDecoration(  
        //           borderRadius:BorderRadius.circular(8),  
        //           //color:kMainColor
        //       ),  
        //       child: Text(" 5-STAR ",textAlign:TextAlign.center,style: TextStyle(color:kMainColor,fontSize:20),),  
        //     ),
        //     Container(
        //              // margin: EdgeInsets.only(left:30,right:30),
        //               //alignment:Alignment.center,
        //               child: new LinearPercentIndicator(
        //             width: _width*0.4,
        //             lineHeight: 15.0,
        //             percent: 0.5,
        //             progressColor: Colors.orange,
        //           ),
        //             ),
        //     Container(
        //        margin: EdgeInsets.all(12.0),  
        //       padding: EdgeInsets.all(20.0),  
        //       decoration:BoxDecoration(  
        //           borderRadius:BorderRadius.circular(8),  
        //           //color:kMainColor
        //       ),  
        //       child: Text("50%",textAlign:TextAlign.center,style: TextStyle(color:kMainColor,fontSize:20),),  
        //     ),
        //   ],
        // ),
        // ),
        ],
        ),
        );
  }
}

class CustomRatingBarRow extends StatelessWidget {
  const CustomRatingBarRow({
    Key key,
    @required double width,
  }) : _width = width, super(key: key);

  final double _width;

  @override
  Widget build(BuildContext context) {
    return Container(
        child:
        Row(
           //mainAxisAlignment: MainAxisAlignment.spaceEvenly,  
          children: [
            SizedBox(height:10,),
            Container(
     margin: EdgeInsets.all(12.0),  
    padding: EdgeInsets.all(20.0),  
    decoration:BoxDecoration(  
        borderRadius:BorderRadius.circular(8),  
        //color:kMainColor
    ),  
    child: Text(" 5-STAR ",textAlign:TextAlign.center,style: TextStyle(color:kMainColor,fontSize:20),),  
            ),
            Container(
           // margin: EdgeInsets.only(left:30,right:30),
            //alignment:Alignment.center,
            child: new LinearPercentIndicator(
          width: _width*0.4,
          lineHeight: 15.0,
          percent: 0.5,
          progressColor: Colors.orange,
        ),
          ),
            Container(
     margin: EdgeInsets.all(12.0),  
    padding: EdgeInsets.all(20.0),  
    decoration:BoxDecoration(  
        borderRadius:BorderRadius.circular(8),  
        //color:kMainColor
    ),  
    child: Text("50%",textAlign:TextAlign.center,style: TextStyle(color:kMainColor,fontSize:20),),  
            ),
          ],
        ),
        );
  }
}

class ReviewTile extends StatelessWidget {
  final String dishname, date, name, comment;
  final double stars;
  ReviewTile({
    @required this.dishname,
    @required this.stars,
    @required this.date,
    @required this.name,
    @required this.comment,
  });
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: kSubMainColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name,
                  style: TextStyle(
                      color: kMainColor.withOpacity(0.8),
                      fontSize: _height * 0.0225,
                      fontWeight: FontWeight.w500)),
              Text(date,
                  style: TextStyle(
                      color: headingColor.withOpacity(0.5),
                      fontSize: _height * 0.0225,
                      fontWeight: FontWeight.w400))
            ],
          ),
          RatingBarIndicator(
            rating: stars.toDouble(),
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: _height * 0.027,
            unratedColor: Colors.grey[500],
            direction: Axis.horizontal,
          ),
          // IconTheme(
          //   data: IconThemeData(
          //     color: Colors.amber,
          //     size: _height * 0.027,
          //   ),
          //   child: StarDisplay(value: stars),
          // ),
          Text(dishname,
              style: TextStyle(
                  color: kMainColor,
                  fontSize: _height * 0.025,
                  fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(comment,
                style: TextStyle(
                    color: headingColor,
                    fontSize: _height * 0.0235,
                    fontWeight: FontWeight.w400)),
          )
        ],
      ),
    );
  }
}

class StarDisplay extends StatelessWidget {
  final int value;
  const StarDisplay({Key key, this.value = 0})
      : assert(value != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < value ? Icons.star : Icons.star_border,
        );
      }),
    );
  }
}
