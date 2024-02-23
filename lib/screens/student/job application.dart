import 'dart:io';

import 'package:campus_recruitment/screens/student/appliedjobs.dart';
import 'package:campus_recruitment/screens/student/bottom%20navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobApplication extends StatefulWidget {
  final String address;
  final String jobTitle;
  final String companyname;

  const JobApplication({
    Key? key,
    required this.address,
    required this.jobTitle,
    required this.companyname,
    required String jobId,
  }) : super(key: key);

  @override
  State<JobApplication> createState() => _JobApplicationState();
}

class _JobApplicationState extends State<JobApplication> {
  File? resumeFile;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool applied = false; // Flag to track whether application has been submitted

  @override
  void initState() {
    super.initState();
    fetchUserId();
  }

  Future<void> fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
    });
  }

  String userId = '';

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
    String description = descriptionController.text;

    if (username.isEmpty || email.isEmpty || resumeFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill all required fields.'),
      ));
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter a valid email address.'),
      ));
      return;
    }

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please provide a description.'),
      ));
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Submitting Application...'),
            ],
          ),
        );
      },
    );

    if (resumeFile != null) {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('resumes/${DateTime.now().toString()}');
      await storageReference.putFile(resumeFile!);
      String resumeUrl = await storageReference.getDownloadURL();
    }

    var firestore = FirebaseFirestore.instance;
    await firestore.collection('applied_jobs').add({
      'userId': userId,
      'jobName': jobName,
      'jobAddress': jobAddress,
      'jobTitle': jobTitle,
      'companyname': widget.companyname,
      'username': username,
      'email': email,
      'description': description,
      'status': 'applied',
    });

    Navigator.pop(context);
    setState(() {
      applied = true;
    });

    // Show success dialog
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
                        builder: (context) => StudentBottomNavigation(),
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
                                ? resumeFile!.path.split('/').last
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
                  onPressed: applied ? null : submitApplication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: applied ? Colors.grey : Colors.blue,
                  ),
                  child: Text(applied ? 'Applied' : 'Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
