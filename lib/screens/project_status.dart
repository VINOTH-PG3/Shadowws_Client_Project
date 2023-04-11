import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProjectStatus extends StatefulWidget {
  @override
  State<ProjectStatus> createState() => _ProjectStatusState();
}

class _ProjectStatusState extends State<ProjectStatus> {
  List<dynamic> _projects = [];
  double _progressValue = 0.0;


  @override
  void initState() {
    super.initState();


    Project();
  }


  Future<Map<String, dynamic>> _getTaskDetails(String projectId) async {
    final response = await http.get(Uri.parse(
        'https://agrarian-tooth.000webhostapp.com/cli_task.php?project_id=$projectId'));
        //'http://192.168.0.76/d_shadowws_client_5/cli_task.php?project_id=$projectId'));
    final jsonData = json.decode(response.body);
    print(jsonData);
    return jsonData;
  }

  Future<void> Project() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final response = await http.get(
      Uri.parse(
         'https://agrarian-tooth.000webhostapp.com/cli_project_status.php?user_id=$userId'),
          //'http://192.168.0.76/d_shadowws_client_5/cli_project_status.php?user_id=$userId'),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);
    final data = jsonDecode(response.body);
    if (data != null && data['projects'] != null) {
      setState(() {
        _projects = data['projects'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Project Status'),
      ),
      body: ListView.builder(
        itemCount: _projects.length,
        itemBuilder: (context, index) {
          final project = _projects[index];
          return SingleChildScrollView(
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
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: EdgeInsets.all(10),
              child: FutureBuilder(
                future: _getTaskDetails(project['id']),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final taskDetails = snapshot.data;
                    _progressValue = taskDetails!['progress'] / 100;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Project Name:',    //splitted the name for give differ colour
                          style: GoogleFonts.heptaSlab(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),


                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProjectDetailsPage(project: {
                                      'id': project['id'],
                                      'name': project['name'],
                                      'hours': project['hours'],
                                      'e_date': project['e_date'],
                                      'description': project['desp'],
                                      'created': project['s_date'],
                                      'priority': project['priority'],
                                      'created_by': project['created_by'],
                                      'status': project['pm_status'],
                                      'leader_name': taskDetails!['project_leader_name'],
                                      'team': taskDetails!['team_name'],
                                      'opentask': taskDetails!['opentask'],
                                      'com_task': taskDetails!['com_task'],
                                      'total_task': taskDetails!['total_task'],
                                    }),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white70, // set the background color
                            textStyle: GoogleFonts.heptaSlab(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Colors.white, // set the text color
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20), // set the padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), // set the border radius
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "${project['name']}",
                                style: GoogleFonts.heptaSlab(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red,
                                ),

                              ),
                              Text(
                                'Click for details',
                                style: GoogleFonts.heptaSlab(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),



                        SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(Icons.timer, color: Colors.green,
                                size: 26.0),
                            Expanded(
                              child: Text(
                                'Deadline:',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${project['e_date']}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),


                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.check_circle_outline, color: Colors.green,size: 26.0),
                            Expanded(
                              child: Text(
                                'Open tasks:',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${taskDetails!['opentask']}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),



                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 24.0,
                            ),
                            Expanded(
                              child: Text(
                                'Completed tasks:',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${taskDetails!['com_task']}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),



                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,size: 24.0
                            ),
                            Expanded(
                              child: Text(
                                'Total tasks:',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${taskDetails['total_task']}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),



                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.person, color: Colors.green,
                                size: 24.0),
                            Expanded(
                              child: Text(
                                'Project Leader:',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${taskDetails!['project_leader_name']}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),



                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.people, color: Colors.green,
                                size: 24.0),
                            Expanded(
                              child: Text(
                                'Team:',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${taskDetails!['team_name']}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),



                        SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: _progressValue,
                          backgroundColor: Colors.grey,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '${taskDetails['progress']}%',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      'Project Name: ${project['name']}',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else {
                    return Center(
                      child: Container(

                      color: Colors.white.withOpacity(0.5),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Loading...',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),);
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProjectDetailsPage extends StatefulWidget {
  final dynamic project;

  const ProjectDetailsPage({Key? key, required this.project}) : super(key: key);

  @override
  _ProjectDetailsPageState createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    // simulate loading data
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(widget.project['name']),
      ),



      body: _isLoading
          ? Center(
        child: Container(

        color: Colors.white.withOpacity(0.5),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(    //circular
                      strokeWidth: 5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.black),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
      )

          : Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                'Project Description:',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${widget.project['description']}',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Project Details:',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 8),




              SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(Icons.task, color: Colors.orange,),
                                  SizedBox(width: 5.0),
                                  Text(
                                    'Total Task',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '  ${widget.project['total_task']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10.0),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(Icons.task_alt, color: Colors.blue),
                                  SizedBox(width: 8.0),
                                  Text(
                                    'Open Task',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '  ${widget.project['opentask']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(Icons.task_alt_rounded, color: Colors.green),
                                  SizedBox(width: 8.0),
                                  Expanded(
                                    child: Text(
                                      'Completed Task',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '  ${widget.project['com_task']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 12,
              ),
              Table(
                border: TableBorder.all(color: Colors.grey),
                children: [
                  TableRow(children: [
                    TableCell(
                      child: Container(
                        color: Colors.grey[200], // light grey background
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Total Hours',
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        color: Colors.grey[200], // light grey background
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Text(
                            '${widget.project['hours']}',
                            style: GoogleFonts.roboto(),
                          ),
                        ),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Container(
                        color: Colors.grey[50], // light brown background
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Created',
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        color: Colors.grey[50], // light brown background
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${widget.project['created']}',
                            style: GoogleFonts.roboto(),
                          ),
                        ),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Container(
                        color: Colors.grey[200], // light grey background
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Deadline',
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        color: Colors.grey[200], // light grey background
                        child: Padding(
                          padding: const EdgeInsets.all(11),
                          child: Text(
                            '${widget.project['e_date']}',
                            style: GoogleFonts.roboto(),
                          ),
                        ),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Container(
                        color: Colors.grey[50], // light brown background
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Priority',
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        color: Colors.grey[50], // light brown background
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${widget.project['priority']}',
                            style: GoogleFonts.roboto(),
                          ),
                        ),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Container(
                        color: Colors.grey[200], // light grey background
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Created by',
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        color: Colors.grey[200], // light grey background
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Text(
                            '${widget.project['created_by']}',
                            style: GoogleFonts.roboto(),
                          ),
                        ),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Container(
                        color: Colors.grey[50],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Status',
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        color: Colors.grey[50],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${widget.project['status']}',
                            style: GoogleFonts.roboto(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'Assigned Leader:',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${widget.project['leader_name']}',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Assigned Employee:',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${widget.project['team']}',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
