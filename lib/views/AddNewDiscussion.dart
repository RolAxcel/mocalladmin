import 'dart:math';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sawadmin/Page/DiscussionForum.dart';
import 'dart:html' as html;

class AddDiscussion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Addnew Discussion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AddDiscussionPage(),
    );
  }
}

class AddDiscussionPage extends StatefulWidget {
  @override
  _AddDiscussionPageState createState() => _AddDiscussionPageState();
}

class _AddDiscussionPageState extends State<AddDiscussionPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  PlatformFile? _selectedFile;
  Uint8List? _imageData;
  bool submitabsorbPointer = false;
  String _uploadedFileURL = "";
  bool readonly = false;
  bool loading = false;
  String dateString = DateFormat('dd/MM/yyyy').format(DateTime.now());

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png']);

    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
        _imageData = _selectedFile?.bytes;
      });
      // For web, convert the picked file to a Blob and create a URL for it
      // if you need to perform any further actions with the file
      if (kIsWeb) {
        final bytes = _selectedFile!.bytes;
        final blob = html.Blob([bytes!]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        print("PDF URL: $url");
      }
    } else {
      // User canceled the picker
    }
  }

  Future<void> _submit() async {
    Random random = Random();
    int rand = random.nextInt(9000) + 1000;
    setState(() {
      loading = true;
      readonly = true;
      submitabsorbPointer = true;
    });
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('uploads/${_selectedFile!.name}');
      UploadTask uploadTask = ref.putData(_selectedFile!.bytes!);

      await uploadTask.whenComplete(() async {
        _uploadedFileURL = await ref.getDownloadURL();
      });

      print("File uploaded successfully. Download URL: $_uploadedFileURL");
      DatabaseReference databaseReference = FirebaseDatabase.instance
          .ref()
          .child('discussion')
          .child(rand.toString());
      databaseReference.set({
        "id": rand.toString(),
        "date": dateString,
        'comment': true,
        "title": _titleController.text,
        "description": _descriptionController.text,
        "imageUrl": _uploadedFileURL,
      });
    } catch (e) {
      print("Failed to upload file: $e");
      setState(() {});
    } finally {
      setState(() {
        loading = false;
        _titleController.clear();
        _descriptionController.clear();
        readonly = false;
        submitabsorbPointer = false;
        _selectedFile = null;
        AnimatedSnackBar.rectangle(
          desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
          'Successfully',
          'Submit Successfully',
          type: AnimatedSnackBarType.success,
          brightness: Brightness.light,
        ).show(
          context,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        title: Row(
          children: [
            Image.asset("images/assets/add.gif", width: 30),
            Text('Add New Discussion'),
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
                    MaterialPageRoute(builder: (context) => DiscussionForum()));
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Container(
            width: 580,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 15,
                  offset: Offset(0, 10), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'New Discussion',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    readOnly: readonly,
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    readOnly: readonly,
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.attach_file),
                    label: Text(_selectedFile == null
                        ? 'Select File'
                        : 'File: ${_selectedFile!.name}'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  _selectedFile != null
                      ? Center(
                          child: Container(
                            width: 500,
                            height: 200,
                            /*  decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 15,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ), */
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.memory(
                                  _imageData!,
                                  width: 300,
                                  height: 150,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '${_selectedFile?.name}',
                                ),
                              ],
                            ),
                          ),
                        )
                      : Center(),
                  SizedBox(height: 20.0),
                  AbsorbPointer(
                    absorbing: submitabsorbPointer,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_titleController.text.isEmpty) {
                          AnimatedSnackBar.rectangle(
                            desktopSnackBarPosition:
                                DesktopSnackBarPosition.topRight,
                            'Error',
                            'Please fill all fields and select a file',
                            type: AnimatedSnackBarType.error,
                            brightness: Brightness.light,
                          ).show(
                            context,
                          );
                        } else if (_descriptionController.text.isEmpty) {
                          AnimatedSnackBar.rectangle(
                            desktopSnackBarPosition:
                                DesktopSnackBarPosition.topRight,
                            'Error',
                            'Please fill all fields and select a file',
                            type: AnimatedSnackBarType.error,
                            brightness: Brightness.light,
                          ).show(
                            context,
                          );
                        } else if (_selectedFile == null) {
                          AnimatedSnackBar.rectangle(
                            desktopSnackBarPosition:
                                DesktopSnackBarPosition.topRight,
                            'Error',
                            'Please select a file',
                            type: AnimatedSnackBarType.error,
                            brightness: Brightness.light,
                          ).show(
                            context,
                          );
                        } else {
                          _submit();
                        }
                      },
                      child: loading == true
                          ? LoadingAnimationWidget.staggeredDotsWave(
                              color: Colors.white, size: 28.0)
                          : Text(
                              'Submit',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                              ),
                            ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        textStyle: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
