import 'dart:io';

import 'package:campus_recruitment/screens/student/appliedjobs.dart';
import 'package:campus_recruitment/screens/student/bottom%20navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class JobApplication extends StatefulWidget {
  final String userId;
  final String address;
  final String jobTitle;
  final String companyname;

  const JobApplication({
    Key? key,
    required this.userId,
    required this.address,
    required this.jobTitle,
    required this.companyname,
  }) : super(key: key);

  @override
  State<JobApplication> createState() => _JobApplicationState();
}

class _JobApplicationState extends State<JobApplication> {
  File? resumeFile;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String dob = '';
  String phone = '';
  String gender = '';
  String qualification = '';
  String certificate = '';
  String skills = '';

  Future<void> pickResume() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        resumeFile = File(result.files.single.path ?? "");
      });
    }
  }

  Future<void> submitApplication() async {
    String jobName = widget.jobTitle;
    String jobAddress = widget.address;
    String jobTitle = 'Selected Job Title';
    String username = fullNameController.text;
    String email = emailController.text;

    if (resumeFile != null) {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('resumes/${DateTime.now().toString()}');
      await storageReference.putFile(resumeFile!);
      String resumeUrl = await storageReference.getDownloadURL();
      // Store resumeUrl in Firestore or use it as needed
    }

    var firestore = FirebaseFirestore.instance;
    await firestore.collection('applied_jobs').add({
      'userId': widget.userId,
      'jobName': jobName,
      'jobAddress': jobAddress,
      'jobTitle': jobTitle,
      'companyname': widget.companyname,
      'username': username,
      'email': email,
      'dob': dob,
      'phone': phone,
      'gender': gender,
      'qualification': qualification,
      'certificate': certificate,
      'skills': skills,
      // Add other fields as needed
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Congratulations',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Your application has been submitted successfully'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavigation(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Home'),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppliedJobs(),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue),
                  ),
                  child: const Text('See Application'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 15, right: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Apply for Job',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: const Text('Full Name'),
              ),
              TextFormField(
                controller: fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Enter your full name',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Email'),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Enter your email',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 350,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: ListTile(
                          title: Text(
                            resumeFile != null
                                ? resumeFile!.path
                                    .split('/')
                                    .last // Extract only the file name
                                : 'No file selected',
                          ),
                          trailing: ElevatedButton.icon(
                            onPressed: pickResume,
                            icon: const Icon(Icons.attach_file),
                            label: const Text('Upload File'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: const Text('Description'),
              ),
              TextFormField(
                controller: descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Enter your description',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.0),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submitApplication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
