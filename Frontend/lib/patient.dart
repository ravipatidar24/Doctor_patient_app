// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
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

// class PatientPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Container(
//           margin: EdgeInsets.all(24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _header(),
//               _inputField(context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   _header() {
//     return Column(
//       children: [
//         Text(
//           "Welcome Back",
//           style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
//         ),
//         Text("Enter your credentials to login"),
//       ],
//     );
//   }

//   _inputField(context) {
//     String mobileNumber = '';

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         TextField(
//           onChanged: (value) {
//             mobileNumber = value;
//           },
//           decoration: InputDecoration(
//             hintText: "Mobile No.",
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(18),
//               borderSide: BorderSide.none,
//             ),
//             fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
//             filled: true,
//             prefixIcon: Icon(Icons.person),
//           ),
//         ),
//         SizedBox(height: 10),
//         ElevatedButton(
//           onPressed: () {
//             if (mobileNumber.isNotEmpty) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => PatientsPage1(
//                     mobileNumber: mobileNumber,
//                   ),
//                 ),
//               );
//             }
//           },
//           child: Text(
//             "Login",
//             style: TextStyle(fontSize: 20),
//           ),
//           style: ElevatedButton.styleFrom(
//             shape: StadiumBorder(),
//             padding: EdgeInsets.symmetric(vertical: 16),
//           ),
//         )
//       ],
//     );
//   }
// }

// class PatientsPage1 extends StatefulWidget {
//   final String mobileNumber;

//   PatientsPage1({required this.mobileNumber});

//   @override
//   _PatientsPageState createState() => _PatientsPageState();
// }

// class _PatientsPageState extends State<PatientsPage1> {
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
//           filteredPatients = fetchedPatients
//               .where((patient) => patient.mobileNumber == widget.mobileNumber)
//               .toList();
//         });
//       } else {
//         print('Failed to fetch patients: ${response.statusCode}');
//       }
//     } catch (error) {
//       print('Failed to fetch patients: $error');
//     }
//   }

//   void search(String query) {
//     setState(() {
//       filteredPatients = patients
//           .where((patient) =>
//               patient.name.toLowerCase().contains(query.toLowerCase()) ||
//               patient.date.toLowerCase().contains(query.toLowerCase()))
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
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               onChanged: search,
//               decoration: InputDecoration(
//                 labelText: 'Search',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(18),
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
//                     trailing: Icon(Icons.keyboard_arrow_right),
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

// class PatientDetailsPage extends StatefulWidget {
//   final Patient patient;

//   PatientDetailsPage({required this.patient});

//   @override
//   _PatientDetailsPageState createState() => _PatientDetailsPageState();
// }

// class _PatientDetailsPageState extends State<PatientDetailsPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Patient Details'),
//       ),
//       body: ListView(
//         children: [
//           ListTile(
//             title: Text('Name: ${widget.patient.name}'),
//           ),
//           ListTile(
//             title: Text('Mobile Number: ${widget.patient.mobileNumber}'),
//           ),
//           ListTile(
//             title: Text('Date: ${widget.patient.date}'),
//           ),
//           ListTile(
//             title: Text('Description: ${widget.patient.description}'),
//           ),
//           ListTile(
//             title: Text('Total Bill: ${widget.patient.totalBill}'),
//           ),
//           if (widget.patient.imageUrl1 != null) ...[
//             ListTile(
//               title: Text('Image 1:'),
//             ),
//             CachedNetworkImage(
//               imageUrl: widget.patient.imageUrl1!,
//               placeholder: (context, url) => CircularProgressIndicator(),
//               errorWidget: (context, url, error) => Icon(Icons.error),
//             ),
//           ],
//           if (widget.patient.imageUrl2 != null) ...[
//             ListTile(
//               title: Text('Image 2:'),
//             ),
//             CachedNetworkImage(
//               imageUrl: widget.patient.imageUrl2!,
//               placeholder: (context, url) => CircularProgressIndicator(),
//               errorWidget: (context, url, error) => Icon(Icons.error),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     title: 'Patient App',
//     home: PatientPage(),
//   ));
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

class PatientPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(),
              _inputField(context),
            ],
          ),
        ),
      ),
    );
  }

  _header() {
    return Column(
      children: [
        Text(
          "Welcome Back",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text("Enter your credentials to login"),
      ],
    );
  }

  _inputField(context) {
    String mobileNumber = '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          onChanged: (value) {
            mobileNumber = value;
          },
          decoration: InputDecoration(
            hintText: "Mobile No.",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.person),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            if (mobileNumber.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PatientsPage1(
                    mobileNumber: mobileNumber,
                  ),
                ),
              );
            }
          },
          child: Text(
            "Login",
            style: TextStyle(fontSize: 20),
          ),
          style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
        )
      ],
    );
  }
}

class PatientsPage1 extends StatefulWidget {
  final String mobileNumber;

  PatientsPage1({required this.mobileNumber});

  @override
  _PatientsPageState createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage1> {
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
          filteredPatients = fetchedPatients
              .where((patient) => patient.mobileNumber == widget.mobileNumber)
              .toList();
        });
      } else {
        print('Failed to fetch patients: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to fetch patients: $error');
    }
  }

  void search(String query) {
    setState(() {
      filteredPatients = patients
          .where((patient) =>
              patient.name.toLowerCase().contains(query.toLowerCase()) ||
              patient.date.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

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
        title: Text('Patients Details'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: search,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
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
                      ],
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right),
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

class PatientDetailsPage extends StatefulWidget {
  final Patient patient;

  PatientDetailsPage({required this.patient});

  @override
  _PatientDetailsPageState createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
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
        children: <Widget>[
          ListTile(
            title: Text('Name'),
            subtitle: Text(widget.patient.name),
          ),
          ListTile(
            title: Text('Mobile Number'),
            subtitle: Text(widget.patient.mobileNumber),
          ),
          ListTile(
            title: Text('Date'),
            subtitle: Text(widget.patient.date),
          ),
          ListTile(
            title: Text('Description'),
            subtitle: Text(widget.patient.description),
          ),
          ListTile(
            title: Text('Total Bill'),
            subtitle: Text(widget.patient.totalBill.toString()),
          ),
          if (widget.patient.imageUrl1 != null) ...[
            ListTile(
              title: Text('Image 1'),
              subtitle: CachedNetworkImage(
                imageUrl: widget.patient.imageUrl1!,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            IconButton(
              icon: Icon(Icons.download),
              onPressed: () => _saveImage(widget.patient.imageUrl1!, context),
            ),
          ],
          if (widget.patient.imageUrl2 != null) ...[
            ListTile(
              title: Text('Image 2'),
              subtitle: CachedNetworkImage(
                imageUrl: widget.patient.imageUrl2!,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            IconButton(
              icon: Icon(Icons.download),
              onPressed: () => _saveImage(widget.patient.imageUrl1!, context),
            ),
          ],
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Patient App',
    home: PatientPage(),
  ));
}
