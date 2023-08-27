import 'package:flutter/material.dart';
import 'package:doctor_patient/login.dart';
import 'package:doctor_patient/doctor.dart';
import 'package:doctor_patient/patient.dart';
import 'package:doctor_patient/home.dart';
import 'package:doctor_patient/add.dart';
import 'package:doctor_patient/see.dart';
void main() {
  runApp(MaterialApp(
    initialRoute: 'login',
    debugShowCheckedModeBanner: false,
    routes: {
      'login': (context) => LoginPage(),
      'doctor': (context) => DoctorPage(),
      'patient': (context) => PatientPage(),
      'home': (context) => HomePage(),
      'add': (context) => AddPage(),
      'see': (context) => PatientsPage(),
    },
  ));
} 