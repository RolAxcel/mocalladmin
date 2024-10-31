import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sawadmin/Page/DiscussionForum.dart';

class DiscussionFormView extends StatelessWidget {
  const DiscussionFormView({
    super.key,
    required this.id,
    required this.image,
    required this.comment,
    required this.title,
    required this.description,
  });
  final String id;
  final String image;
  final String title;
  final String description;
  final bool comment;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'About View with Comments',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DiscussionFormViewPage(
        id: id,
        image: image,
        comment: comment,
        title: title,
        description: description,
      ),
    );
  }
}

class DiscussionFormViewPage extends StatefulWidget {
  const DiscussionFormViewPage({
    super.key,
    required this.id,
    required this.image,
    required this.comment,
    required this.title,
    required this.description,
  });
  final String id;
  final String image;
  final bool comment;
  final String title;
  final String description;
  @override
  _DiscussionFormViewPageState createState() => _DiscussionFormViewPageState();
}

class _DiscussionFormViewPageState extends State<DiscussionFormViewPage> {
  // Sample data for the about view
  bool commentsEnabled = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final idnumber = TextEditingController();
  bool? comm;
  @override
  void initState() {
    setState(() {
      commentsEnabled = widget.comment;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF1877F2),
          title: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DiscussionForum()),
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
                        "Discussion Forum View",
                        style: TextStyle(color: Colors.white, fontSize: 15.0),
                      ),
                    ],
                  )),
              SizedBox(),
              Text(
                "Comment Status",
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
              Transform.scale(
                scale: 0.6,
                child: Switch(
                  value: commentsEnabled,
                  activeTrackColor: Color.fromARGB(255, 24, 242, 24),
                  inactiveTrackColor: Colors.grey,
                  onChanged: (value) {
                    setState(() {
                      commentsEnabled = value;
                      if (commentsEnabled == true) {
                        _refreshIndicatorKey.currentState!.show();
                        idnumber.text = widget.id;
                        comm = value;
                        AnimatedSnackBar.rectangle(
                          desktopSnackBarPosition:
                              DesktopSnackBarPosition.topRight,
                          'INFO',
                          'PLEASE WAIT.....',
                          type: AnimatedSnackBarType.info,
                          brightness: Brightness.light,
                        ).show(
                          context,
                        );
                      } else if (commentsEnabled == false) {
                        _refreshIndicatorKey.currentState!.show();
                        idnumber.text = widget.id;
                        comm = value;
                        AnimatedSnackBar.rectangle(
                          desktopSnackBarPosition:
                              DesktopSnackBarPosition.topRight,
                          'INFO',
                          'PLEASE WAIT.....',
                          type: AnimatedSnackBarType.info,
                          brightness: Brightness.light,
                        ).show(
                          context,
                        );
                      }
                      print(value);
                    });
                  },
                ),
              ),
            ],
          )),
      body: RefreshIndicator(
        semanticsLabel: 'PLEASE WAIT...',
        key: _refreshIndicatorKey,
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2));
          setState(() {
            final DatabaseReference _databaseReference = FirebaseDatabase
                .instance
                .ref()
                .child('discussion')
                .child(idnumber.text);
            _databaseReference.update({
              'comment': comm,
            }).then((value) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => DiscussionForum()),
                  (route) => false);
              if (comm == true) {
                AnimatedSnackBar.rectangle(
                  desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
                  'Success',
                  'Comments are Enabled',
                  type: AnimatedSnackBarType.success,
                  brightness: Brightness.light,
                ).show(
                  context,
                );
              } else if (comm == false) {
                AnimatedSnackBar.rectangle(
                  desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
                  'Error',
                  'Comments are Disabled',
                  type: AnimatedSnackBarType.error,
                  brightness: Brightness.light,
                ).show(
                  context,
                );
              }
            }).catchError((err) {
              // error
            });
          });
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.network(
                    '${widget.image}',
                    width: 1800,
                    height: 400,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                '${widget.title}',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Text(
                '${widget.description}',
                style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
              ),
              SizedBox(height: 20.0),
              Divider(height: 1.0, color: Colors.grey),
              SizedBox(height: 20.0),
              Text(
                'Comments',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              CommentSection(
                  id: widget.id, comment: widget.comment, image: widget.image),
            ],
          ),
        ),
      ),
    );
  }
}

class CommentSection extends StatefulWidget {
  const CommentSection({
    super.key,
    required this.id,
    required this.image,
    required this.comment,
  });
  final String id;
  final String image;
  final bool comment;
  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final _commentReference = FirebaseDatabase.instance.ref().child('comments');
  final GlobalKey<RefreshIndicatorState> _commentsIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool commenter = false;
  List<Map<dynamic, dynamic>> comments = [];
/*
  TextEditingController commentController = TextEditingController();

  void addComment(String comment) {
    setState(() {
      comments.add(comment);
      commentController.clear(); // Clear the text field after adding comment
    });
  }*/

  void initState() {
    _fetchComment();
    setState(() {
      commenter = widget.comment;
    });
    super.initState();
  }

  Future<void> _fetchComment() async {
    setState(() {});
    try {
      DatabaseEvent event = await _commentReference
          .orderByChild("id")
          .equalTo('${widget.id}')
          .once();
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        comments.add(value);
      });
      setState(() {});
    } catch (e) {
      print(e);
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _commentsIndicatorKey,
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 2));
        try {
          DatabaseEvent event = await _commentReference
              .orderByChild("id")
              .equalTo('${widget.id}')
              .once();
          DataSnapshot snapshot = event.snapshot;
          if (snapshot.value != null) {
            Map<dynamic, dynamic> data =
                snapshot.value as Map<dynamic, dynamic>;
            List<Map<dynamic, dynamic>> tempList = [];
            data.forEach((key, value) {
              tempList.add({'key': key, ...value});
            });
            setState(() {
              comments = tempList;
            });
          }
        } catch (e) {
          print(e);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              /*   Expanded(
                child: TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ), */
              SizedBox(width: 8.0),
              IconButton(
                icon: Image.asset(
                  "images/assets/reload.gif",
                  width: 25.0,
                ),
                onPressed: () {
                  setState(() {
                    _commentsIndicatorKey.currentState!.show();
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Divider(height: 1.0, color: Colors.grey),
          SizedBox(height: 16.0),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: comments.length,
            itemBuilder: (BuildContext context, int index) {
              return commenter != false
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text("${comments[index]['name']}"),
                        subtitle: Text("${comments[index]['comment']}"),
                        trailing: Text(
                            "${comments[index]['time']} ${comments[index]['date']}"),
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage("${comments[index]['imageUrl']}"),
                        ),
                      ),
                    )
                  : null;
            },
          ),
          commenter != false
              ? Text("")
              : Center(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      "THE COMMENTS ARE DISABLED",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
