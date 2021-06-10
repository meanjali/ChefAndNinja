import 'package:flutter/material.dart';

const kMainColor = Color(0xFFFF785B);
const kSubMainColor = Color(0xFFDEE8FF);
const headingColor=Color(0xFF002140);

class OrderDetails extends StatefulWidget {
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  var orders = [
    {
      "customername": "Sakshi Shelar",
      "address": "A 202,Balaji Tower,Sector 22,Nerul West",
      "quantity": 5,
      "price": 70
    },
    {
      "customername": "Sakshi Shelar",
      "address": "A 202,Balaji Tower,Sector 22,Nerul West",
      "quantity": 5,
      "price": 70
    },
    {
      "customername": "Sakshi Shelar",
      "address": "A 202,Balaji Tower,Sector 22,Nerul West",
      "quantity": 5,
      "price": 70
    },
    {
      "customername": "Sakshi Shelar",
      "address": "A 202,Balaji Tower,Sector 22,Nerul West",
      "quantity": 5,
      "price": 70
    },
    {
      "customername": "Sakshi Shelar",
      "address": "A 202,Balaji Tower,Sector 22,Nerul West",
      "quantity": 5,
      "price": 70
    },
    {
      "customername": "Sakshi Shelar",
      "address": "A 202,Balaji Tower,Sector 22,Nerul West",
      "quantity": 5,
      "price": 70
    },
    {
      "customername": "Sakshi Shelar",
      "address": "A 202,Balaji Tower,Sector 22,Nerul West",
      "quantity": 5,
      "price": 70
    },
    {
      "customername": "Sakshi Shelar",
      "address": "A 202,Balaji Tower,Sector 22,Nerul West",
      "quantity": 5,
      "price": 70
    },
    {
      "customername": "Sakshi Shelar",
      "address": "A 202,Balaji Tower,Sector 22,Nerul West",
      "quantity": 5,
      "price": 70
    },
    {
      "customername": "Sakshi Shelar",
      "address": "A 202,Balaji Tower,Sector 22,Nerul West",
      "quantity": 5,
      "price": 70
    },
    {
      "customername": "Sakshi Shelar",
      "address": "A 202,Balaji Tower,Sector 22,Nerul West",
      "quantity": 5,
      "price": 70
    },
    {
      "customername": "Sakshi Shelar",
      "address": "A 202,Balaji Tower,Sector 22,Nerul West",
      "quantity": 5,
      "price": 70
    },
    {
      "customername": "Sakshi Shelar",
      "address": "A 202,Balaji Tower,Sector 22,Nerul West",
      "quantity": 5,
      "price": 70
    },
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Poha',
          style: TextStyle(
            fontSize: screenHeight * 0.028,
          ),
        ),
        backgroundColor: kMainColor,
      ),
        body: Container(
          child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: orders.length,
            itemBuilder: (BuildContext context, int index) {
              return OrderDetailsTile(
                customername: orders[index]['customername'],
                address: orders[index]['address'],
                quantity: orders[index]['quantity'],
                price: orders[index]['price'],
              );
            },
          ),
        ),
    );
  }
}

class OrderDetailsTile extends StatelessWidget {
  final String customername, address;
  final int quantity, price;
  OrderDetailsTile({
    @required this.customername,
    @required this.address,
    @required this.quantity,
    @required this.price,
  });
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
        // onTap: () {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => ArticleView(articleUrl: url)),
        //   );
        // },
        child: Padding(
       padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.01, horizontal: screenWidth * 0.02),
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.019, horizontal: screenWidth * 0.043),
        color: kSubMainColor,
        child: Column(children: [
          Row(
            children: [
              Container(
                child: Icon(Icons.supervised_user_circle,
                size: screenWidth * 0.085,
                color: kMainColor),
              ),
              SizedBox(width: screenWidth * 0.036),
              Expanded(
                flex: 3,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: Text(
                        customername,
                        textScaleFactor: screenWidth * 0.0029,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                      Container(
                          child: Text(address,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textScaleFactor: screenWidth * 0.0027)),
                    ],
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.06),
              Expanded(
              child: Container(
                child: Row(
                  children: [
                    Container(color: Colors.black12,height: 40,width: 1.5),
                    SizedBox(width:15.0), 
                    Container(child: Text(quantity.toString(), textScaleFactor: 1.3)),
                    SizedBox(width:15.0),
                    Container(color: Colors.black12,height: 40,width: 1.5),  
                  ],
                ),
              ),
            ), 
            SizedBox(width: 10.0,),
            Container(child: Text('\u{20B9} $price', textScaleFactor: 1.3)),            
            ],
          )
        ]),
      ),
    ));
  }
}
