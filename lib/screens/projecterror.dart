import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectError extends StatefulWidget {
  const ProjectError({Key? key}) : super(key: key);

  @override
  State<ProjectError> createState() => _ProjectErrorState();
}

class _ProjectErrorState extends State<ProjectError> {
  String selectedProject = '';
  List<Map<String, dynamic>> projectErrors = [];
  List<dynamic> _projects = [];
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _updaterNameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProjectErrors();
    Project();
  }

  Future<void> Project() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final response = await http.get(
      Uri.parse(
         'https://agrarian-tooth.000webhostapp.com/cli_project_status.php?user_id=$userId'),
         // 'http://192.168.0.76/d_shadowws_client_5/cli_project_status.php?user_id=$userId'),
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

  Future<void> updateData(int id, String errorDate, String errorUpdaterName,
      String errorTitle, String desp) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    // Construct the URL for the PHP script
    String url =
       'https://agrarian-tooth.000webhostapp.com/update_cli_project_error.php?id=$id&user_id=$userId';
        //'http://192.168.0.76/d_shadowws_client_5/update_cli_project_error.php?id=$id&user_id=$userId';

    // Construct the HTTP POST request body
    Map<String, String> body = {
      'error_date': errorDate,
      'error_updater_name': errorUpdaterName,
      'error_title': errorTitle,
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

  Future<void> fetchProjectErrors() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final response = await http.get(Uri.parse(
        'https://agrarian-tooth.000webhostapp.com/cli_project_error.php?user_id=$userId'));
        //'http://192.168.0.76/d_shadowws_client_5/cli_project_error.php?user_id=$userId'));
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        projectErrors =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    } else {
      throw Exception('Failed to fetch project errors');
    }
  }

  Future<void> deleteProjectError(String id) async {
    final response = await http.delete(
      Uri.parse(
          'https://agrarian-tooth.000webhostapp.com/delete_cli_project_error.php?id=$id'),
         // 'http://192.168.0.76/d_shadowws_client_5delete_cli_project_error.php?id=$id'),
    );
    print(id);
    if (response.statusCode == 200) {
      setState(() {
        projectErrors.removeWhere((error) => error['id'] == id);

      });
    } else {
      throw Exception('Failed to delete project error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text('Project Error'),
        ),
        body:
         Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columnSpacing: 20,
                  decoration: BoxDecoration(border: Border.all(color: Colors.black)),
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
                    ),DataColumn(
                      label: Text(
                        'Edit',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),DataColumn(
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
                    for (var i = 0; i < projectErrors.length; i++)
                      DataRow(
                        cells: [
                          //for (var i = 0; i < projectErrors.length; i++)
                          DataCell(Text((i + 1).toString()),),
                          DataCell(Text(projectErrors[i]['project_name']),),
                          DataCell(Text(projectErrors[i]['error_date']),),
                          DataCell(Text(projectErrors[i]['error_updater_name']),),
                          DataCell( Text(projectErrors[i]['error_title']),),


                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Populate the input fields with the selected project error's data
                                  selectedProject = projectErrors[i]['project_name'];
                                  _dateController.text =
                                  projectErrors[i]['error_date'];
                                  _updaterNameController.text =
                                  projectErrors[i]['error_updater_name'];
                                  _titleController.text =
                                  projectErrors[i]['error_title'];
                                  _descriptionController.text =
                                  projectErrors[i]['desp'];

                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Edit Project Error'),
                                      content: Container(
                                        height: 400,
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              controller: _dateController,
                                              decoration: InputDecoration(
                                                  labelText: 'Error Date'),
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
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
                                                if (value == null || value.isEmpty) {
                                                  return 'Please enter an updater name';
                                                }
                                                return null;
                                              },
                                            ),
                                            TextFormField(
                                              controller: _titleController,
                                              decoration: InputDecoration(
                                                  labelText: 'Error Title'),
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please enter an error title';
                                                }
                                                return null;
                                              },
                                            ),
                                            TextFormField(
                                              controller: _descriptionController,
                                              decoration: InputDecoration(
                                                  labelText: 'Error Description'),
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please enter an error description';
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
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
                                              'id': projectErrors[i]['id'],
                                              'project_name': selectedProject,
                                              'error_date': _dateController.text,
                                              'error_updater_name':
                                              _updaterNameController.text,
                                              'error_title': _titleController.text,
                                              'desp': _descriptionController.text,
                                            };
                                            await updateData(
                                                int.parse(projectErrors[i]['id']),
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
                                  deleteProjectError(projectErrors[i]['id']);
                                },
                              ),
                            ],

                          )),

                        ],
                        color: MaterialStateColor.resolveWith(   // added to colour one by one by auto increment with serial no
                              (states) =>
                          i % 2 == 0 ? Colors.red.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                        ),
                      ),
                  ],
                ),
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
                    title: Text('Add Project Error'),
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
                                      child: Text('Select a project'),
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
                                    labelText: 'Error Date',
                                  ),
                                  controller: _dateController,
                                  onTap: () {
                                    _selectDate(context);
                                  },
                                ),
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Error Updater Name',
                                  ),
                                  controller: _updaterNameController,
                                ),
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Error Title',
                                  ),
                                  controller: _titleController,
                                ),
                                TextField(
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    labelText: 'Error Description',
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
                                 'https://agrarian-tooth.000webhostapp.com/save_cli_project_error.php?user_id=$userId'),
                               //   'http://192.168.0.76/d_shadowws_client_5/save_cli_project_error.php?user_id=$userId'),
                              body: {
                                'project_id': projectId,
                                'error_date': errorDate,
                                'error_updater_name': updaterName,
                                'error_title': errorTitle,
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