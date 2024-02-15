import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({Key? key}) : super(key: key);

  @override
  _PersonalDetailsState createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  late User _user;
  late String _name;
  late String _lastName;
  late String _field;
  late String _email;
  late String _dob;
  late String _phoneNumber;
  late String _gender;
  late String _experience;
  late String _qualification;
  late String _skills;
  bool _isLoading = true;

  Future<void> _getUserDetails() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        if (snapshot.exists) {
          Map<String, dynamic>? data = snapshot.data();

          if (data != null) {
            setState(() {
              _user = user;
              _name = data['name'] ?? '';
              _lastName = data['lastName'] ?? '';
              _email = data['email'] ?? '';
              _field = data['field'] ?? '';
              _dob = data['dob'] ?? '';
              _phoneNumber = data['phoneNumber'] ?? '';
              _gender = data['gender'] ?? '';
              _experience = data['experience'] ?? '';
              _qualification = data['qualification'] ?? '';
              _skills = data['skills'] ?? '';
              _isLoading = false; // set loading to false once data is fetched
            });
          } else {
            print('User data not found in the snapshot');
          }
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  OutlineInputBorder _customBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(width: 0.5, color: Colors.black),
    );
  }

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.08,
                      ),
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  readOnly: true,
                                  initialValue: _name,
                                  onChanged: (value) {
                                    setState(() {
                                      _name = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'First Name',
                                    border: _customBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  readOnly: true,
                                  initialValue: _lastName,
                                  onChanged: (value) {
                                    setState(() {
                                      _lastName = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Last Name',
                                    border: _customBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            readOnly: true,
                            initialValue: _email,
                            onChanged: (value) {
                              setState(() {
                                _email = value;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: _customBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            readOnly: true,
                            initialValue: _field,
                            onChanged: (value) {
                              setState(() {
                                _field = value;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Field',
                              border: _customBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            readOnly: true,
                            initialValue: _dob,
                            onChanged: (value) {
                              setState(() {
                                _dob = value;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Date of Birth',
                              border: _customBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            readOnly: true,
                            initialValue: _phoneNumber,
                            onChanged: (value) {
                              setState(() {
                                _phoneNumber = value;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              border: _customBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            readOnly: true,
                            initialValue: _gender,
                            onChanged: (value) {
                              setState(() {
                                _gender = value;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Gender',
                              border: _customBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            readOnly: true,
                            initialValue: _experience,
                            onChanged: (value) {
                              setState(() {
                                _experience = value;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Experience',
                              border: _customBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            readOnly: true,
                            initialValue: _qualification,
                            onChanged: (value) {
                              setState(() {
                                _qualification = value;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Qualification',
                              border: _customBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  readOnly: true,
                                  initialValue: _skills,
                                  onChanged: (value) {
                                    setState(() {
                                      _skills = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Skills',
                                    border: _customBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
