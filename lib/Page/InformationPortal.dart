import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:sawadmin/Page/HomePage.dart';
import 'package:sawadmin/views/InformationPageView.dart';

class InformationPortalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Information Portal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TablePage(),
    );
  }
}

class TablePage extends StatefulWidget {
  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  List<Map<dynamic, dynamic>> _dataList = [];
  // ignore: unused_field
  List<Map<dynamic, dynamic>> _filteredSource = [];
  ScrollController _scrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();
  final _databaseRef = FirebaseDatabase.instance.ref().child('reportincident');
  @override
  void initState() {
    super.initState();
    setState(() {
      _fetchReportIncident();
    });
    _filteredSource = _dataList;
  }

  Future<void> _fetchReportIncident() async {
    _databaseRef.onValue.listen((DatabaseEvent event) {
      try {
        DataSnapshot snapshot = event.snapshot;
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        _dataList.clear();
        data.forEach((key, value) {
          _dataList.add(value);
        });
        setState(() {
          _filteredSource = List.from(_dataList);
        });
      } catch (e) {
         print(e);
      }
    });
  }
//   Future<void> _fetchReportIncident() async {
//     setState(() {});
//     try {
//       DatabaseEvent event = await _databaseRef.once();
//       DataSnapshot snapshot = event.snapshot;
//       Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
//  // // Clear existing data before fetching new data
//     // _dataList.clear();

//       data.forEach((key, value) {
//         _dataList.add(value);
//       });
//       setState(() {
//         _filteredSource = List.from(_dataList);
//       });
//     } catch (e) {
//       print(e);
//     } finally {}
//   }

  void _showDeleteDialog(BuildContext context, String key, String id) {
    AwesomeDialog(
      context: context,
      width: 580.0,
      dialogType: DialogType.warning,
      headerAnimationLoop: false,
      title: 'Delete',
      desc: 'Are you sure you want to delete $id?',
      btnCancelOnPress: () {},
      btnOkOnPress: () => deleteData(key, id), // Directly call deleteData
    ).show();
  }

  Future<void> deleteData(String key, String id) async {
    try {
      await _databaseRef.child(key).remove();
      setState(() {
        _filteredSource.removeWhere((element) => element['reportid'] == id);
      });

      AnimatedSnackBar.rectangle(
        desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
        'SUCCESSFULLY',
        '$id DELETED SUCCESSFULLY',
        type: AnimatedSnackBarType.success,
        brightness: Brightness.light,
      ).show(context);
    } catch (error) {
      print('Failed to delete data: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete data')),
      );
    }
  }

  void filterData() {
    String query = _searchController.text.toLowerCase();
    List<Map<dynamic, dynamic>> filtered = _dataList.where((item) {
      String? fullname = item['reportername']?.toString().toLowerCase();
      return fullname != null && fullname.contains(query);
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
              Image.asset("images/assets/ip.gif", width: 30),
              Text('Information Portal Records'),
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
                leading: Image.asset("images/assets/ip.gif", width: 30),
                title: Text('Information Portal'),
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
                          (MediaQuery.of(context).size.width / 10) * 0.5,
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
                        // DataColumn(
                        //   label: Text(
                        //     'Landmark',
                        //     style: TextStyle(fontStyle: FontStyle.italic),
                        //   ),
                        // ),
                        DataColumn(
                          label: Text(
                            'Ambulance',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Firetruck',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Police',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Rescue Vehicle',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Patrol Vehicle',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Utility Vehicle',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Water Tanker',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Relief Vehicle',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Involve Incident',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Description Incident',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        // DataColumn(
                        //   label: Text(
                        //     'Vehicle Needed',
                        //     style: TextStyle(fontStyle: FontStyle.italic),
                        //   ),
                        // ),
                        /*
                        DataColumn(
                          label: Text(
                            'Latitude',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Longtitude',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        */
                        DataColumn(
                          label: Text(
                            'Date Reported',
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
                        setState(() {});
                        return DataRow(
                          cells: <DataCell>[
                            DataCell(Text(row['reportid'])),
                            DataCell(Text(row['userid'])),
                            DataCell(Text(row['reportername'])),
                            DataCell(Text(row['barangay'])),
                            DataCell(Text(row['purok'])),
                            DataCell(row['ambulance'] == ""
                                ? Text("NOT NEEDED",
                                    style: TextStyle(color: Colors.red))
                                : Text(
                                    "NEEDED",
                                    style: TextStyle(color: Colors.green),
                                  )),
                            DataCell(row['firetruck'] == ""
                                ? Text("NOT NEEDED",
                                    style: TextStyle(color: Colors.red))
                                : Text(
                                    "NEEDED",
                                    style: TextStyle(color: Colors.green),
                                  )),
                            DataCell(
                              row['police'] == ""
                                  ? Text("NOT NEEDED",
                                      style: TextStyle(color: Colors.red))
                                  : Text(
                                      "NEEDED",
                                      style: TextStyle(color: Colors.green),
                                    ),
                            ),
                            DataCell(
                              row['rescueVehicle'] == ""
                                  ? Text("NOT NEEDED",
                                      style: TextStyle(color: Colors.red))
                                  : Text(
                                      "NEEDED",
                                      style: TextStyle(color: Colors.green),
                                    ),
                            ),
                            DataCell(
                              row['patrolvehicle'] == ""
                                  ? Text("NOT NEEDED",
                                      style: TextStyle(color: Colors.red))
                                  : Text(
                                      "NEEDED",
                                      style: TextStyle(color: Colors.green),
                                    ),
                            ),
                            DataCell(
                              row['utilityvehicle'] == ""
                                  ? Text("NOT NEEDED",
                                      style: TextStyle(color: Colors.red))
                                  : Text(
                                      "NEEDED",
                                      style: TextStyle(color: Colors.green),
                                    ),
                            ),
                            DataCell(
                              row['watertanker'] == ""
                                  ? Text("NOT NEEDED",
                                      style: TextStyle(color: Colors.red))
                                  : Text(
                                      "NEEDED",
                                      style: TextStyle(color: Colors.green),
                                    ),
                            ),
                            DataCell(
                              row['reliefvehicle'] == ""
                                  ? Text("NOT NEEDED",
                                      style: TextStyle(color: Colors.red))
                                  : Text(
                                      "NEEDED",
                                      style: TextStyle(color: Colors.green),
                                    ),
                            ),
                            DataCell(
                                Text(row['involveincident'] + " incident")),
                            // DataCell(Text(row['landmark'])),
                            DataCell(Text(row['descriptionIncident'])),
                            // DataCell(Text(row['vehicle'])),
                            /*
                            DataCell(Text(lat!.toStringAsFixed(2))),
                            DataCell(Text(long!.toStringAsFixed(2))),
                            */
                            DataCell(Text(row['datereported'])),
                            DataCell(Row(
                              children: [
                                IconButton(
                                    icon: Icon(Icons.visibility),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  InformationPageView(
                                                    reportid: row['reportid'],
                                                    userid: row['userid'],
                                                    reportername:
                                                        row['reportername'],
                                                    datereported:
                                                        row['datereported'],
                                                    // landmark: row['landmark'],
                                                    purok: row['purok'],
                                                    involveIncident:
                                                        // row['involveIncident'],
                                                        row['involveincident'],
                                                    // vehicle: row['vehicle'],
                                                    barangay: row['barangay'],
                                                    timereported:
                                                        row['timereported'],
                                                    keys: row['key'],
                                                  )));
                                    }),
                                IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      //    print("");
                                      _showDeleteDialog(
                                          context, row['key'], row['reportid']);
                                    }),
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
