// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:typed_data';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';

// class Patient {
//   String name;
//   String mobileNumber;
//   String date;
//   String description;
//   double totalBill;
//   String? imageUrl1;
//   String? imageUrl2;

//   Patient({
//     required this.name,
//     required this.mobileNumber,
//     required this.date,
//     required this.description,
//     required this.totalBill,
//     this.imageUrl1,
//     this.imageUrl2,
//   });

//   factory Patient.fromJson(Map<String, dynamic> json) {
//     return Patient(
//       name: json['name'],
//       mobileNumber: json['mobileNumber'],
//       date: json['date'],
//       description: json['description'],
//       totalBill: json['totalBill'].toDouble(),
//       imageUrl1: json['imageUrl1'],
//       imageUrl2: json['imageUrl2'],
//     );
//   }
// }

// class PatientsPage extends StatefulWidget {
//   @override
//   _PatientsPageState createState() => _PatientsPageState();
// }

// class _PatientsPageState extends State<PatientsPage> {
//   List<Patient> patients = [];
//   List<Patient> filteredPatients = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchPatients();
//   }

//   Future<void> fetchPatients() async {
//     try {
//       final response = await http.get(Uri.parse('http://172.22.12.212:3000/projects'));

//       if (response.statusCode == 200) {
//         final List<dynamic> jsonData = jsonDecode(response.body);
//         final List<Patient> fetchedPatients = jsonData
//             .map<Patient>((item) => Patient.fromJson(item))
//             .toList();

//         setState(() {
//           patients = fetchedPatients;
//           filteredPatients = fetchedPatients;
//         });
//       } else {
//         print('Failed to fetch patients: ${response.statusCode}');
//       }
//     } catch (error) {
//       print('Failed to fetch patients: $error');
//     }
//   }

//   Future<void> deleteProject(Patient patient) async {
//   try {
//     final url = Uri.parse('http://172.22.12.212:3000/projects');
//     final response = await http.delete(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'name': patient.name,
//         'mobileNumber': patient.mobileNumber,
//         'date': patient.date,
//         'description': patient.description,
//         'totalBill': patient.totalBill.toString(),
//         'image1': patient.imageUrl1 ?? '',
//         'image2': patient.imageUrl2 ?? '',
//       }),
//     );

//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Project deleted successfully'),
//         ),
//       );
//       // Perform any necessary operations after successful deletion

//       // Refetch the patients to update the list
//       fetchPatients();
//     } else {
//       print('Failed to delete project: ${response.statusCode}');
//     }
//   } catch (error) {
//     print('Failed to delete project: $error');
//   }
// }

//   void filterPatients(String query) {
//     setState(() {
//       filteredPatients = patients
//           .where((patient) =>
//               patient.name.toLowerCase().contains(query.toLowerCase()) ||
//               patient.mobileNumber.contains(query) ||
//               patient.date.contains(query))
//           .toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Patients Details'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding:            const EdgeInsets.all(8.0),
//             child: TextField(
//               onChanged: (value) => filterPatients(value),
//               decoration: InputDecoration(
//                 labelText: 'Search',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: filteredPatients.length,
//               itemBuilder: (context, index) {
//                 Patient patient = filteredPatients[index];
//                 return Card(
//                   child: ListTile(
//                     title: Text(patient.name),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(patient.mobileNumber),
//                         Text(patient.date),
//                       ],
//                     ),
//                     trailing: IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () {
//                         showDialog(
//                           context: context,
//                           builder: (context) {
//                             return AlertDialog(
//                               title: Text('Delete Patient'),
//                               content: Text('Are you sure you want to delete this patient?'),
//                               actions: [
//                                 TextButton(
//                                   child: Text('Cancel'),
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   },
//                                 ),
//                                 TextButton(
//                                   child: Text('Delete'),
//                                   onPressed: () {
//                                     deleteProject(patient);
//                                     Navigator.pop(context);
//                                   },
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       },
//                     ),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => PatientDetailsPage(patient: patient),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class PatientDetailsPage extends StatelessWidget {
//   final Patient patient;

//   PatientDetailsPage({required this.patient});

//   Future<void> _saveImage(String imageUrl, BuildContext context) async {
//     try {
//       var response = await http.get(Uri.parse(imageUrl));
//       final result = await ImageGallerySaver.saveImage(
//         Uint8List.fromList(response.bodyBytes),
//         quality: 100,
//       );
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Image saved'),
//         ),
//       );
//       print('Image saved: $result');
//     } catch (error) {
//       print('Failed to save image: $error');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Patient Details'),
//       ),
//       body: ListView(
//         children: [
//           ListTile(
//             title: Text('Name: ${patient.name}'),
//           ),
//           ListTile(
//             title: Text('Mobile Number: ${patient.mobileNumber}'),
//           ),
//           ListTile(
//             title: Text('Date: ${patient.date}'),
//           ),
//           ListTile(
//             title: Text('Description: ${patient.description}'),
//           ),
//           ListTile(
//             title: Text('Total Bill: ${patient.totalBill}'),
//           ),
//           if (patient.imageUrl1 != null) ...[
//             ListTile(
//               title: Text('Image 1:'),
//             ),
//             CachedNetworkImage(
//               imageUrl: patient.imageUrl1!,
//               placeholder: (context, url) => CircularProgressIndicator(),
//               errorWidget: (context, url, error) => Icon(Icons.error),
//             ),
//             ElevatedButton(
//               child: Text('Download Image'),
//               onPressed: () {
//                 _saveImage(patient.imageUrl1!, context);
//               },
//             ),
//           ],
//           if (patient.imageUrl2 != null) ...[
//             ListTile(
//               title: Text('Image 2:'),
//             ),
//             CachedNetworkImage(
//               imageUrl: patient.imageUrl2!,
//               placeholder: (context, url) => CircularProgressIndicator(),
//               errorWidget: (context, url, error) => Icon(Icons.error),
//             ),
//             ElevatedButton(
//               child: Text('Download Image'),
//               onPressed: () {
//                 _saveImage(patient.imageUrl2!, context);
//               },
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class Patient {
  String name;
  String mobileNumber;
  String date;
  String description;
  double totalBill;
  String? imageUrl1;
  String? imageUrl2;

  Patient({
    required this.name,
    required this.mobileNumber,
    required this.date,
    required this.description,
    required this.totalBill,
    this.imageUrl1,
    this.imageUrl2,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      name: json['name'],
      mobileNumber: json['mobileNumber'],
      date: json['date'],
      description: json['description'],
      totalBill: json['totalBill'].toDouble(),
      imageUrl1: json['imageUrl1'],
      imageUrl2: json['imageUrl2'],
    );
  }
}

class PatientsPage extends StatefulWidget {
  @override
  _PatientsPageState createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  List<Patient> patients = [];
  List<Patient> filteredPatients = [];

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/projects'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        final List<Patient> fetchedPatients =
            jsonData.map<Patient>((item) => Patient.fromJson(item)).toList();

        setState(() {
          patients = fetchedPatients;
          filteredPatients = fetchedPatients;
        });
      } else {
        print('Failed to fetch patients: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to fetch patients: $error');
    }
  }

  Future<void> deleteProject(Patient patient) async {
    try {
      final url = Uri.parse('http://localhost:3000/projects');
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': patient.name,
          'mobileNumber': patient.mobileNumber,
          'date': patient.date,
          'description': patient.description,
          'totalBill': patient.totalBill.toString(),
          'image1': patient.imageUrl1 ?? '',
          'image2': patient.imageUrl2 ?? '',
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data deleted successfully'),
          ),
        );
        // Perform any necessary operations after successful deletion

        // Refetch the patients to update the list
        fetchPatients();
      } else {
        print('Failed to delete project: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to delete project: $error');
    }
  }

  void filterPatients(String query) {
    setState(() {
      filteredPatients = patients
          .where((patient) =>
              patient.name.toLowerCase().contains(query.toLowerCase()) ||
              patient.mobileNumber.contains(query) ||
              patient.date.contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patients Details'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => filterPatients(value),
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPatients.length,
              itemBuilder: (context, index) {
                Patient patient = filteredPatients[index];
                return Card(
                  child: ListTile(
                    title: Text(patient.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(patient.mobileNumber),
                        Text(patient.date),
                        SizedBox(height: 20),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Delete Patient'),
                              content: Text(
                                  'Are you sure you want to delete this patient?'),
                              actions: [
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: Text('Delete'),
                                  onPressed: () {
                                    deleteProject(patient);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PatientDetailsPage(patient: patient),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PatientDetailsPage extends StatelessWidget {
  final Patient patient;

  PatientDetailsPage({required this.patient});

  Future<void> _saveImage(String imageUrl, BuildContext context) async {
    try {
      var response = await http.get(Uri.parse(imageUrl));
      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.bodyBytes),
        quality: 100,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image saved'),
        ),
      );
      print('Image saved: $result');
    } catch (error) {
      print('Failed to save image: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Details'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Name: ${patient.name}'),
          ),
          ListTile(
            title: Text('Mobile Number: ${patient.mobileNumber}'),
          ),
          ListTile(
            title: Text('Date: ${patient.date}'),
          ),
          ListTile(
            title: Text('Description: ${patient.description}'),
          ),
          ListTile(
            title: Text('Total Bill: ${patient.totalBill}'),
          ),
          if (patient.imageUrl1 != null) ...[
            SizedBox(height: 10),
            ListTile(
              title: Text('Image 1:'),
            ),
            CachedNetworkImage(
              imageUrl: patient.imageUrl1!,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Download Image'),
              onPressed: () {
                _saveImage(patient.imageUrl1!, context);
              },
            ),
          ],
          if (patient.imageUrl2 != null) ...[
            SizedBox(height: 10),
            ListTile(
              title: Text('Image 2:'),
            ),
            CachedNetworkImage(
              imageUrl: patient.imageUrl2!,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Download Image'),
              onPressed: () {
                _saveImage(patient.imageUrl2!, context);
              },
            ),
          ],
        ],
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PatientsPage(),
    );
  }
}
