import 'dart:math';
import 'package:app_dialog/app_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sawadmin/Page/DiscussionForum.dart';
import 'package:sawadmin/Page/Graphics.dart';
import 'package:sawadmin/Page/GuidelinesKit.dart';
import 'package:sawadmin/Page/InformationPortal.dart';
import 'package:sawadmin/Page/PoliceAndBFPResponse.dart';
import 'package:sawadmin/Page/ResponseRecord..dart';
import 'package:sawadmin/main.dart';
import 'package:intl/intl.dart';
import 'package:sawadmin/views/UploadPdfHistory.dart';
import 'dart:js' as js;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MapController mapController = MapController();
  String mapTypeString = "";
  bool absorbPointer = true;
  bool ragbool = false;
  bool process = false;
  double? lat;
  double? long;
  final _formKey = GlobalKey<FormState>();
  final _pnpKey = GlobalKey<FormState>();
  final _bfpKey = GlobalKey<FormState>();
  final userName = TextEditingController();
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('reportincident');
  List<Marker> _markers = [];
  bool _isLoading = true;
  // TextEditingController _dateController = TextEditingController();
//  TextEditingController _timeController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _incidentReportController = TextEditingController();
  TextEditingController _barangayController = TextEditingController();
  TextEditingController _purokController = TextEditingController();
  TextEditingController _pnpController = TextEditingController();
  TextEditingController _bfpController = TextEditingController();
  TextEditingController _idnumberController = TextEditingController();
  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          title: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Row(
              children: [
                Image.asset(
                  "images/assets/settingsLOGO.gif",
                  width: 25.0,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "MAP SETTINGS",
                      style: GoogleFonts.poppins(),
                    ))
              ],
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'images/assets/mapupdate.png', // Your image path
                  height: 200,
                  width: 300,
                  fit: BoxFit.cover,
                ),
                ListBody(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      leading: Image.asset("images/assets/hybrid.jpeg"),
                      title: Text('Hybrid'),
                      onTap: () {
                        //setState(() {
                        mapTypeString = "Hybrid";

                        _getMapTypeFromString(mapTypeString);
                        //  maptype = MapType.hybrid;
                        Navigator.pop(context); // Close the dialog
                        //  });
                        setState(() {});
                        // Handle option 1 selection
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      leading: Image.asset("images/assets/normal.jpg"),
                      title: Text('Normal'),
                      onTap: () {
                        //   setState(() {
                        mapTypeString = "Normal";

                        _getMapTypeFromString(mapTypeString);
                        // maptype = MapType.normal;
                        setState(() {});
                        Navigator.pop(context); // Close the dialog
                        // });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      leading: Image.asset("images/assets/none.jpg"),
                      title: Text('None'),
                      onTap: () {
                        // setState(() {
                        mapTypeString = "None";

                        _getMapTypeFromString(mapTypeString);
                        //  maptype = MapType.none;
                        setState(() {});
                        Navigator.pop(context); // Close the dialog
                        // });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      leading: Image.asset("images/assets/satellite.jpg"),
                      title: Text('Satellite'),
                      onTap: () {
                        //setState(() {
                        mapTypeString = "Satellite";

                        _getMapTypeFromString(mapTypeString);
                        // maptype = MapType.satellite;
                        setState(() {});
                        Navigator.pop(context); // Close the dialog
                        // });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      leading: Image.asset("images/assets/terrain.jpg"),
                      title: Text('Terrain'),
                      onTap: () {
                        //  setState(() {
                        mapTypeString = "Terrain";
                        _getMapTypeFromString(mapTypeString);
                        setState(() {});
                        // maptype = MapType.terrain;
                        Navigator.pop(context); // Close the dialog
                        // });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _animateToResident() {
    mapController.move(
      LatLng(lat!, long!), // New York City coordinates
      10.0, // Zoom level
    );
  }

  void _animateToPoliceStation() {
    mapController.move(
      LatLng(
          8.478119305334966, 123.79705421291149), // New York City coordinates
      19.0, // Zoom level
    );
  }

  void _animateToBFPStation() {
    mapController.move(
      LatLng(8.477098823919938, 123.7971452501007), // New York City coordinates
      19.0, // Zoom level
    );
  }

// switch maptype area
  String _getMapTypeFromString(String mapTypeString) {
    if (mapTypeString == "Hybrid") {
      return 'https://{s}.google.com/vt/lyrs=s,h&x={x}&y={y}&z={z}';
    } else if (mapTypeString == "Normal") {
      return 'https://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}';
    } else if (mapTypeString == "Satellite") {
      return 'https://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}';
    } else if (mapTypeString == "Terrain") {
      return 'https://{s}.google.com/vt/lyrs=p&x={x}&y={y}&z={z}';
    } else {
      return 'https://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}';
    }
  }

// end switch maptype area
  @override
  void initState() {
    super.initState();
   setState(() {
     _fetchMarkers();
   });
    _markers.add(
      Marker(
          width: 80.0,
          height: 80.0,
          point:
              LatLng(8.478119305334966, 123.79705421291149), // Marker position
          child: IconButton(
              onPressed: () {
                setState(() {
                  PNP();
                });
              },
              icon: Image.asset("images/assets/policesmarker.png", width: 40))),
    );
    _markers.add(Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(8.477098823919938, 123.7971452501007), // Marker position
        child: IconButton(
            onPressed: () {
              setState(() {
                BFP();
              });
            },
            icon: Image.asset("images/assets/firemarker.png", width: 40))));
  }

Future<void> _fetchMarkers() async {
  _databaseReference.onValue.listen((DatabaseEvent event) {
    try {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        // Play audio automatically when new data is detected
        js.context.callMethod('playAudio');
        
        // Extract the data from the snapshot
        Map<dynamic, dynamic> markersMap = snapshot.value as Map<dynamic, dynamic>;
        
        markersMap.forEach((key, value) {
          // Extract latitude and longitude
          lat = value['latitude'];
          long = value['longtitude'];
          
          // Create a marker at the specified location
          final marker = Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(value['latitude'], value['longtitude']), // Marker position
            child: IconButton(
              onPressed: () {
                setState(() {
                  _addRecommendation(
                    value['imageUrl'],
                    value['barangay'],
                    value['purok'],
                    value['involveincident'],
                    value['descriptionIncident'],
                  );
                });
              },
              icon: Image.asset("images/assets/IPLOCATION.gif", width: 45),
            ),
          );
          
          // Add the marker to the list
          setState(() {
            _markers.add(marker); 
          });

          // Show an alert when new data is detected
          AnimatedSnackBar.rectangle(
            desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
            'EMERGENCY',
            '${value['barangay']} Purok ${value['purok']} PLEASE RESPOND IMMEDIATELY!',
            type: AnimatedSnackBarType.warning,
            brightness: Brightness.light,
          ).show(
            context,
          );
        });
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  });
}


  // Future<void> _fetchMarkers() async {
  //   try {
  //     DatabaseEvent event = await _databaseReference.once();
  //     DataSnapshot snapshot = event.snapshot;
  //     if (snapshot.value != null) {
  //       js.context.callMethod('playAudio');
  //       Map<dynamic, dynamic> markersMap =
  //           snapshot.value as Map<dynamic, dynamic>;
  //       markersMap.forEach((key, value) {
  //         lat = value['latitude'];
  //         long = value['longtitude'];
  //         final marker = Marker(
  //             width: 80.0,
  //             height: 80.0,
  //             point: LatLng(
  //                 value['latitude'], value['longtitude']), // Marker position
  //             child: IconButton(
  //                 onPressed: () {
  //                   setState(() {
  //                     _addRecommendation(
  //                       value['imageUrl'],
  //                       value['barangay'],
  //                       value['purok'],
  //                       value['involveincident'],
  //                       value['descriptionIncident'],
  //                     );
  //                   });
  //                 },
  //                 icon:
  //                     Image.asset("images/assets/IPLOCATION.gif", width: 45)));

  //         setState(() {
  //           _markers.add(marker);
  //         });

  //         AnimatedSnackBar.rectangle(
  //           desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
  //           'EMERGENCY',
  //           '${value['barangay']} Purok ${value['purok']} PLEASE RESPOND IMMEDIATELY!',
  //           type: AnimatedSnackBarType.warning,
  //           brightness: Brightness.light,
  //         ).show(
  //           context,
  //         );
  //       });
  //     }
  //   } catch (e) {
  //     print(e);
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }


 // void _listenForNewMarkers() {
  //   _databaseReference.onChildAdded.listen((event) {
  //     DataSnapshot snapshot = event.snapshot;
  //     print('New marker added: ${snapshot.value}');
  //     if (snapshot.value != null) {
  //        html.AudioElement audioElement = html.AudioElement('images/assets/alert.wav');
  //       audioElement.play();
  //       // _playNotificationSound();
  //     }
  //   });
  // }


// add recommendation area
  void _addRecommendation(String imageUrl, String barangay, String purok,
     String involveincident, String description) {
    _purokController.text = purok;
    _barangayController.text = barangay;
    // _vehicleNeededController.text = vehicle;
    _incidentReportController.text = involveincident;
    // _dateController.text = '10/5/2024';
    // _timeController.text = '13:23';
    _descriptionController.text = description;
    AppDialog(
      context: context,
      width: 500,
      animType: AnimType.SCALE,
      dialogType: DialogType.INFO,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Image.asset(
                //   'images/assets/mapupdate.png', // Your image path
                //   height: 200,
                //   width: 300,
                //   fit: BoxFit.cover,
                // ),
                Image.network(
                  imageUrl,
                  width: 400,
                  height: 300,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      // Image loaded
                      return child;
                    } else {
                      // Show the loading animation
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: LoadingAnimationWidget.inkDrop(
                          color: Colors
                              .blue, // Customize the color of the animation
                          size: 50,
                        ),
                      );
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    // Handle error if image can't be loaded
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 50,
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                AbsorbPointer(
                  absorbing: absorbPointer,
                  child: Container(
                    width: 365,
                    child: TextFormField(
                      controller: _barangayController,
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.city),
                        labelText: 'Barangay',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: process == true
                            ? Center(
                                child: LoadingAnimationWidget.staggeredDotsWave(
                                    color: Color.fromRGBO(9, 13, 136, 1),
                                    size: 28.0),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                AbsorbPointer(
                  absorbing: absorbPointer,
                  child: Container(
                    width: 365,
                    child: TextFormField(
                      controller: _purokController,
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.city),
                        labelText: 'Purok',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: process == true
                            ? Center(
                                child: LoadingAnimationWidget.staggeredDotsWave(
                                    color: Color.fromRGBO(9, 13, 136, 1),
                                    size: 28.0),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                AbsorbPointer(
                  absorbing: absorbPointer,
                  child: Container(
                    width: 365,
                    child: TextFormField(
                      controller: _incidentReportController,
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.numbers),
                        labelText: 'Involve Incident',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: process == true
                            ? Center(
                                child: LoadingAnimationWidget.staggeredDotsWave(
                                    color: Color.fromRGBO(9, 13, 136, 1),
                                    size: 28.0),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: 16),
                // AbsorbPointer(
                //   absorbing: absorbPointer,
                //   child: Container(
                //     width: 365,
                //     child: TextFormField(
                //       controller: _vehicleNeededController,
                //       readOnly: true,
                //       decoration: InputDecoration(
                //         prefixIcon: Icon(FontAwesomeIcons.car),
                //         labelText: 'Vehicle Needed',
                //         border: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(10),
                //         ),
                //         suffixIcon: process == true
                //             ? Center(
                //                 child: LoadingAnimationWidget.staggeredDotsWave(
                //                     color: Color.fromRGBO(9, 13, 136, 1),
                //                     size: 28.0),
                //               )
                //             : null,
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(height: 16),
                AbsorbPointer(
                  absorbing: absorbPointer,
                  child: Container(
                    width: 365,
                    child: TextFormField(
                      controller: _descriptionController,
                      readOnly: true,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Incident Description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: process == true
                            ? Center(
                                child: LoadingAnimationWidget.staggeredDotsWave(
                                    color: Color.fromRGBO(9, 13, 136, 1),
                                    size: 28.0),
                              )
                            : null,
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
    )..show();
  }

// end add recommendation area

// BFP AND PNP modal area

  void PNP() {
    AppDialog(
      context: context,
      width: 500,
      animType: AnimType.SCALE,
      dialogType: DialogType.INFO,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _pnpKey,
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 200,
                      width: 900,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(
                            10), // if you want rounded corners
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            10), // apply rounded corners to the image as well
                        child: Image.asset(
                          'images/assets/police.jpg', // Your image path
                          height: 200,
                          width: 900,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 365,
                  child: TextFormField(
                    controller: _pnpController,
                    readOnly: false,
                    maxLines: 15,
                    validator: (pnp) {
                      if (pnp!.isEmpty) {
                        return 'Please enter your message';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 280.0, // Adjust the width as per your requirement
                  child: ElevatedButton(
                    onPressed: () {
                      if (_pnpKey.currentState!.validate()) {
                        setState(() {
                          Random random = Random();
                          int rand = random.nextInt(9000) + 1000;
                          _idnumberController.text = rand.toString();
                          String timeString =
                              DateFormat('HH:mm:ss a').format(DateTime.now());
                          String dateString =
                              DateFormat('dd/MM/yyyy').format(DateTime.now());
                          print(dateString.toString());
                          DatabaseReference databaseReference = FirebaseDatabase
                              .instance
                              .ref()
                              .child('pnpmessage')
                              .child(_idnumberController.text);
                          databaseReference.set({
                            'datesubmit': dateString,
                            'timesubmit': timeString,
                            'time': timeString,
                            'date': dateString,
                            'id': _idnumberController.text,
                            'message': _pnpController.text,
                            'status': "pending",
                            'isaccept': false,
                            'usertype': "PNP",
                          });
                          DatabaseReference databasemessage = FirebaseDatabase
                              .instance
                              .ref()
                              .child('message')
                              .child(_idnumberController.text);
                          databasemessage.set({
                            'datesubmit': dateString,
                            'timesubmit': timeString,
                            'time': timeString,
                            'date': dateString,
                            'id': _idnumberController.text,
                            'message': _pnpController.text,
                            'status': "pending",
                            'isaccept': false,
                            'usertype': "PNP",
                          });
                          _pnpController.clear();
                          AnimatedSnackBar.rectangle(
                            desktopSnackBarPosition:
                                DesktopSnackBarPosition.topRight,
                            'SUCCESSFULLY',
                            'SEND SUCCESSFULLY',
                            type: AnimatedSnackBarType.success,
                            brightness: Brightness.light,
                          ).show(
                            context,
                          );
                        });
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
                          vertical: 16.0), // Adjust the vertical padding
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )..show();
  }

  void BFP() {
    AppDialog(
      context: context,
      width: 500,
      animType: AnimType.SCALE,
      dialogType: DialogType.INFO,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _bfpKey,
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 200,
                      width: 900,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(
                            10), // if you want rounded corners
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            10), // apply rounded corners to the image as well
                        child: Image.asset(
                          'images/assets/bfp.jpg', // Your image path
                          height: 200,
                          width: 900,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 365,
                  child: TextFormField(
                    controller: _bfpController,
                    readOnly: false,
                    maxLines: 15,
                    validator: (bfp) {
                      if (bfp!.isEmpty) {
                        return 'Please enter your message';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 280.0, // Adjust the width as per your requirement
                  child: ElevatedButton(
                    onPressed: () {
                      if (_bfpKey.currentState!.validate()) {
                        setState(() {
                          Random random = Random();
                          int rand = random.nextInt(9000) + 1000;
                          _idnumberController.text = rand.toString();
                          String timeString =
                              DateFormat('HH:mm:ss a').format(DateTime.now());
                          String dateString =
                              DateFormat('dd/MM/yyyy').format(DateTime.now());
                          print(dateString.toString());
                          DatabaseReference databaseReference = FirebaseDatabase
                              .instance
                              .ref()
                              .child('bfpmessage')
                              .child(_idnumberController.text);
                          databaseReference.set({
                            'datesubmit': dateString,
                            'timesubmit': timeString,
                            'time': timeString,
                            'date': dateString,
                            'id': _idnumberController.text,
                            'message': _bfpController.text,
                            'status': "pending",
                            'isaccept': false,
                            'usertype': "BFP",
                          });
                          DatabaseReference databasemessage = FirebaseDatabase
                              .instance
                              .ref()
                              .child('message')
                              .child(_idnumberController.text);
                          databasemessage.set({
                            'datesubmit': dateString,
                            'timesubmit': timeString,
                            'time': timeString,
                            'date': dateString,
                            'id': _idnumberController.text,
                            'message': _bfpController.text,
                            'status': "pending",
                            'isaccept': false,
                            'usertype': "BFP",
                          });
                          _bfpController.clear();
                          AnimatedSnackBar.rectangle(
                            desktopSnackBarPosition:
                                DesktopSnackBarPosition.topRight,
                            'SUCCESSFULLY',
                            'SEND SUCCESSFULLY',
                            type: AnimatedSnackBarType.success,
                            brightness: Brightness.light,
                          ).show(
                            context,
                          );
                        });
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
                          vertical: 16.0), // Adjust the vertical padding
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )..show();
  }

// End BFP AND PNP modal area

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add your logout logic here
                print('Logged out');
                Navigator.pushAndRemoveUntil(
                    context,
                    (MaterialPageRoute(builder: (context) => SignInPage())),
                    (route) => false);
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HomePage',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          // foregroundColor: Colors.white,
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          title: Row(
            children: [
              Image.asset(
                "images/assets/globeLocation.gif",
                width: 25.0,
              ),
              SizedBox(width: 5.0),
              Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Text(
                    'MAP DASHBOARD',
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
                  // Navigate to home page or perform any action
                },
              ),
              ListTile(
                leading: Image.asset("images/assets/df.gif", width: 30),
                title: Text('Discussion Forum'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DiscussionForum()));
                },
              ),
              ListTile(
                leading: Image.asset("images/assets/charts.gif", width: 30),
                title: Text('Graphics'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Graph()));
                },
              ),
              ListTile(
                leading: Image.asset("images/assets/gk.gif", width: 30),
                title: Text('Guidelines Kit'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => GuidelinesKit()));
                },
              ),
              ListTile(
                leading: Image.asset("images/assets/ip.gif", width: 30),
                title: Text('Information Portal'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InformationPortalPage()));
                },
              ),
              ListTile(
                leading: Image.asset("images/assets/envelope.gif", width: 30),
                title: Text('PNP and BFP Response'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PoliceAndBFP()));
                },
              ),
              ListTile(
                leading: Image.asset("images/assets/record.gif", width: 30),
                title: Text('Response Record'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResponseRecord()));
                },
              ),
              ListTile(
                leading:
                    Image.asset("images/assets/historyrecord.gif", width: 30),
                title: Text('Upload PDF History'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UploadHistoryView()));
                },
              ),
              Divider(),
              ListTile(
                leading: Image.asset("images/assets/logout.gif", width: 30),
                title: Text('Logout'),
                onTap: () {
                  _showLogoutDialog(context);
                },
              ),
            ],
          ),
        ),
        body: _isLoading
            ? Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Color.fromARGB(255, 0, 255, 229), size: 40.0))
            : Container(
                child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                    // ignore: deprecated_member_use
                    center: LatLng(8.486709969085682, 123.80483814754488),
                    zoom: 13.0),
                children: [
                  TileLayer(
                    urlTemplate: _getMapTypeFromString(mapTypeString),
                    maxZoom: 20,
                    subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
                    userAgentPackageName: 'com.example.app',
                    tileProvider: CancellableNetworkTileProvider(),
                  ),
                  MarkerLayer(
                    markers: _markers,
                  ),
                ],
              )),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              mini: true,
              heroTag: 'changeMap',
              onPressed: () {
                setState(() {
                  _showSettingsDialog(context);
                });
              },
              child: Image.asset(
                "images/assets/map.gif",
                width: 25.0,
              ),
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              tooltip: 'Change Map Type',
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              mini: true,
              heroTag: 'animateResident',
              onPressed: () {
                setState(() {
                  _animateToResident();
                });
              },
              child: Image.asset(
                "images/assets/pinLocation.gif",
                width: 25.0,
              ),
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              tooltip: 'Navigate to Resident Location',
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              mini: true,
              heroTag: 'animateToPoliceStation',
              onPressed: () {
                setState(() {
                  _animateToPoliceStation();
                });
              },
              child: Image.asset(
                "images/assets/policestation.png",
                width: 25.0,
              ),
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              tooltip: 'Navigate to Police Station Location',
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              mini: true,
              heroTag: 'animatetoBFP',
              onPressed: () {
                setState(() {
                  _animateToBFPStation();
                });
              },
              child: Image.asset(
                "images/assets/firefighter.png",
                width: 25.0,
              ),
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              tooltip: 'Navigate to BFP Location',
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              mini: true,
              heroTag: 'refresh',
              onPressed: () {
                setState(() {
                  _fetchMarkers();
                });
              },
              child: Image.asset(
                "images/assets/reload.gif",
                width: 25.0,
              ),
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              tooltip: 'refresh map',
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
