import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sawadmin/main.dart';
import 'package:url_launcher/url_launcher.dart';

class BarangayUploadPageView extends StatefulWidget {
  const BarangayUploadPageView({super.key, required this.barangay});
  final String barangay;
  @override
  State<BarangayUploadPageView> createState() =>
      _BarangayUploadPageVieweState();
}

class _BarangayUploadPageVieweState extends State<BarangayUploadPageView> {
  List<Map<dynamic, dynamic>> _dataList = [];
  final _databaseReference =
      FirebaseDatabase.instance.ref().child('barangayPDF');
  late List<Map<dynamic, dynamic>> _filteredSource;
  ScrollController _scrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _fetchPdf();
    _filteredSource = _dataList;
  }

  Future<void> _fetchPdf() async {
    setState(() {});
    try {
      DatabaseEvent event = await _databaseReference
          .orderByChild("barangay")
          .equalTo("${widget.barangay}")
          .once();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        title: Row(
          children: [
            Image.asset("images/assets/historyrecord.gif", width: 30),
            Text('History Upload PDF'),
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
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BarangayPage(
                              barangay: widget.barangay,
                            )),
                    (route) => false);
              },
            ),
            ListTile(
              leading:
                  Image.asset("images/assets/historyrecord.gif", width: 30),
              title: Text('History Upload PDF'),
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
                      filterData();
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
                          (MediaQuery.of(context).size.width / 2.3) * 0.5,
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
                            'Barangay',
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
                            'Actions',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                      rows: _filteredSource.map((document) {
                        return DataRow(
                          cells: <DataCell>[
                            DataCell(Text(document['id']!)),
                            DataCell(Text(document['barangay']!)),
                            DataCell(Text(document['title']!)),
                            DataCell(Text(document['description']!)),
                            DataCell(
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.picture_as_pdf,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      final url = document['pdfUrl'];
                                      if (url != null && await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        // handle error
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      _showDeleteDialog(
                                          context, document['id']);
                                    },
                                  ),
                                ],
                              ),
                            ),
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
    );
  }
}
