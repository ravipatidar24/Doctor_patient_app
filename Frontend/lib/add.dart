// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;

// class AddPage extends StatefulWidget {
//   @override
//   _AddPageState createState() => _AddPageState();
// }

// class _AddPageState extends State<AddPage> {
//   File? _image;
//   File? _additionalImage;
//   final picker = ImagePicker();

//   TextEditingController _patientNameController = TextEditingController();
//   TextEditingController _mobileNumberController = TextEditingController();
//   TextEditingController _dateController = TextEditingController();
//   TextEditingController _descriptionController = TextEditingController();
//   TextEditingController _totalBillController = TextEditingController();

//   final String baseUrl = 'http://172.22.12.212:3000'; // Replace with the IP address or hostname of your backend server

//   bool isConnected = false;

//   Future getImageFromGallery() async {
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       }
//     });
//   }

//   Future getAdditionalImageFromGallery() async {
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _additionalImage = File(pickedFile.path);
//       }
//     });
//   }

//   Future<void> savePatientDetails() async {
//     // Get the input values from text fields
//     String patientName = _patientNameController.text;
//     String mobileNumber = _mobileNumberController.text;
//     String date = _dateController.text;
//     String description = _descriptionController.text;
//     double totalBill = double.parse(_totalBillController.text);

//     // Create a multipart request
//     var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/projects'));
//     request.fields['name'] = patientName;
//     request.fields['mobileNumber'] = mobileNumber;
//     request.fields['date'] = date;
//     request.fields['description'] = description;
//     request.fields['totalBill'] = totalBill.toString();

//     // Attach the image files
//     if (_image != null) {
//       request.files.add(await http.MultipartFile.fromPath('image1', _image!.path));
//     }
//     if (_additionalImage != null) {
//       request.files.add(await http.MultipartFile.fromPath('image2', _additionalImage!.path));
//     } else {
//       request.fields['image2'] = ''; // Set an empty string if no additional image is selected
//     }

//     try {
//       // Send the request and get the response
//       var response = await request.send();

//       // Check the response status
//       if (response.statusCode == 201) {
//         // Success, data saved
//         // Show a success message or navigate to a success page
//         print('Data saved successfully');
//         setState(() {
//           isConnected = true;
//         });
//       } else {
//         // Error saving data
//         // Show an error message or handle the error
//         print('Failed to save data');
//       }
//     } catch (error) {
//       // Error sending the request
//       // Show an error message or handle the error
//       print('Error sending request: $error');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Patient Details'),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _patientNameController,
//               decoration: InputDecoration(labelText: 'Patient Name'),
//             ),
//             SizedBox(height: 16.0),
//             TextField(
//               controller: _mobileNumberController,
//               decoration: InputDecoration(labelText: 'Mobile Number'),
//             ),
//             SizedBox(height: 16.0),
//             TextField(
//               controller: _dateController,
//               decoration: InputDecoration(labelText: 'Date', hintText: 'Enter date in the format xx-yy-zzzz'),
//             ),
//             SizedBox(height: 16.0),
//             TextField(
//               controller: _descriptionController,
//               decoration: InputDecoration(labelText: 'Description', hintText: 'Write NA if nothing to write'),
//             ),
//             SizedBox(height: 16.0),
//             TextField(
//               controller: _totalBillController,
//               decoration: InputDecoration(labelText: 'Total Bill', hintText: 'Enter 00 if nothing to write in totalBill'),
//             ),
//             SizedBox(height: 16.0),
//             GestureDetector(
//               onTap: getImageFromGallery,
//               child: Container(
//                 height: 200,
//                 width: 200,
//                 color: Colors.grey,
//                 child: _image != null
//                     ? Image.file(_image!, fit: BoxFit.cover)
//                     : Icon(Icons.add_photo_alternate, color: Colors.white),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             GestureDetector(
//               onTap: getAdditionalImageFromGallery,
//               child: Container(
//                 height: 200,
//                 width: 200,
//                 color: Colors.grey,
//                 child: _additionalImage != null
//                     ? Image.file(_additionalImage!, fit: BoxFit.cover)
//                     : Icon(Icons.add_photo_alternate, color: Colors.white),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: savePatientDetails,
//               child: Text('Save'),
//             ),
//             SizedBox(height: 16.0),
//             isConnected
//                 ? Text('Data saved successfully',
//                     style: TextStyle(color: Colors.green))
//                 : Container(),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  File? _image;
  File? _additionalImage;
  final picker = ImagePicker();

  TextEditingController _patientNameController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _totalBillController = TextEditingController();

  final String baseUrl =
      'http://localhost:3000'; // Replace with the IP address or hostname of your backend server

  bool isConnected = false;
  bool _formInvalid = false;

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future getAdditionalImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _additionalImage = File(pickedFile.path);
      }
    });
  }

  Future<void> savePatientDetails() async {
    // Get the input values from text fields
    String patientName = _patientNameController.text;
    String mobileNumber = _mobileNumberController.text;
    String date = _dateController.text;
    String description = _descriptionController.text;
    double totalBill = double.tryParse(_totalBillController.text) ?? 0.0;

    // Validate the form fields
    if (patientName.isEmpty ||
        mobileNumber.isEmpty ||
        date.isEmpty ||
        description.isEmpty ||
        totalBill == 0.0) {
      setState(() {
        _formInvalid = true;
      });
      return;
    }

    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/projects'));
    request.fields['name'] = patientName;
    request.fields['mobileNumber'] = mobileNumber;
    request.fields['date'] = date;
    request.fields['description'] = description;
    request.fields['totalBill'] = totalBill.toString();

    // Attach the image files
    if (_image != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image1', _image!.path));
    }
    if (_additionalImage != null) {
      request.files.add(
          await http.MultipartFile.fromPath('image2', _additionalImage!.path));
    } else {
      request.fields['image2'] =
          ''; // Set an empty string if no additional image is selected
    }

    try {
      // Send the request and get the response
      var response = await request.send();

      // Check the response status
      if (response.statusCode == 201) {
        // Success, data saved
        // Show a success message or navigate to a success page
        print('Data saved successfully');
        setState(() {
          isConnected = true;
        });
      } else {
        // Error saving data
        // Show an error message or handle the error
        print('Failed to save data');
      }
    } catch (error) {
      // Error sending the request
      // Show an error message or handle the error
      print('Error sending request: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Patient Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _patientNameController,
              decoration: InputDecoration(
                labelText: 'Patient Name *',
                suffixIcon: Icon(
                  Icons.star,
                  color: Colors.red,
                  size: 8.0,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _mobileNumberController,
              decoration: InputDecoration(
                labelText: 'Mobile Number *',
                suffixIcon: Icon(
                  Icons.star,
                  color: Colors.red,
                  size: 8.0,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Date *',
                hintText: 'Enter date in the format xx-yy-zzzz',
                suffixIcon: Icon(
                  Icons.star,
                  color: Colors.red,
                  size: 8.0,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description *',
                hintText: 'Write NA if nothing to write',
                suffixIcon: Icon(
                  Icons.star,
                  color: Colors.red,
                  size: 8.0,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _totalBillController,
              decoration: InputDecoration(
                labelText: 'Total Bill *',
                hintText: 'Enter 00 if nothing to write in totalBill',
                suffixIcon: Icon(
                  Icons.star,
                  color: Colors.red,
                  size: 8.0,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: getImageFromGallery,
              child: Container(
                height: 200,
                width: 200,
                color: Colors.grey,
                child: _image != null
                    ? Image.file(_image!, fit: BoxFit.cover)
                    : Icon(Icons.add_photo_alternate, color: Colors.white),
              ),
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: getAdditionalImageFromGallery,
              child: Container(
                height: 200,
                width: 200,
                color: Colors.grey,
                child: _additionalImage != null
                    ? Image.file(_additionalImage!, fit: BoxFit.cover)
                    : Icon(Icons.add_photo_alternate, color: Colors.white),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: savePatientDetails,
              child: Text('Save'),
            ),
            SizedBox(height: 16.0),
            _formInvalid
                ? Text(
                    'Please fill in all required fields',
                    style: TextStyle(color: Colors.red),
                  )
                : Container(),
            SizedBox(height: 16.0),
            isConnected
                ? Text('Data saved successfully',
                    style: TextStyle(color: Colors.green))
                : Container(),
          ],
        ),
      ),
    );
  }
}
