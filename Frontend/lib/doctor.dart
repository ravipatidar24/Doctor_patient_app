// import 'package:flutter/material.dart';
// import 'package:doctor_patient/home.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class DoctorPage extends StatefulWidget {
//   @override
//   _DoctorPageState createState() => _DoctorPageState();
// }

// class _DoctorPageState extends State<DoctorPage> {
//   final TextEditingController mobileNoController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   String errorMessage = '';

//   Future<void> _login() async {
//     final String apiUrl = 'http://172.22.12.212:3000/checkPassword'; // Replace with your backend API endpoint

//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'mobileno': mobileNoController.text,
//         'password': passwordController.text,
//       }),
//     );

//     final data = jsonDecode(response.body);

//     if (response.statusCode == 200 && data['message'] == 'Password found in the database') {
//       // Password is correct, navigate to the next page
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => HomePage(),
//         ),
//       );
//     } else {
//       // Password is incorrect, display error message
//       setState(() {
//         errorMessage = 'Incorrect mobile number or password. Please try again.';
//       });
//     }
//   }

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
//               _inputField(),
//               _errorMessage(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _header() {
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

//   Widget _inputField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         TextField(
//           controller: mobileNoController,
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
//         TextField(
//           controller: passwordController,
//           decoration: InputDecoration(
//             hintText: "Password",
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(18),
//               borderSide: BorderSide.none,
//             ),
//             fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
//             filled: true,
//             prefixIcon: Icon(Icons.person),
//           ),
//           obscureText: true,
//         ),
//         SizedBox(height: 10),
//         ElevatedButton(
//           onPressed: _login,
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

//   Widget _errorMessage() {
//     if (errorMessage.isEmpty) {
//       return SizedBox.shrink();
//     } else {
//       return Text(
//         errorMessage,
//         style: TextStyle(
//           color: Colors.red,
//           fontSize: 16,
//         ),
//       );
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:doctor_patient/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorPage extends StatefulWidget {
  @override
  _DoctorPageState createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // User is already logged in, navigate to the home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  }

  Future<void> _login() async {
    final String apiUrl =
        'http://localhost:3000/checkPassword'; // Replace with your backend API endpoint

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'mobileno': mobileNoController.text,
        'password': passwordController.text,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 &&
        data['message'] == 'Password found in the database') {
      // Password is correct, store login status and navigate to the home page
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      // Password is incorrect, display error message
      setState(() {
        errorMessage = 'Incorrect mobile number or password. Please try again.';
      });
    }
  }

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
              _inputField(),
              _errorMessage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
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

  Widget _inputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: mobileNoController,
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
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.lock),
          ),
          obscureText: true,
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _login,
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

  Widget _errorMessage() {
    if (errorMessage.isEmpty) {
      return SizedBox.shrink();
    } else {
      return Text(
        errorMessage,
        style: TextStyle(
          color: Colors.red,
          fontSize: 16,
        ),
      );
    }
  }
}
