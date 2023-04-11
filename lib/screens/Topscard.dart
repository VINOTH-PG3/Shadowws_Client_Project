import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/projecterror.dart';
import 'package:flutter_firebase/screens/projectupdate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'project_status.dart';

class TopCard extends StatefulWidget {
  const TopCard({Key? key}) : super(key: key);

  @override
  State<TopCard> createState() => _TopCardState();
}

class _TopCardState extends State<TopCard> {
  int _projectCount = 0;
  int _projectupdates = 0;
  int _projectErrors = 0;
  int _pendingTasks = 5;

  @override
  void initState() {
    super.initState();
    _getProjectCount();
  }

  Future<void> _getProjectCount() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    final response = await http.get(
      Uri.parse(
          'https://agrarian-tooth.000webhostapp.com/cli_dash.php?user_id=$userId'),
      //'http://192.168.0.76/d_shadowws_client_5/cli_dash.php?user_id=$userId'),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);
    final data = jsonDecode(response.body);
    await prefs.setString('project_id', data['project_id']);
    await prefs.setString('team_leader_id', data['team_leader_id']);
    await prefs.setString('team', data['team']);
    setState(() {
      _projectCount = int.parse(data['count']);
      _projectupdates = int.parse(data['updates']);
      _projectErrors = int.parse(data['errors']);
      _pendingTasks = data['pendingtask'];
    });
  }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment:
//       CrossAxisAlignment.stretch, // stretch the children to fill the width
//       children: [
//
//
//         // first row
//         SizedBox(height: 20),
//         Row(
//           children: [
//             Flexible(
//               child: InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => ProjectStatus()),
//                   );
//                 },
//                 child: Container(
//
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 4,
//                         blurRadius: 6,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   margin: EdgeInsets.symmetric(horizontal: 14),
//                   padding: EdgeInsets.all(20),//box outer size1
//
//
//                   child: Column(     //first container
//                     children: [ Text(
//                       "Completed Project",
//                       style: TextStyle(fontSize: 26, color: Colors.red),
//                     ),
//                             SizedBox(height: 20),  //hieght of box
//
//                               Text(
//                                 "$_projectCount",
//                                 style: TextStyle(fontSize: 24, color: Colors.black),
//                               ),
//                               ],
//                             ),
//                       ),
//                 ),
//             ),
//
//             Flexible(
//               child: InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => ProjectUpdate()),
//                   );
//                 },
//                 child: Container(
//
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 4,
//                         blurRadius: 6,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   margin: EdgeInsets.symmetric(horizontal: 14),
//                   padding: EdgeInsets.all(19),//box outer size1
//
//
//                   child: Column(     //first container
//                     children: [ Text(
//                       "Project Updates",
//                       style: TextStyle(fontSize: 26, color: Colors.red),
//                     ),
//                       SizedBox(height: 20),  //hieght of box
//
//                       Text(
//                         "$_projectupdates",
//                         style: TextStyle(fontSize: 24, color: Colors.black),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 35),
//
//
//
//         SizedBox(height: 20),
//         Row(
//           children: [
//             Flexible(
//               child: InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => ProjectStatus()),
//                   );
//                 },
//                 child: Container(
//
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 4,
//                         blurRadius: 6,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   margin: EdgeInsets.symmetric(horizontal: 14),
//                   padding: EdgeInsets.all(20),//box outer size1
//
//
//                   child: Column(     //first container
//                     children: [ Text(
//                       "Project Errors",
//                       style: TextStyle(fontSize: 26, color: Colors.red),
//                     ),
//                       SizedBox(height: 20),  //hieght of box
//
//                       Text(
//                         "$_projectErrors",
//                         style: TextStyle(fontSize: 24, color: Colors.black),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//
//             Flexible(
//               child: InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => ProjectUpdate()),
//                   );
//                 },
//                 child: Container(
//
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 4,
//                         blurRadius: 6,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   margin: EdgeInsets.symmetric(horizontal: 14),
//                   padding: EdgeInsets.all(19),//box outer size1
//
//
//                   child: Column(     //first container
//                     children: [ Text(
//                       "Pending Task",
//                       style: TextStyle(fontSize: 26, color: Colors.red),
//                     ),
//                       SizedBox(height: 20),  //hieght of box
//
//                       Text(
//                         "$_pendingTasks",
//                         style: TextStyle(fontSize: 24, color: Colors.black),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 35),
//
//
//
//         Row(
//           children: [
//             Flexible(
//               child: InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => ProjectError()),
//                   );
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 4,
//                         blurRadius: 6,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   margin: EdgeInsets.symmetric(horizontal: 14),
//                   padding: EdgeInsets.all(23),
//                   child: Column(
//                     children: [
//                       Text(
//                         "Project Errors",
//                         style: TextStyle(fontSize: 26, color: Colors.red),
//                       ),
//                       SizedBox(height: 20),
//                       Text(
//                         "$_projectErrors",
//                         style: TextStyle(fontSize: 24, color: Colors.black),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//
//  // fourth container in second row
//               SizedBox(width: 15),
//             Flexible(
//               child: GestureDetector(
//                 onTap: () {},
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 4,
//                         blurRadius: 6,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   margin: EdgeInsets.symmetric(horizontal: 14),
//                   padding: EdgeInsets.all(25),
//                   child: Column(
//                     children: [
//                       Text(
//                         "Pending Task",
//                         style: TextStyle(fontSize: 26, color: Colors.red),
//                       ),
//                       SizedBox(height: 20),
//                       Text(
//                         "$_pendingTasks",
//                         style: TextStyle(fontSize: 24, color: Colors.black),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProjectStatus()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 4,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 14),
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  child: Column(
                    children: [
                      Text(
                        "Completed Project",
                        style: TextStyle(
                          fontSize: screenWidth * 0.055,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.03),
                      Text(
                        "$_projectCount",
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProjectUpdate()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 4,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 18),
                  padding: EdgeInsets.all(screenWidth * 0.09),
                  child: Column(
                    children: [
                      Text(
                        "Updates",
                        style: TextStyle(
                          fontSize: screenWidth * 0.055,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.03),
                      Text(
                        "$_projectupdates",
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        // Use a fraction of the screen width as box height
        SizedBox(height: screenWidth * 0.07),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProjectError()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 4,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 14),
                  padding: EdgeInsets.all(screenWidth * 0.12),
                  child: Column(
                    children: [
                      Text(
                        "Error",
                        style: TextStyle(
                          fontSize: screenWidth * 0.055,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.03),
                      Text(
                        "$_projectErrors",
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),


            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 4,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 18),
                  padding: EdgeInsets.all(screenWidth * 0.083),
                  child: Column(
                    children: [
                      Text(
                        "Pending Task",
                        style: TextStyle(
                          fontSize: screenWidth * 0.055,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.03),
                      Text(
                        "$_pendingTasks",
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: screenWidth * 0.07),
        // Use a fraction of the screen width as box height
      ],
    );
  }
}