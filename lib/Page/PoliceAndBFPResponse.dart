import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sawadmin/Page/HomePage.dart';

class PoliceAndBFP extends StatefulWidget {
  const PoliceAndBFP({super.key});

  @override
  State<PoliceAndBFP> createState() => _PoliceAndBFPState();
}

class _PoliceAndBFPState extends State<PoliceAndBFP> {
  List<Map<dynamic, dynamic>> _dataList = [];
  final _databaseReference = FirebaseDatabase.instance.ref().child('message');
  late List<Map<dynamic, dynamic>> _filteredSource;
  ScrollController _scrollController = ScrollController();
  final controllerText = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool accept = true;
  bool waiting = true;

  @override
  void initState() {
    super.initState();
    _fetchmessage();
    _filteredSource = _dataList;
  }

  Future<void> _fetchmessage() async {
    setState(() {});
    try {
      DatabaseEvent event = await _databaseReference.once();
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        _dataList.add(value);
      });
      setState(() {
        _filteredSource = List.from(_dataList);
        
      });
    } catch (e) {
      print(e);
    } finally {}
  }

  void _showDeleteDialog(BuildContext context, String id) {
    AwesomeDialog(
      context: context,
      width: 580.0,
      dialogType: DialogType.warning,
      headerAnimationLoop: false,
      title: 'Delete',
      desc: 'Are you sure you want to delete $id?',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        setState(() {
          deleteData(id);
        });
      },
    ).show();
  }

  Future<void> deleteData(String id) async {
    setState(() {});
    await _databaseReference.child(id).remove().then((_) {
      setState(() {
        _filteredSource.removeWhere((element) => element['id'] == id);
      });
      AnimatedSnackBar.rectangle(
        desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
        'SUCCESSFULLY',
        '$id DELETE SUCCESSFULLY',
        type: AnimatedSnackBarType.success,
        brightness: Brightness.light,
      ).show(
        context,
      );
    }).catchError((error) {
      print('Failed to delete data: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete data')),
      );
    });
  }

  void filterData() {
    String query = _searchController.text.toLowerCase();
    List<Map<dynamic, dynamic>> filtered = _dataList.where((item) {
      String id = item['id'].toString().toLowerCase();
      return id.contains(query);
    }).toList();

    setState(() {
      _filteredSource = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PNP AND BFP RESPONSE',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          title: Row(
            children: [
              Image.asset(
                "images/assets/envelope.gif",
                width: 25.0,
              ),
              SizedBox(width: 5.0),
              Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Text(
                    'Police And BFP Response',
                    style: GoogleFonts.poppins(),
                  )),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/assets/dashboardupdate.png")),
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
                child: Text(
                  '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Image.asset(
                  "images/assets/home.gif",
                  width: 30,
                ),
                title: Text('Home'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
              ),
              ListTile(
                leading: Image.asset("images/assets/envelope.gif", width: 30),
                title: Text('PNP and BFP Response'),
              ),
            ],
          ),
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          color: Colors.grey,
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 2));
            //  _fetchmessage();
            try {
              DatabaseEvent event = await _databaseReference.once();
              DataSnapshot snapshot = event.snapshot;
              if (snapshot.value != null) {
                Map<dynamic, dynamic> data =
                    snapshot.value as Map<dynamic, dynamic>;
                List<Map<dynamic, dynamic>> tempList = [];
                data.forEach((key, value) {
                  tempList.add({'key': key, ...value});
                });
                setState(() {
                  _dataList = tempList;
                  _filteredSource = List.from(_dataList);
                });
              }
            } catch (e) {
              print(e);
            }
          },
          child: ListView(
            children: [
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 23.0),
                    width: 800.0,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                          hintText: 'Search...',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          prefixIcon: Container(
                            width: 5.0,
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Image.asset(
                              "images/assets/searchIcon.gif",
                              repeat: ImageRepeat.noRepeat,
                            ),
                          )),
                      onChanged: (value) {
                        setState(() {
                          filterData();
                        });
                      },
                    ),
                  ),
                ],
              ),
              Scrollbar(
                trackVisibility: false,
                thumbVisibility: false,
                controller: _scrollController,
                thickness: 5,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    width: 1.0,
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      child: DataTable(
                        columnSpacing:
                            (MediaQuery.of(context).size.width / 3.2) * 0.5,
                        dataRowHeight: 80,
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text(
                              'ID',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Department',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Date Accept',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Time Accept',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Status',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Action',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                        rows: _filteredSource.map((row) {
                          return DataRow(
                            cells: <DataCell>[
                              DataCell(Text(row['id'].toString())),
                              DataCell(Text(row['usertype'])),
                              DataCell(row['isaccept'] != true
                                  ? LoadingAnimationWidget.prograssiveDots(
                                      color: Colors.red, size: 30)
                                  : Text(row['date'])),
                              DataCell(row['isaccept'] != true
                                  ? LoadingAnimationWidget.prograssiveDots(
                                      color: Colors.red, size: 30)
                                  : Text(row['time'])),
                              DataCell(Container(
                                width: 70,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: row['isaccept'] != false
                                      ? Colors.green
                                      : Colors.red,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Center(
                                  child: Text(
                                    row['status'],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                      icon: Icon(
                                        FontAwesomeIcons.solidEnvelope,
                                        color: Colors.green,
                                      ),
                                      onPressed: () {
                                        // AwesomeDialog form area
                                        AwesomeDialog(
                                          context: context,
                                          width: 500,
                                          animType: AnimType.bottomSlide,
                                          dialogType: DialogType.info,
                                          body: Center(
                                            child: SingleChildScrollView(
                                              child: Form(
                                                child: Column(
                                                  children: [
                                                    Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16.0),
                                                        child: Container(
                                                          height: 200,
                                                          width: 900,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10), // apply rounded corners to the image as well
                                                            child: Image.asset(
                                                              'images/assets/reportincidentupdate.png', // Your image path
                                                              height: 200,
                                                              width: 900,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'Date and Time: ${row['datesubmit']} ${row['timesubmit']}',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Container(
                                                      width: 365,
                                                      child: TextFormField(
                                                        controller: controllerText
                                                          ..text =
                                                              "${row['message']}",
                                                        readOnly: true,
                                                        maxLines: 15,
                                                        validator: (pnp) {
                                                          if (pnp!.isEmpty) {
                                                            return 'Please enter your message';
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'Enter your message...',
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ).show();
                                        // End AwesomeDialog form area
                                      }),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () =>
                                        _showDeleteDialog(context, row['id']),
                                  ),
                                ],
                              )),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          mini: true,
          heroTag: 'refresh',
          onPressed: () {
            setState(() {
              _refreshIndicatorKey.currentState?.show();
            });
          },
          child: Image.asset(
            "images/assets/reload.gif",
            width: 25.0,
          ),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          tooltip: 'reload page',
        ),
      ),
    );
  }
}
