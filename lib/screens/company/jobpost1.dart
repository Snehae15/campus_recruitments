import 'package:campus_recruitment/screens/company/jobpost2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Jobpost1 extends StatefulWidget {
  const Jobpost1({Key? key}) : super(key: key);

  @override
  _Jobpost1State createState() => _Jobpost1State();
}

class _Jobpost1State extends State<Jobpost1> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? dropdownValue = "Select";
  var positions = ["Select", "Writer", "Developer", "Tester", "Programmer"];

  String? dropdownValues = "Select";
  var categories = [
    "Select",
    "Full time",
    "Part time",
    "Internship",
    "Freelance"
  ];

  TextEditingController jobTitleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 60.0, left: 20, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 70.0, right: 210),
                  child: Text(
                    "Job Description",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 70.0, right: 210),
                  child: Text(
                    "Job Title",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: jobTitleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: "Enter Job title",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter job title';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Position",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: Icon(Icons.keyboard_arrow_down_sharp),
                  value: dropdownValue,
                  items: positions
                      .map((String position) => DropdownMenuItem<String>(
                            value: position,
                            child: Text(position),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value == "Select") {
                      return 'Please select a position';
                    }
                    return null;
                  },
                ),
                Text(
                  "Category",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: Icon(Icons.keyboard_arrow_down_sharp),
                  value: dropdownValues,
                  items: categories
                      .map((String category) => DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValues = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value == "Select") {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Text(
                  "Description",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: ("Add description"),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter job description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 100),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      User? user = _auth.currentUser;
                      if (user != null) {
                        String jobId = _firestore
                            .collection('jobs')
                            .doc()
                            .id; // Generate a unique jobId
                        DocumentSnapshot companySnapshot = await _firestore
                            .collection('companies')
                            .doc(user.uid)
                            .get();

                        if (companySnapshot.exists) {
                          Map<String, dynamic>? companyData =
                              companySnapshot.data() as Map<String, dynamic>?;
                          if (companyData != null) {
                            String companyname =
                                companyData['companyname'] ?? 'Unknown Company';
                            String address =
                                companyData['address'] ?? 'Unknown Company';
                            String email =
                                companyData['email'] ?? 'Unknown Company';
                            String contact =
                                companyData['contact'] ?? 'Unknown Company';
                            String website =
                                companyData['website'] ?? 'Unknown Company';

                            // Prepare job data
                            Map<String, dynamic> jobData = {
                              'jobId': jobId, // Add jobId
                              'companyId': user.uid,
                              'companyname': companyname,
                              'address': address,
                              'email': email,
                              'contact': contact,
                              'website': website,
                              'jobTitle': jobTitleController.text,
                              'position': dropdownValue,
                              'category': dropdownValues,
                              'description': descriptionController.text,
                              // Add more fields as needed
                            };

                            await _firestore.collection('jobs').doc(jobId).set(
                                jobData); // Store job data with jobId in Firestore

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Jobpost2(jobId),
                              ),
                            );
                          } else {
                            print(
                                'Company details not found for user ID: ${user.uid}');
                          }
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.purple,
                  ),
                  child: Text('Next'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
