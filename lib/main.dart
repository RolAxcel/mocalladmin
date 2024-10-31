import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sawadmin/Include/BFP.dart';
import 'package:sawadmin/Include/PNP.dart';
import 'package:sawadmin/Page/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sawadmin/views/BarangayRecordViewResponse.dart';
import 'package:sawadmin/views/BarangayUpload.dart';
import 'package:sawadmin/views/BarangayUploadView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCDsJaRYIx71ea6mS7eecn1EF-Bmt9OZgk",
          authDomain: "mocall-1040d.firebaseapp.com",
          databaseURL: "https://mocall-1040d-default-rtdb.firebaseio.com",
          projectId: "mocall-1040d",
          storageBucket: "mocall-1040d.appspot.com",
          messagingSenderId: "786838796103",
          appId: "1:786838796103:web:e652f47dbddf802fe17e62",
          measurementId: "G-N0H8WMVDYE"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sign In Form',
      home: SignInPage(),
    );
  }
}

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _idnumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final adminloginkey = GlobalKey<FormState>();
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('Admin');
  bool loading = false;
  bool submitabsorbPointer = false;
  bool absorbPointer = false;
  bool obscure = true;
  Future<void> _signIn() async {
    setState(() {
      loading = true;
      submitabsorbPointer = false;
      absorbPointer = true;
    });
    try {
      DatabaseEvent event = await _databaseReference
          .orderByChild('username')
          .equalTo('${_idnumberController.text}')
          .once();

      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
       Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          if (value['password'] == _passwordController.text) {
            // Login successful
            var usertype = value['usertype'];
            switch (usertype) {
              case 'cdrmmo':
                Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => HomePage()),
                (route) => false);
                break;
              case 'PNP':
                Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => PNP()),
                (route) => false);
                break;
                 case 'BFP':
                Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => BFP()),
                (route) => false);
                break;
              case 'Barangay':
                Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => BarangayPage(barangay: value['barangay'])),
                (route) => false);
                break; 
              default:
            }
            
          } else {
            AwesomeDialog(
              width: 500,
              context: context,
              animType: AnimType.scale,
              title: 'Error',
              alignment: Alignment.center,
              dialogType: DialogType.error,
              body: Center(
                  child: Text(
                "WRONG PASSWORD PROVIDED",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              )),
              autoHide: const Duration(seconds: 5),
              btnCancelOnPress: () {},
            ).show();
          }
        });
      } else {
        AwesomeDialog(
          width: 500,
          context: context,
          animType: AnimType.scale,
          title: 'Error',
          alignment: Alignment.center,
          dialogType: DialogType.error,
          body: Center(
              child: Text(
            "NO USER FOUND",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          )),
          autoHide: const Duration(seconds: 5),
          btnCancelOnPress: () {},
        ).show();
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        loading = false;
        submitabsorbPointer = false;
        absorbPointer = false;
        _idnumberController.clear();
        _passwordController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: adminloginkey,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            padding: const EdgeInsets.only(top: 20, right: 56),
                            child: Image.asset(
                              'images/assets/loginupdate.png', // Replace with your image path
                              height: 300.0,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'LOGIN!',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Container(
                            width: 380,
                            child: TextFormField(
                              controller: _idnumberController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your ID#';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.numbers),
                                labelText: 'ID NUMBER',
                                hintText: 'Enter your ID#',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Container(
                            width: 380,
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: obscure,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey)),
                                suffixIcon: IconButton(
                                  icon: Icon(obscure ? Icons.visibility_off:Icons.remove_red_eye),
                                  onPressed: () {
                                    setState(() {
                                        obscure = !obscure;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Container(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () {
                                if (adminloginkey.currentState!.validate()) {
                                  _signIn();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                    0xFF1877F2), // Set the background color to black
                                foregroundColor:
                                    Colors.white, // Set the text color to white
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      15), // Set the button shape to rectangular
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        16.0), // Adjust the vertical padding
                              ),
                              child: loading == true
                                  ? LoadingAnimationWidget.staggeredDotsWave(
                                      color: Colors.white, size: 28.0)
                                  : Text(
                                      'Sign In',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFF1877F2),
                      /*   gradient: LinearGradient(
                                  colors: [
                                    
                                    Color.fromRGBO(0, 0, 200, 1),
                                    Color.fromRGBO(20, 24, 160, 1),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),*/
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            child: Image.asset(
                              'images/assets/welcome.png', // Replace with your image path
                              height: 300.0,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Welcome Back Admin!',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            'Welcome to our community! We\'re thrilled to have you join us on this journey.',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class BarangayPage extends StatefulWidget {
  const BarangayPage({super.key, required this.barangay});
  final String barangay;
  @override
  State<BarangayPage> createState() => _BarangayPageState();
}

class _BarangayPageState extends State<BarangayPage> {
  final _databaseReference =
      FirebaseDatabase.instance.ref().child('barangay');
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

  Future<void> _fetchReportIncident() async {
    setState(() {});
    try {
      DatabaseEvent event = await _databaseReference.orderByChild("barangay")
      .equalTo(widget.barangay).once();
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
            ),
            ListTile(
              leading: Image.asset("images/assets/uploader.gif", width: 30),
              title: Text('Upload'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BarangayUploadPage(barangay: widget.barangay,)));
              },
            ),
            ListTile(
              leading:
                  Image.asset("images/assets/historyrecord.gif", width: 30),
              title: Text('Upload History'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BarangayUploadPageView(barangay: widget.barangay,)));
              },
            ),
            Divider(),
            ListTile(
              leading: Image.asset("images/assets/logout.gif", width: 30),
              title: Text('Logout'),
              onTap: () {
                 Navigator.pushAndRemoveUntil(
                    context,
                    (MaterialPageRoute(builder: (context) => SignInPage())),
                    (route) => false);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        title: Row(
          children: [
            Image.asset("images/assets/home.gif", width: 30),
            SizedBox(width: 5.0),
            Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: Text(
                  'Barangay ${widget.barangay}',
                  style: GoogleFonts.poppins(),
                )),
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
                          'Landmark',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Incident Report',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Vehicle Needed',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Recommendation',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Articles',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Guidelines',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Date of Respond',
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
                          DataCell(Text(row['landmark'])),
                          DataCell(Text(row['involveIncident'])),
                          DataCell(Text(row['vehicle'])),
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
                                                  BarangayRecordResponseView(
                                                    datereported: row['datereported'],
                                                    landmark: row['landmark'],
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
      ),
    ),
    );
  }
}
