import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:sawadmin/Page/HomePage.dart';
import 'package:sawadmin/views/AddNewDiscussion.dart';
import 'package:sawadmin/views/DiscussionFormView.dart';

class DiscussionForum extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Discussion Forum',
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
  // bool commentsEnabled = false;
  List<Map<dynamic, dynamic>> _dataList = [];
  // ignore: unused_field
  List<Map<dynamic, dynamic>> _filteredSource = [];
  ScrollController _scrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();
  final _databaseReference =
      FirebaseDatabase.instance.ref().child('discussion');

  @override
  void initState() {
    super.initState();
    _fetchReportIncident();
    _filteredSource = _dataList;
    _searchController.addListener(() {
      filterData();
    });
  }

  Future<void> _fetchReportIncident() async {
    setState(() {});
    try {
      DatabaseEvent event = await _databaseReference.once();
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

      data.forEach((key, value) {
        _dataList.add(value);
        setState(() {
          //  commentsEnabled = value['comment'];
        });
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
        deleteData(id);
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
      String fullname = item['title'].toString().toLowerCase();
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
              Image.asset("images/assets/df.gif", width: 30),
              Text('Discussion Forum'),
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
                leading: Image.asset("images/assets/add.gif", width: 30),
                title: Text('Add New Discussion'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddDiscussion()));
                },
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
                            'Title',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Description',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Date',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Status Comment',
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
                            DataCell(Text(row['title'])),
                            DataCell(Text(row['description'])),
                            DataCell(Text(row['date'])),
                            DataCell(Text(
                              row['comment'] != false ? "Enabled" : "Disabled",
                              style: TextStyle(
                                  color: row['comment'] != false
                                      ? Colors.green
                                      : Colors.red),
                            )),
                            DataCell(Row(
                              children: [
                                IconButton(
                                    icon: Icon(Icons.visibility),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DiscussionFormView(id: row['id'], image: row['imageUrl'], comment: row['comment'], title: row['title'], description: row['description'],)));
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
        ));
  }
}
