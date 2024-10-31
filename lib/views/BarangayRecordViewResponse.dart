import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sawadmin/main.dart';

class BarangayRecordResponseView extends StatefulWidget {
  const BarangayRecordResponseView(
      {super.key,
      required this.keys,
      required this.timereported,
      required this.barangay,
      required this.landmark,
      required this.datereported,
      required this.image});

  final String keys;
  final String timereported;
  final String barangay;
  final String landmark;
  final String datereported;
  final String image;
  @override
  State<BarangayRecordResponseView> createState() => _BarangayRecordResponseViewState();
}

class _BarangayRecordResponseViewState extends State<BarangayRecordResponseView> {
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
  final _databaseReference =
      FirebaseDatabase.instance.ref().child('barangay');
  final _formKey = GlobalKey<FormState>();
  final barangay = TextEditingController();
  final landmark = TextEditingController();
  final date = TextEditingController();
  final time = TextEditingController();
  final name = TextEditingController();
  final address = TextEditingController();
  final age = TextEditingController();
  final events = TextEditingController();
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
  bool absorb = true;
  bool _pair = false;
  bool _facemask = false;
  bool _clean = false;
  bool _cotton = false;
  bool _nasal = false;
  bool _O2 = false;
  bool _oxygen = false;
  bool _othersenumerate = false;
  // ignore: unused_field
  String? _imageUrl;
  String?img;
  // declare controller and variables area

  @override
  void initState() {
    _fetchResponseRecordView();
    _fetchImageUrl();
    super.initState();
  }

// fetch response record data area
  Future<void> _fetchResponseRecordView() async {
    try {
      DatabaseEvent event = await _databaseReference
          .orderByChild("key")
          .equalTo("${widget.keys}")
          .once();
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        setState(() {
          name.text = value['name'];
          address.text = value['address'];
          age.text = value['age'];
          _selectedSex = value['selectedSex'].toString();
          _selectedWeather = value['selectedWeather'].toString();
          _home = value['home'];
          img = value['image'];
          _school = value['school'];
          _others = value['others'];
          _event = value['eventBool'];
          events.text = value['event'];
          _home = value['home'];
          _hometransport = value['hometransport'];
          _hospitaltransport = value['hospitaltransport'];
          medicalname.text = value['medicalname'];
          _refyes = value['refyes'];
          _refno = value['refno'];
          doctorname.text = value['doctorname'];
          _suspected_dui = value['suspected_dui'];
          _straydog = value['straydog'];
          _selfaccident = value['selfaccident'];
          _collision = value['collision'];
          _othersroadcrash = value['othersroadcrash'];
          _yes = value['yes'];
          _no = value['no'];
          _driver = value['driver'];
          _passenger = value['passenger'];
          _padesterian = value['padesterian'];
          _motorcyle = value['motorcyle'];
          _tricyclecab = value['tricyclecab'];
          _privatetricyle = value['privatetricyle'];
          _4wheelsabove = value['4wheelsabove'];
          _otherscycle = value['otherscycle'];
          vitaltime.text = value['vitaltime'];
          bpvital.text = value['bpvital'];
          pulse.text = value['pulse'];
          respiration.text = value['respiration'];
          temp.text = value['temp'];
          o2Sat.text = value['o2Sat'];
          gcs.text = value['gcs'];
          _selectedeyes = value['selectedeyes'];
          _selectedinjury = value['selectedinjury'];
          responsetime.text = value['responsetime'];
          transported.text = value['transported'];
          _pair = value['pair'];
          _facemask = value['facemask'];
          _clean = value['clean'];
          _cotton = value['cotton'];
          _nasal = value['nasal'];
          _O2 = value['O2'];
          _oxygen = value['oxygen'];
          _othersenumerate = value['othersenumerate'];
        });
      });
      setState(() {});
    } catch (e) {
      print(e);
    } finally {}
  }
// end fetch response record data area

// fetch image area;
  void _fetchImageUrl() async {
    try {
      String imageUrl = await FirebaseStorage.instance
          .ref('uploads/${widget.image}')
          .getDownloadURL();
      setState(() {
        _imageUrl = imageUrl;
      });
    } catch (e) {
      print('Error fetching image URL: $e');
    }
  }
// end fetch image area;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF1877F2),
          title: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BarangayPage(barangay: widget.barangay,)),
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
                    "Barangay Record Response",
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
                                 /* _imageUrl*/ img != null
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
                                            child:Image.network(
                                              img!,
                                              width: 1800,
                                              height: 400,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
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
                                  /*     ElevatedButton.icon(
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
                                  ), */
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
                          SizedBox(height: 16),
                          TextFormField(
                            readOnly: true,
                            controller: landmark..text = '${widget.landmark}',
                            decoration: InputDecoration(
                              labelText: 'Landmark',
                              border: OutlineInputBorder(),
                            ),
                          ),
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
                              controller: events,
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
                          /* Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 12),
                              width:
                                  280.0, // Adjust the width as per your requirement
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
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
                                child: Text(
                                  'Update',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          */
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
