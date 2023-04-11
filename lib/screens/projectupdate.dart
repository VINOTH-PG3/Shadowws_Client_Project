import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';




class ProjectUpdate extends StatefulWidget {
  const ProjectUpdate({Key? key}) : super(key: key);

  @override
  State<ProjectUpdate> createState() => _ProjectUpdateState();
}

class _ProjectUpdateState extends State<ProjectUpdate> {
  String selectedProject = '';
  List<Map<String, dynamic>> projectUpdates = [];
  List<dynamic> _projects = [];
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _updaterNameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProjectUpdates();
    Project();
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

  Future<void> updateData(int id, String updateDate, String updateUpdaterName,
      String updateTitle, String desp) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    // Construct the URL for the PHP script
    String url =
        'https://agrarian-tooth.000webhostapp.com/update_cli_project_update.php?id=$id&user_id=$userId';
       // 'http://192.168.0.76/d_shadowws_client_5/update_cli_project_update.php?id=$id&user_id=$userId';
    // Construct the HTTP POST request body
    Map<String, String> body = {
      'update_date': updateDate,
      'updater_name': updateUpdaterName,
      'update_title': updateTitle,
      'desp': desp,
    };

    // Send the HTTP POST request to the PHP script
    http.Response response = await http.post(Uri.parse(url), body: body);

    // Check the response status code
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print('Error updating data: ${response.statusCode}');
    }
  }

  Future<void> fetchProjectUpdates() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final response = await http.get(Uri.parse(
        'https://agrarian-tooth.000webhostapp.com/cli_project_update.php?user_id=$userId'));
        //'http://192.168.0.76/d_shadowws_client_5/cli_project_update.php?user_id=$userId'));
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        projectUpdates =
        List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    } else {
      throw Exception('Failed to fetch project errors');
    }
  }

  Future<void> deleteProjectUpdate(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('https://agrarian-tooth.000webhostapp.com/delete_cli_project_update.php?id=$id'),
       // Uri.parse('http://192.168.0.76/d_shadowws_client_5/delete_cli_project_update.php?id=$id'),
      ).timeout(Duration(seconds: 30)); // set the timeout duration to 30 seconds
      //print(id);
      if (response.statusCode == 200) {
        setState(() {
          projectUpdates.removeWhere((update) => update['id'] == id);
        });
      } else {
        throw Exception('Failed to delete project update');
      }
    } on TimeoutException catch (e) {
      throw Exception('Request timed out');
    } catch (e) {
      throw Exception('Failed to delete project update: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Project update'),
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columnSpacing: 20,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black)),
              columns: [
                DataColumn(
                  label: Text(
                    'S.No',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Project',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'update Date',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Updated By',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ), DataColumn(
                  label: Text(
                    'update Title',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ), DataColumn(
                  label: Text(
                    'Edit',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ), DataColumn(
                  label: Text(
                    'Delete',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                ),

              ],
              rows: [
                for (var i = 0; i < projectUpdates.length; i++)
                  DataRow(
                    cells: [
                      //for (var i = 0; i < projectErrors.length; i++)
                      DataCell(Text((i + 1).toString()),),
                      DataCell(Text(projectUpdates[i]['project_name']),),
                      DataCell(Text(projectUpdates[i]['update_date']),),
                      DataCell(Text(projectUpdates[i]['updater_name']),),
                      DataCell(Text(projectUpdates[i]['update_title']),),


                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // Populate the input fields with the selected project error's data
                              selectedProject =
                              projectUpdates[i]['project_name'];
                              _dateController.text =
                              projectUpdates[i]['update_date'];
                              _updaterNameController.text =
                              projectUpdates[i]['updater_name'];
                              _titleController.text =
                              projectUpdates[i]['update_title'];
                              _descriptionController.text =
                              projectUpdates[i]['desp'];

                              showDialog(
                                context: context,
                                builder: (context) =>
                                    AlertDialog(
                                      title: Text('Edit Project update'),
                                      content: Container(
                                        height: 400,
                                        child: Column(
                                            children: [
                                              TextFormField(
                                                controller: _dateController,
                                                decoration: InputDecoration(
                                                    labelText: 'update Date'),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please enter an error date';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              TextFormField(
                                                controller: _updaterNameController,
                                                decoration: InputDecoration(
                                                    labelText: 'Updater Name'),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please enter an updater name';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              TextFormField(
                                                controller: _titleController,
                                                decoration: InputDecoration(
                                                    labelText: 'update Title'),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please enter an error title';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              TextFormField(
                                                controller: _descriptionController,
                                                decoration: InputDecoration(
                                                    labelText: 'update Description'),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please enter an error description';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ]

                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text('CANCEL'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            final error = {
                                              'id': projectUpdates[i]['id'],
                                              'project_name': selectedProject,
                                              'update_date': _dateController
                                                  .text,
                                              'updater_name':
                                              _updaterNameController.text,
                                              'update_title': _titleController
                                                  .text,
                                              'desp': _descriptionController
                                                  .text,
                                            };
                                            await updateData(
                                                int.parse(
                                                    projectUpdates[i]['id']),
                                                _dateController.text,
                                                _updaterNameController.text,
                                                _titleController.text,
                                                _descriptionController.text);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('update'),
                                        ),
                                      ],
                                    ),
                              );
                            },
                          ),
                        ],
                      )),


                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deleteProjectUpdate(projectUpdates[i]['id']);
                            },
                          ),
                        ],
                      )),

                    ],
                    color: MaterialStateColor
                        .resolveWith( // added to colour one by one by auto increment with serial no
                          (states) =>
                      i % 2 == 0 ? Colors.red.withOpacity(0.2) : Colors.grey
                          .withOpacity(0.2),
                    ),
                  ),

              ],
            ),
          ),
        ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.red,
                  title: Text('Add Project update'),
                ),
                body: Column(
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DropdownButton<String>(
                                value: selectedProject,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedProject = value!;
                                  });
                                },
                                items: [
                                  DropdownMenuItem<String>(
                                    value: '',
                                    child: Text('Select project'),
                                  ),
                                  for (var project in _projects)
                                    DropdownMenuItem<String>(
                                      value: project['id'].toString(),
                                      child: Text(project['project_id']),
                                    ),

                                ],
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Update Date',
                                ),
                                controller: _dateController,
                                onTap: () {
                                  _selectDate(context);
                                },
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Update Updater Name',
                                ),
                                controller: _updaterNameController,
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Update Title',
                                ),
                                controller: _titleController,
                              ),
                              TextField(
                                maxLines: 3,
                                decoration: InputDecoration(
                                  labelText: 'Update Description',
                                  alignLabelWithHint: true,
                                  border: OutlineInputBorder(),
                                ),
                                controller: _descriptionController,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final userId = prefs.getString('user_id');

                        // Get the selected project ID from the dropdown
                        String projectId = selectedProject;

                        // Get the other data from the text fields
                        String errorDate = _dateController.text;
                        String updaterName = _updaterNameController.text;
                        String errorTitle = _titleController.text;
                        String description = _descriptionController.text;
                        String client =
                            ''; // Get the client from the project table using the selected project ID

                        // Make an HTTP POST request to the PHP script to insert the data into the database
                        var response = await http.post(
                            Uri.parse(
                                'https://agrarian-tooth.000webhostapp.com/save_cli_project_update.php?user_id=$userId'),
                              //  'http://192.168.0.76/d_shadowws_client_5/save_cli_project_update.php?user_id=$userId'),
                            body: {
                              'project_id': projectId,
                              'update_date': errorDate,
                              'updater_name': updaterName,
                              'update_title': errorTitle,
                              'desp': description,
                              'client': client,
                            });
                        Navigator.of(context).pop();
                        // Print the response from the server
                        print(response.body);
                      },
                      child: Text('Save'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),


    );
  }


  // method created foe _select state to display Date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: Colors.red),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
}