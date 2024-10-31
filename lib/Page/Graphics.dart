import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sawadmin/Page/HomePage.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class Graph extends StatefulWidget {
  const Graph({super.key});

  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  String datestring = DateFormat("dd/MM/yyyy").format(DateTime.now());
  DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child("ResponseRecord");
  List<Map<dynamic, dynamic>> _mobodList = [];
  List<Map<dynamic, dynamic>> _canubayList = [];
  List<Map<dynamic, dynamic>> _lobocList = [];
  final List<ChartData> chartData = [];
  String? month;
  int? year;
  int mobod = 0;
  int canubay = 0;
  int lowerloboc = 0;
  List _data = [
    {
      "name": "joshua",
    },
  ];

  Future dat() async {
    final dat = await _data;
    return dat;
  }

  @override
  void initState() {
    // Create a DateTime object with a dummy day
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month);
    // Use DateFormat to format the month as a full month name
    month = DateFormat('MMMM').format(date);
    year = now.year;
    _getMobodCount();
    _getCanubayCount();
    _getLobocCount();
// Parse the date string into a DateTime object
    // DateTime dateTime = DateFormat('dd/MM/yyyy').parse("07/07/2024");
    // Format the DateTime object into a word date format
    // String formattedDate = DateFormat('MMMM d, yyyy').format(dateTime);

    super.initState();
  }

  Future<void> _getMobodCount() async {
    setState(() {});
    try {
      DatabaseEvent Mobod = await _databaseReference
          .orderByChild("barangay")
          .equalTo("Mobod")
          .once();
      DataSnapshot mobodsnapshot = Mobod.snapshot;
      Map<dynamic, dynamic> datamobod =
          mobodsnapshot.value as Map<dynamic, dynamic>;
      datamobod.forEach((key, value) {
        _mobodList.add(value);
      });
      setState(() {
        mobod = _mobodList.length;
        chartData.add(
          ChartData('Mobod', mobod),
        );
      });
    } catch (e) {
      print(e);
    } finally {}
  }

  Future<void> _getCanubayCount() async {
    setState(() {});
    try {
      DatabaseEvent Canubay = await _databaseReference
          .orderByChild("barangay")
          .equalTo("Canubay")
          .once();
      DataSnapshot canubaysnapshot = Canubay.snapshot;
      Map<dynamic, dynamic> datacanubay =
          canubaysnapshot.value as Map<dynamic, dynamic>;
      datacanubay.forEach((key, value) {
        _canubayList.add(value);
      });

      setState(() {
        canubay = _canubayList.length;
        chartData.add(
          ChartData('Canubay', canubay),
        );
      });
    } catch (e) {
      print(e);
    } finally {}
  }

  Future<void> _getLobocCount() async {
    setState(() {});
    try {
      DatabaseEvent Loboc = await _databaseReference
          .orderByChild("barangay")
          .equalTo("Lower Loboc")
          .once();
      DataSnapshot Lobocsnapshot = Loboc.snapshot;
      Map<dynamic, dynamic> dataloboc =
          Lobocsnapshot.value as Map<dynamic, dynamic>;
      dataloboc.forEach((key, value) {
        _lobocList.add(value);
      });

      setState(() {
        lowerloboc = _lobocList.length;
        chartData.add(
          ChartData('Lower Loboc', lowerloboc),
        );
      });
    } catch (e) {
      print(e);
    } finally {}
  }

/* 
  final List<ChartData> chartData = [
    ChartData('Mobod', 10),
    ChartData('Canubay', 30),
    ChartData('Lower Loboc', 40),
  ];
*/
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Graph',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF1877F2),
            title: IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
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
                      "Graph",
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                    ),
                  ],
                )),
          ),
          body: Center(
            child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: FutureBuilder(
                  future: dat(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      return ListView.builder(
                        itemCount: _data.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 50.0,
                              ),
                              // bar chart area
                              Center(
                                  child: Container(
                                      height: 500.0,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: SfCartesianChart(
                                          title: ChartTitle(
                                              text:
                                                  '${month} ${year} Responded'),
                                          legend: Legend(isVisible: true),
                                          tooltipBehavior: TooltipBehavior(
                                              enable: true,
                                              format: 'point.x : point.y'),
                                          primaryXAxis: CategoryAxis(),
                                          series: [
                                            StackedColumnSeries<ChartData,
                                                String>(
                                              color: Color(0xFF1877F2),
                                              // Bind data source
                                              dataSource: chartData,
                                              xValueMapper: (ChartData ch, _) =>
                                                  ch.barangay,
                                              yValueMapper: (ChartData ch, _) =>
                                                  ch.total,
                                              name: 'Responded',
                                              dataLabelSettings:
                                                  DataLabelSettings(
                                                      color: Color(0xFF1877F2),
                                                      isVisible: true),
                                            )
                                          ]))),
                              // end bar chart area
                              SizedBox(
                                height: 50.0,
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                )),
          )),
    );
  }
}

// data model for graph chart area
class ChartData {
  final String barangay;
  final int total;
  ChartData(this.barangay, this.total);
}
// end data model for graph chart area
