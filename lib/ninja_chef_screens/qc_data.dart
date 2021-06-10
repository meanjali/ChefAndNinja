import 'package:flutter/material.dart';
import 'package:food_delivery_app/services/firebase_db.dart';
import 'package:food_delivery_app/widgets/alert.dart';
import 'package:food_delivery_app/widgets/loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:food_delivery_app/ninja_chef_screens/checklist.dart';
import 'package:food_delivery_app/widgets/ninja_chef_drawer.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chef {
  String name;
  bool status;
  Chef(this.name, this.status);
}

class QCDataNinja extends StatefulWidget {
  final String screenName = 'QC Data';
  @override
  _QCDataNinjaState createState() => _QCDataNinjaState();
}

class _QCDataNinjaState extends State<QCDataNinja> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(Duration(days: 15)),
      lastDate: DateTime.now().add(Duration(days: 15)),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFFFF785B),
              onPrimary: Colors.white,
            ),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Stream qcdata;
  bool loading = true;

  fetchData() {
    qcdata = FirebaseMethods()
        .getQCData(DateFormat('dd MMM y').format(selectedDate).toString());
    setState(() => loading = false);
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: Colors.white,
              title: Text(
                widget.screenName,
                style: GoogleFonts.lexendDeca(
                    color: Color(0xff002140), fontWeight: FontWeight.w800),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.logout, color: Colors.black, size: 25),
                  onPressed: () async {
                    AlertMessage().logOutAlert(
                        context, "Are you sure you want to Logout");
                  },
                )
              ],
            ),
            drawer: NinjaChefDrawer(widget.screenName),
            body: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          DateFormat('dd MMM y')
                              .format(selectedDate)
                              .toString(),
                          style: GoogleFonts.lexendDeca(
                              fontSize: 20,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500),
                        ),
                        Theme(
                          data: ThemeData.dark(),
                          child: Builder(
                            builder: (context) => TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Color(0xFFFF785B),
                                ),
                              ),
                              child: Text(
                                'Select Date',
                                style: GoogleFonts.lexendDeca(
                                    color: Colors.white, fontSize: 16),
                              ),
                              onPressed: () async {
                                await _selectDate(context);
                                setState(() => loading = true);
                                await fetchData();
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    flex: 1,
                  ),
                  Container(
                    height: 2,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      child: StreamBuilder(
                        stream: qcdata,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFFFF785B),
                                ),
                              ),
                            );
                          } else {
                            if (snapshot.hasData &&
                                snapshot.data.docs.length > 0) {
                              return ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot ds =
                                      snapshot.data.docs[index];
                                  return Container(
                                    margin: EdgeInsets.all(5),
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 5),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            '${ds.data()['name']}',
                                            style: GoogleFonts.lexendDeca(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: TextButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                Color(0xFFFF785B),
                                              ),
                                            ),
                                            child: Text(
                                              'QC Data',
                                              style: GoogleFonts.lexendDeca(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Checklist(
                                                          ds.data()['values'],
                                                          ds.id),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              ds.data()['status'],
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.lexendDeca(),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/no_sub.png',
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "No submissions",
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
                      ),
                    ),
                    flex: 7,
                  )
                ],
              ),
            ),
          );
  }
}
