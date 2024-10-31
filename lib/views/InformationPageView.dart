import 'dart:typed_data';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sawadmin/Page/InformationPortal.dart';

class InformationPageView extends StatefulWidget {
  const InformationPageView(
      {super.key,
      required this.reportid,
      required this.userid,
      required this.barangay,
      // required this.landmark,
      required this.purok,
      required this.involveIncident,
      // required this.vehicle,
      required this.datereported,
      required this.timereported,
      required this.reportername,
      required this.keys});

  final String reportid;
  final String keys;
  final String userid;
  final String timereported;
  final String reportername;
  final String barangay;
  // final String landmark;
  final String purok;
  final String involveIncident;
  // final String vehicle;
  final String datereported;

  @override
  State<InformationPageView> createState() => _InformationPageViewState();
}

class _InformationPageViewState extends State<InformationPageView> {
  // end declare controller and variable area
  bool absorbPointer = true;
  // TextEditingController _landmarkController =
  // TextEditingController(text: 'Dapit sa mobod covered court');
  // TextEditingController _involveIncidentController =
  // TextEditingController(text: 'Nagmahal, nasaktan, binanga nang bike.');
  // TextEditingController _purokController =
  // TextEditingController(text: 'Purok 2');
  // TextEditingController _barangayController =
  // TextEditingController(text: 'Mobod');
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
  final _databaseReference =
      FirebaseDatabase.instance.ref().child('reportincident');
  DatabaseReference _databaseRefer = FirebaseDatabase.instance.ref();
  final _formKey = GlobalKey<FormState>();
  final barangay = TextEditingController();
  // final landmark = TextEditingController();
  final date = TextEditingController();
  final time = TextEditingController();
  final name = TextEditingController();
  final address = TextEditingController();
  final age = TextEditingController();
  final event = TextEditingController();
  final medicalname = TextEditingController();
  final doctorname = TextEditingController();
  final vitaltime = TextEditingController();
  final bpvital = TextEditingController();
  final pulse = TextEditingController();
  final respiration = TextEditingController();
  final temp = TextEditingController();
  final o2Sat = TextEditingController();
  final gcs = TextEditingController();
  final responsetime = TextEditingController();
  final transported = TextEditingController();
  String _selectedIncident = 'Road Crash';
  String _selectedWeather = 'Clear';
  String _selectedSex = 'Male';
  String _selectedeyes = 'None';
  String _selectedverbal = 'None';
  String _selectedmotor = 'None';
  String _selectedinjury = 'None';
  bool _home = false;
  bool _school = false;
  bool _work = false;
  bool _others = false;
  bool _event = false;
  bool _suspected_dui = false;
  bool _straydog = false;
  bool _selfaccident = false;
  bool _collision = false;
  bool _othersroadcrash = false;
  bool _yes = false;
  bool _no = false;
  bool _driver = false;
  bool _passenger = false;
  bool _padesterian = false;
  bool _motorcyle = false;
  bool _tricyclecab = false;
  bool _privatetricyle = false;
  bool _4wheelsabove = false;
  bool _otherscycle = false;
  bool _refyes = false;
  bool _refno = false;
  bool _hometransport = false;
  bool _hospitaltransport = false;

  bool _pair = false;
  bool _facemask = false;
  bool _clean = false;
  bool _cotton = false;
  bool _nasal = false;
  bool _O2 = false;
  bool _oxygen = false;
  bool _othersenumerate = false;
  bool absorb = false;
  // declare controller and variables area
  bool loading = false;
  Uint8List? _imageUintList;
  PlatformFile? _imageBytes;
  // ignore: unused_field
  //String? _uploadedFileURL;
  String? imageUrl;

  void _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        dialogTitle: 'Choose picture',
        allowedExtensions: ['jpeg', 'jpg', 'png']);

    if (result != null) {
      setState(() {
        _imageBytes = result.files.first;
        _imageUintList = result.files.single.bytes;
        //  filename = result.files.first.name;
      });
    } else {
      print('No file selected or invalid file.');
    }
  }

// submit data in database and upload image in storage area
  Future<void> submitInformation() async {
    final String formattedDateTime =
        DateFormat('hh:mm:ss a').format(DateTime.now());
    String dateString = DateFormat('dd/MM/yyyy').format(DateTime.now());
    //  DatabaseReference newRef = databaseReference.child('reportincident').push();
    setState(() {
      absorb = true;
      loading = true;
    });
    try {
      // Upload to Firebase Storage
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('uploads/${_imageBytes!.name}');
      UploadTask uploadTask = ref.putData(_imageUintList!);

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      setState(() {
        imageUrl = downloadUrl;
      });
      // End Upload to Firebase Storage
      DatabaseReference dref =
          await databaseReference.child('ResponseRecord').push();
      String? key = dref.key;
      dref.set({
        'key': key,
        'timerespond': formattedDateTime,
        'daterespond': dateString,
        'reportid': widget.reportid,
        'userid': widget.userid,
        'reportername': widget.reportername,
        'image': imageUrl.toString(),
        'barangay': widget.barangay,
        // 'landmark': widget.landmark,
        'datereported': widget.datereported,
        'timereported': widget.timereported,
        // 'vehicle': widget.vehicle,
        'involveIncident': widget.involveIncident,
        'purok': widget.purok,
        'name': name.text,
        'address': address.text,
        'age': age.text,
        'event': event.text,
        'medicalname': medicalname.text,
        'doctorname': doctorname.text,
        'vitaltime': vitaltime.text,
        'bpvital': bpvital.text,
        'pulse': pulse.text,
        'respiration': respiration.text,
        'temp': temp.text,
        'o2Sat': o2Sat.text,
        'gcs': gcs.text,
        'responsetime': responsetime.text,
        'transported': transported.text,
        'selectedIncident': _selectedIncident,
        'selectedWeather': _selectedWeather,
        'selectedSex': _selectedSex,
        'selectedeyes': _selectedeyes,
        'selectedverbal': _selectedverbal,
        'selectedmotor': _selectedmotor,
        'selectedinjury': _selectedinjury,
        'home': _home,
        'school': _school,
        'work': _work,
        'others': _others,
        'eventBool': _event,
        'suspected_dui': _suspected_dui,
        'straydog': _straydog,
        'selfaccident': _selfaccident,
        'collision': _collision,
        'othersroadcrash': _othersroadcrash,
        'yes': _yes,
        'no': _no,
        'driver': _driver,
        'passenger': _passenger,
        'padesterian': _padesterian,
        'motorcyle': _motorcyle,
        'tricyclecab': _tricyclecab,
        'privatetricyle': _privatetricyle,
        '4wheelsabove': _4wheelsabove,
        'otherscycle': _otherscycle,
        'refyes': _refyes,
        'refno': _refno,
        'hometransport': _hometransport,
        'hospitaltransport': _hospitaltransport,
        'pair': _pair,
        'facemask': _facemask,
        'clean': _clean,
        'cotton': _cotton,
        'nasal': _nasal,
        'O2': _O2,
        'oxygen': _oxygen,
        'othersenumerate': _othersenumerate,
      });
      DatabaseReference barangayref =
          await _databaseRefer.child('barangay').push();
      String? barangaykey = barangayref.key;
      barangayref.set({
        'key': barangaykey,
        'timerespond': formattedDateTime,
        'daterespond': dateString,
        'reportid': widget.reportid,
        'userid': widget.userid,
        'reportername': widget.reportername,
        'image': imageUrl.toString(),
        'barangay': widget.barangay,
        // 'landmark': widget.landmark,
        'datereported': widget.datereported,
        'timereported': widget.timereported,
        // 'vehicle': widget.vehicle,
        'involveIncident': widget.involveIncident,
        'purok': widget.purok,
        'name': name.text,
        'address': address.text,
        'age': age.text,
        'event': event.text,
        'medicalname': medicalname.text,
        'doctorname': doctorname.text,
        'vitaltime': vitaltime.text,
        'bpvital': bpvital.text,
        'pulse': pulse.text,
        'respiration': respiration.text,
        'temp': temp.text,
        'o2Sat': o2Sat.text,
        'gcs': gcs.text,
        'responsetime': responsetime.text,
        'transported': transported.text,
        'selectedIncident': _selectedIncident,
        'selectedWeather': _selectedWeather,
        'selectedSex': _selectedSex,
        'selectedeyes': _selectedeyes,
        'selectedverbal': _selectedverbal,
        'selectedmotor': _selectedmotor,
        'selectedinjury': _selectedinjury,
        'home': _home,
        'school': _school,
        'work': _work,
        'others': _others,
        'eventBool': _event,
        'suspected_dui': _suspected_dui,
        'straydog': _straydog,
        'selfaccident': _selfaccident,
        'collision': _collision,
        'othersroadcrash': _othersroadcrash,
        'yes': _yes,
        'no': _no,
        'driver': _driver,
        'passenger': _passenger,
        'padesterian': _padesterian,
        'motorcyle': _motorcyle,
        'tricyclecab': _tricyclecab,
        'privatetricyle': _privatetricyle,
        '4wheelsabove': _4wheelsabove,
        'otherscycle': _otherscycle,
        'refyes': _refyes,
        'refno': _refno,
        'hometransport': _hometransport,
        'hospitaltransport': _hospitaltransport,
        'pair': _pair,
        'facemask': _facemask,
        'clean': _clean,
        'cotton': _cotton,
        'nasal': _nasal,
        'O2': _O2,
        'oxygen': _oxygen,
        'othersenumerate': _othersenumerate,
      });
      removeReportIncidentData(widget.keys);
      AnimatedSnackBar.rectangle(
        desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
        'SUCCESSFULLY',
        'SEND SUCCESSFULLY',
        type: AnimatedSnackBarType.success,
        brightness: Brightness.light,
      ).show(
        context,
      );
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        absorb = false;
        loading = false;
      });
    }
  }

/*
  Future<void> _uploadImage() async {
    try {
      // Create a reference to Firebase Storage

      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('uploads/${filename.toString()}');

      // Upload the file to Firebase Storage
      UploadTask uploadTask = storageReference.putData(_imageBytes!);

      TaskSnapshot snapshot = await uploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();

      setState(() {
        _uploadedFileURL = downloadURL;
      });
    } catch (e) {
      print('Error occurred while uploading: $e');
    }
  }
  */

  Future<void> removeReportIncidentData(String key) async {
    setState(() {});
    await _databaseReference.child(key).remove().then((_) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => InformationPortalPage()),
          (route) => false);
    }).catchError((error) {
      print('Failed to delete data: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete data')),
      );
    });
  }

// end submit data in database and upload image in storage area
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Information Portal Page',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF1877F2),
          title: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InformationPortalPage()),
                    (route) => false);
              },
              icon: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.arrowLeft,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 3.0,
                  ),
                  Text(
                    "Information Portal Page",
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ],
              )),
        ),
        body: ListView(
          children: [
            SizedBox(height: 16),
            Center(
              child: Container(
                width: 900,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _imageBytes != null
                                      ? Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Image.memory(
                                                _imageUintList!,
                                                width: 1800,
                                                height: 400,
                                                fit: BoxFit.cover,
                                              )),
                                        )
                                      : Column(
                                          children: [
                                            Icon(
                                              Icons.image_not_supported,
                                              size: 100,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              'No image selected',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                  SizedBox(height: 30),
                                  ElevatedButton.icon(
                                    onPressed: _pickImage,
                                    icon: Icon(Icons.upload_file),
                                    label: Text('Upload Image'),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.blue,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 15),
                                      textStyle: TextStyle(fontSize: 18),
                                      shadowColor:
                                          Colors.black.withOpacity(0.5),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Text(
                            'Incident Details',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Divider(),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: AbsorbPointer(
                                  absorbing: absorb,
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: 'Incident Type',
                                      border: OutlineInputBorder(),
                                    ),
                                    value: _selectedIncident,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedIncident = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'Road Crash',
                                      'Medical Emergency',
                                      'Medical Transport',
                                      'Others'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  readOnly: true,
                                  controller: barangay
                                    ..text = '${widget.barangay}',
                                  decoration: InputDecoration(
                                    labelText: 'Brgy',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // SizedBox(height: 16),
                          // TextFormField(
                          //   readOnly: true,
                            // controller: landmark..text = '${widget.landmark}',
                          //   decoration: InputDecoration(
                          //     labelText: 'Landmark',
                          //     border: OutlineInputBorder(),
                          //   ),
                          // ),
                          SizedBox(height: 16),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                  readOnly: true,
                                  controller: date
                                    ..text = '${widget.datereported}',
                                  decoration: InputDecoration(
                                    labelText: 'Date',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  readOnly: true,
                                  controller: time
                                    ..text = '${widget.timereported}',
                                  decoration: InputDecoration(
                                    labelText: 'Time',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Patient Details',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Divider(),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please fill out the filled';
                                }
                                return null;
                              },
                              controller: name,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please fill out the filled';
                                }
                                return null;
                              },
                              controller: address,
                              decoration: InputDecoration(
                                labelText: 'Address',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: AbsorbPointer(
                                  absorbing: absorb,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please fill out the filled';
                                      }
                                      return null;
                                    },
                                    controller: age,
                                    decoration: InputDecoration(
                                      labelText: 'Age',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: AbsorbPointer(
                                  absorbing: absorb,
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: 'Sex',
                                      border: OutlineInputBorder(),
                                    ),
                                    value: _selectedSex,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedSex = newValue!;
                                      });
                                    },
                                    items: <String>['Male', 'Female']
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Weather Condition',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Divider(),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Weather',
                                border: OutlineInputBorder(),
                              ),
                              value: _selectedWeather,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedWeather = newValue!;
                                });
                              },
                              items: <String>[
                                'Clear',
                                'Raining',
                                'Foggy',
                                'Snowy'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Medical Emergency',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Divider(),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('Home'),
                              value: _home,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _home = newValue!;
                                });
                              },
                            ),
                          ),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('School'),
                              value: _school,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _school = newValue!;
                                });
                              },
                            ),
                          ),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('Work'),
                              value: _work,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _work = newValue!;
                                });
                              },
                            ),
                          ),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('Others'),
                              value: _others,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _others = newValue!;
                                });
                              },
                            ),
                          ),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('Event'),
                              value: _event,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _event = newValue!;
                                });
                              },
                            ),
                          ),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please fill out the filled';
                                }
                                return null;
                              },
                              controller: event,
                              decoration: InputDecoration(
                                labelText: 'Event Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Medical Transport From',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Divider(),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('Home'),
                              value: _hometransport,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _hometransport = newValue!;
                                });
                              },
                            ),
                          ),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('Hospital'),
                              value: _hospitaltransport,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _hospitaltransport = newValue!;
                                });
                              },
                            ),
                          ),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please fill out the filled';
                                }
                                return null;
                              },
                              controller: medicalname,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Referral',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Divider(),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('Yes'),
                              value: _refyes,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _refyes = newValue!;
                                });
                              },
                            ),
                          ),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('No'),
                              value: _refno,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _refno = newValue!;
                                });
                              },
                            ),
                          ),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please fill out the filled';
                                }
                                return null;
                              },
                              controller: doctorname,
                              decoration: InputDecoration(
                                labelText: 'Doctor',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Factors of Road Crash',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Divider(),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('Suspected DUI'),
                              value: _suspected_dui,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _suspected_dui = newValue!;
                                });
                              },
                            ),
                          ),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('Stray Dog'),
                              value: _straydog,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _straydog = newValue!;
                                });
                              },
                            ),
                          ),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('Self Accident'),
                              value: _selfaccident,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _selfaccident = newValue!;
                                });
                              },
                            ),
                          ),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('Collision'),
                              value: _collision,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _collision = newValue!;
                                });
                              },
                            ),
                          ),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('Other'),
                              value: _othersroadcrash,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _othersroadcrash = newValue!;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Wearing Helment',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Divider(),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('Yes'),
                              value: _yes,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _yes = newValue!;
                                });
                              },
                            ),
                          ),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('No'),
                              value: _no,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _no = newValue!;
                                });
                              },
                            ),
                          ),
                          Divider(),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('Driver'),
                              value: _driver,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _driver = newValue!;
                                });
                              },
                            ),
                          ),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('Passenger'),
                              value: _passenger,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _passenger = newValue!;
                                });
                              },
                            ),
                          ),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('Padesterian'),
                              value: _padesterian,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _padesterian = newValue!;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Type of Vehicle',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Divider(),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('Motorcyle'),
                              value: _motorcyle,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _motorcyle = newValue!;
                                });
                              },
                            ),
                          ),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('Tricyle for Hire Cab No.'),
                              value: _tricyclecab,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _tricyclecab = newValue!;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 16),
                          Divider(),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('Private Tricycle'),
                              value: _privatetricyle,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _privatetricyle = newValue!;
                                });
                              },
                            ),
                          ),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('4 Wheels Above'),
                              value: _4wheelsabove,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _4wheelsabove = newValue!;
                                });
                              },
                            ),
                          ),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('Others'),
                              value: _otherscycle,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _otherscycle = newValue!;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Vital Signs',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Divider(),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please fill out the filled';
                                }
                                return null;
                              },
                              controller: vitaltime,
                              decoration: InputDecoration(
                                labelText: 'Time',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please fill out the filled';
                                }
                                return null;
                              },
                              controller: bpvital,
                              decoration: InputDecoration(
                                labelText: 'BP',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please fill out the filled';
                                }
                                return null;
                              },
                              controller: pulse,
                              decoration: InputDecoration(
                                labelText: 'Pulse',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please fill out the filled';
                                }
                                return null;
                              },
                              controller: respiration,
                              decoration: InputDecoration(
                                labelText: 'Respiration',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please fill out the filled';
                                }
                                return null;
                              },
                              controller: temp,
                              decoration: InputDecoration(
                                labelText: 'Temp',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please fill out the filled';
                                }
                                return null;
                              },
                              controller: o2Sat,
                              decoration: InputDecoration(
                                labelText: 'O2Sat',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please fill out the filled';
                                }
                                return null;
                              },
                              controller: gcs,
                              decoration: InputDecoration(
                                labelText: 'GCS',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: 'Eyes',
                                      border: OutlineInputBorder(),
                                    ),
                                    value: _selectedeyes,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedeyes = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'None',
                                      'Pain',
                                      'Verbal',
                                      'Spontaneous'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: 'Verbal',
                                      border: OutlineInputBorder(),
                                    ),
                                    value: _selectedverbal,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedverbal = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'None',
                                      'in comp',
                                      'in app',
                                      'confuse',
                                      'orient'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: 'Motor',
                                      border: OutlineInputBorder(),
                                    ),
                                    value: _selectedmotor,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedmotor = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'None',
                                      'Extension',
                                      'Flexion',
                                      'Withdrawn',
                                      'Localize',
                                      'Obeys'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: 'Severity of Injury',
                                      border: OutlineInputBorder(),
                                    ),
                                    value: _selectedinjury,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedinjury = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'None',
                                      'Slight',
                                      'moderate',
                                      'serious',
                                      'severe',
                                      'Critical'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please fill out the filled';
                                }
                                return null;
                              },
                              controller: responsetime,
                              decoration: InputDecoration(
                                labelText: 'Response Time',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please fill out the filled';
                                }
                                return null;
                              },
                              controller: transported,
                              decoration: InputDecoration(
                                labelText: 'Transported To',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Medical Supplies Used',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Divider(),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('Pairs of Clean Gloves'),
                              value: _pair,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _pair = newValue!;
                                });
                              },
                            ),
                          ),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('Facemask'),
                              value: _facemask,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _facemask = newValue!;
                                });
                              },
                            ),
                          ),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('Clean/Sterile Gauze'),
                              value: _clean,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _clean = newValue!;
                                });
                              },
                            ),
                          ),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('Cotton Balls'),
                              value: _cotton,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _cotton = newValue!;
                                });
                              },
                            ),
                          ),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('Nasal Cannula'),
                              value: _nasal,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _nasal = newValue!;
                                });
                              },
                            ),
                          ),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('O2 Mask(Adult/Child)'),
                              value: _O2,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _O2 = newValue!;
                                });
                              },
                            ),
                          ),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('Oxygen'),
                              value: _oxygen,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _oxygen = newValue!;
                                });
                              },
                            ),
                          ),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: CheckboxListTile(
                              title: Text('Others'),
                              value: _othersenumerate,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _othersenumerate = newValue!;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 16),
                          AbsorbPointer(
                            absorbing: absorb,
                            child: Center(
                              child: Container(
                                margin: const EdgeInsets.only(top: 12),
                                width:
                                    280.0, // Adjust the width as per your requirement
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        submitInformation();
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(
                                        0xFF1877F2), // Set the background color to black
                                    foregroundColor: Colors
                                        .white, // Set the text color to white
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          15), // Set the button shape to rectangular
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            16.0), // Adjust the vertical padding
                                  ),
                                  child: loading == true
                                      ? LoadingAnimationWidget
                                          .staggeredDotsWave(
                                              color: Colors.white, size: 28.0)
                                      : Text(
                                          'Submit',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
