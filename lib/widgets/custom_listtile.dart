import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const kMainColor = Color(0xFFFF785B);
const kSubMainColor = Color(0xFFDEE8FF);
const headingColor = Color(0xFF002140);

class MyListTile extends StatelessWidget {
  final String dishname, fromtime, totime;
  final int totquantity, price;
  //  final int totquantity, orderStatus;
  MyListTile(
      {@required this.dishname,
      @required this.fromtime,
      @required this.totime,
      @required this.totquantity,
      @required this.price});
  @override
  Widget build(BuildContext context) {
    String fromtimeNew = "",
        totimeNew = "",
        fromStart = "",
        fromEnd = "",
        toStart = "",
        toEnd = "";

      fromStart = fromtime.substring(0, 2);
      fromEnd = fromtime.substring(2);
      toStart = totime.substring(0, 2);
      toEnd = totime.substring(2);
      int from = int.parse(fromStart);
      int to = int.parse(toStart);
      if (from > 12) {
        from = from - 12;
        fromStart = from.toString();
        fromtimeNew = fromStart + fromEnd + " PM";
      } else if (from == 12) {
        fromtimeNew = fromtime + " PM";
      } else {
        fromtimeNew = fromtime + " AM";
      }
      if (to > 12) {
        to = to - 12;
        toStart = to.toString();
        totimeNew = toStart + toEnd + " PM";
      } else if (to == 12) {
        totimeNew = totime + " PM";
      } else {
        totimeNew = totime + " AM";
      }
    print("$fromtime $totime");
    print("$fromtimeNew $totimeNew");
      double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return  Padding(
        padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.01, horizontal: screenWidth * 0.02),
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.019, horizontal: screenWidth * 0.033),
          color: kSubMainColor,
          child: Column(children: [
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(child: Icon(Icons.fastfood, color: kMainColor)),
                SizedBox(width: screenWidth * 0.03),
                Expanded(
                    flex: 2,
                    child: Container(
                        child: Text(dishname ?? "Dummy",
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            textScaleFactor: screenWidth * 0.0027))),
                SizedBox(
                  width: screenWidth * 0.025,
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    child: Row(
                      children: [
                        Container(
                            color: Colors.black12,
                            height: screenHeight * 0.02,
                            width: 1),
                        SizedBox(width: screenWidth * 0.024),
                        Container(
                            child: Text(fromtimeNew + "-" + totimeNew ?? "Dummy",
                                textScaleFactor: screenWidth * 0.0027)),
                        SizedBox(width: screenWidth * 0.024),
                        Container(
                            color: Colors.black12,
                            height: screenHeight * 0.02,
                            width: 1),
                        SizedBox(width: screenWidth * 0.024),
                        Container(
                            child: Text(totquantity.toString() ?? "Dummy",
                                textScaleFactor: 1)),
                        SizedBox(width: screenWidth * 0.024),
                        Container(
                            color: Colors.black12,
                            height: screenHeight * 0.02,
                            width: 1),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                        child: Text('\u{20B9} $price' ?? "Dummy",
                            textScaleFactor: screenWidth * 0.0027))),
              ],
            )
          ]),
        ),
    );
  }
}
    
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     return Padding(
//       padding: EdgeInsets.symmetric(
//           vertical: screenHeight * 0.01, horizontal: screenWidth * 0.02),
//       child: Container(
//         padding: EdgeInsets.symmetric(
//             vertical: screenHeight * 0.019, horizontal: screenWidth * 0.043),
//         color: kSubMainColor,
//         child: Column(children: [
//           Row(
//             //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               //Container(child: Icon(Icons.fastfood, color: kMainColor)),
//               //SizedBox(width: screenWidth * 0.03),
//               Expanded(
//                   flex: 2,
//                   child: Container(
//                       child: Text(dishname ?? "Dummy",
//                           maxLines: 5,
//                           overflow: TextOverflow.ellipsis,
//                           textScaleFactor: screenWidth * 0.0025))),
//               // SizedBox(
//               //   width: screenWidth * 0.1,
//               // ),
//               Expanded(
//                 flex: 2,
//                 child: Container(
//                   child: Row(
//                     children: [
//                       Container(
//                           color: Colors.black12,
//                           height: screenHeight * 0.03,
//                           width: 1),
//                       SizedBox(width: screenWidth * 0.025),
//                       Container(
//                           child: Text(fromtimeNew + "-" + totimeNew ?? "Dummy",
//                               textScaleFactor: screenWidth * 0.0025)),
//                        Container(
//                                   child: Text("-",
//                                       textScaleFactor: screenWidth * 0.0024)),
//                               Container(
//                                   child: Text(totimeNew,
//                                       textScaleFactor: screenWidth * 0.0024)),
//                       //SizedBox(width: screenWidth * 0.0024),
//                       // Container(
//                       //     color: Colors.black12,
//                       //     height: screenHeight * 0.0024,
//                       //     width: 1),
//                       // //SizedBox(width: screenWidth * 0.024),
//                       // Container(
//                       //     child: Text(totquantity.toString() ?? "Dummy",
//                       //         textScaleFactor: screenWidth*0.0024)),
//                       // //SizedBox(width: screenWidth * 0.024),
//                       // Container(
//                       //     color: Colors.black12,
//                       //     height: screenHeight * 0.02,
//                       //     width: 1),
//                     ],
//                   ),
//                 ),
//               ),
//               Expanded(
//                child: Container(
//                     child: Row(
//                       children: [
//                         Container(
//                             color: Colors.black12,
//                             height: screenHeight * 0.03,
//                             width: 1.5),
//                         SizedBox(width: screenWidth * 0.05),
//                         Expanded(
//                           child: Container(
//                               child: Text(totquantity.toString(),
//                                   textScaleFactor: screenWidth * 0.0027)),
//                         ),
//                         //SizedBox(width: screenWidth * 0.025),
//                         Expanded(


//                   child: Container(
//                       child: Text('\u{20B9} $price' ?? "Dummy",
//                           textScaleFactor: screenWidth * 0.0027))
//                           ),
//             ],
//           )
//                ),
//               ),
//              ] ),
        
//         ]),
//               ),);
      
    
//   }
// }
