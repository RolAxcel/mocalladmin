import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:sawadmin/Page/HomePage.dart';
import 'package:sawadmin/views/ResponseRecordView.dart';

class ResponseRecord extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Response Record',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ResponseRecordPage(),
    );
  }
}

class ResponseRecordPage extends StatefulWidget {
  @override
  _ResponseRecordPageState createState() => _ResponseRecordPageState();
}

class _ResponseRecordPageState extends State<ResponseRecordPage> {
  final _databaseReference =
      FirebaseDatabase.instance.ref().child('ResponseRecord');
  List<Map<dynamic, dynamic>> _dataList = [];
  late List<Map<dynamic, dynamic>> _filteredSource;
  ScrollController _scrollController = ScrollController();

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchReportIncident();
    _filteredSource = _dataList;
  }

  // Future<void> _fetchReportIncident() async {
  //   setState(() {});
  //   try {
  //     DatabaseEvent event = await _databaseReference.once();
  //     DataSnapshot snapshot = event.snapshot;
  //     Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
  //     data.forEach((key, value) {
  //       _dataList.add(value);
  //     });
  //     setState(() {
  //       _filteredSource = List.from(_dataList);
  //     });
  //   } catch (e) {
  //     print(e);
  //   } finally {}
  // }

Future<void> _fetchReportIncident() async {
  setState(() {});
  try {
    DatabaseEvent event = await _databaseReference.once();
    DataSnapshot snapshot = event.snapshot;
    Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

    // // Clear existing data before fetching new data
    _dataList.clear();

    data.forEach((key, value) {
      _dataList.add(value);
    });

    // Manually sort the list by 'selectedIncident' field
    List<dynamic> sortedDataList = _dataList.where((item) {
      return item['selectedIncident'] != null;
    }).toList();

    sortedDataList.sort((a, b) {
      return a['selectedIncident'].toString().compareTo(b['selectedIncident'].toString());
    });

    setState(() {
      _filteredSource = List.from(sortedDataList);
    });
  } catch (e) {
    print(e);
  } finally {}
}




  void _showDeleteDialog(BuildContext context, String key, String id) {
    AwesomeDialog(
      context: context,
      width: 580.0,
      dialogType: DialogType.warning,
      headerAnimationLoop: false,
      title: 'Delete',
      desc: 'Are you sure you want to delete $id?',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        deleteData(key, id);
      },
    ).show();
  }

  Future<void> deleteData(String key, String id) async {
    setState(() {});
    await _databaseReference.child(key).remove().then((_) {
      setState(() {
        _filteredSource.removeWhere((element) => element['reportid'] == id);
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
      String fullname = item['reportername'].toString().toLowerCase();
      return fullname.contains(query);
    }).toList();

    setState(() {
      _filteredSource = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          title: Row(
            children: [
              Image.asset("images/assets/record.gif", width: 30),
              Text('Response Record'),
            ],
          ),
          /* bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                _filterRows(value);
              },
            ),
          ),
        ),*/
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
                leading: Image.asset("images/assets/record.gif", width: 30),
                title: Text('Response Record'),
              ),
            ],
          ),
        ),
        body: ListView(
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
                          (MediaQuery.of(context).size.width / 5) * 0.5,
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
                            'Reporter ID',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Reporter Name',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Barangay',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Purok',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                         DataColumn(
                          label: Text(
                            'Type of incident',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        // DataColumn(
                        //   label: Text(
                        //     'Landmark',
                        //     style: TextStyle(fontStyle: FontStyle.italic),
                        //   ),
                        // ),
                        // DataColumn(
                        //   label: Text(
                        //     'Incident Report',
                        //     style: TextStyle(fontStyle: FontStyle.italic),
                        //   ),
                        // ),
                          DataColumn(
                          label: Text(
                            'Involve Incident',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        // DataColumn(
                        //   label: Text(
                        //     'Vehicle Needed',
                        //     style: TextStyle(fontStyle: FontStyle.italic),
                        //   ),
                        // ),
                        DataColumn(
                          label: Text(
                            'Date of Responded',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Time of Responded',
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
                            DataCell(Text(row['reportid'])),
                            DataCell(Text(row['userid'])),
                            DataCell(Text(row['reportername'])),
                            DataCell(Text(row['barangay'])),
                            DataCell(Text(row['purok'])),
                            // DataCell(Text(row['landmark'])),
                               DataCell(Text(row['selectedIncident'])),
                            DataCell(Text(row['involveIncident'] + " incident")),
                            // DataCell(Text(row['vehicle'])),
                            DataCell(Text(row['daterespond'])),
                            DataCell(Text(row['timerespond'])),
                            DataCell(Row(
                              children: [
                                IconButton(
                                    icon: Icon(Icons.visibility),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ResponseRecordView(
                                                    datereported: row['datereported'],
                                                    // landmark: row['landmark'],
                                                    barangay: row['barangay'],
                                                    timereported:row['timereported'],
                                                    keys: row['key'],
                                                    image: row['image'],
                                                  )));
                                    }),
                                IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _showDeleteDialog(
                                        context, row['key'], row['reportid'])),
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
        ));
  }
}
