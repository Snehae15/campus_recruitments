import 'package:campus_recruitment/screens/company/CompanyEdit Profile.dart';
import 'package:campus_recruitment/screens/company/CompanyShowProfile.dart';
import 'package:campus_recruitment/screens/company/auth_service.dart';
import 'package:campus_recruitment/screens/company/companyabout.dart';
import 'package:campus_recruitment/screens/company/notificationpage.dart';
import 'package:campus_recruitment/screens/company/viewshortlisted.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Company {
  final String companyname;
  final String email;

  Company({required this.companyname, required this.email});
}

class CompanyProfilePage extends StatefulWidget {
  const CompanyProfilePage({Key? key}) : super(key: key);

  @override
  _CompanyProfilePageState createState() => _CompanyProfilePageState();
}

class _CompanyProfilePageState extends State<CompanyProfilePage> {
  final AuthService _authService = AuthService();
  User? _user;
  late Company _company;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authService.authStateChanges.listen((User? user) {
      setState(() {
        _user = user;
        if (user != null) {
          _fetchCompanyDetails(user.uid);
        }
      });
    });
  }

  void _fetchCompanyDetails(String userId) async {
    try {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('companies')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        if (!mounted) return;
        setState(() {
          _company = Company(
            companyname: snapshot.get('companyname'),
            email: snapshot.get('email'),
          );
        });
      }
    } catch (e) {
      print('Error fetching company details: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Profile'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  children: [
                    // Display company profile image from Firebase Storage
                    if (_user != null)
                      FutureBuilder<String>(
                        future: _getCompanyProfileImageUrl(_user!.uid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              !snapshot.hasData) {
                            return CircularProgressIndicator();
                          }
                          return CircleAvatar(
                            radius: 80,
                            backgroundImage: NetworkImage(snapshot.data!),
                          );
                        },
                      ),
                    const SizedBox(height: 30),
                    if (_user != null)
                      Column(
                        children: [
                          Text(
                            _company.companyname ?? 'Company Name',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(_company.email ?? 'email'),
                        ],
                      )
                    else
                      const Text('Not logged in'),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CompanyShowProfile()),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.purple),
                          ),
                          child: const Text(
                            'Show Profile',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CompanyEditProfile()),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.purple),
                          ),
                          child: const Text(
                            'Edit Profile',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),

                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.notifications),
                        title: const Text('Notifications'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationPage()),
                          );
                        },
                      ),
                    ),

                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.info),
                        title: const Text('About'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CompanyAbout()),
                          );
                        },
                      ),
                    ),

                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.short_text),
                        title: const Text('Shortlist Candidate'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ShortListCandidates()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<String> _getCompanyProfileImageUrl(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('companies')
        .doc(userId)
        .get();
    if (snapshot.exists) {
      return snapshot.get('profileImageUrl');
    } else {
      return ''; // Return empty string if no profile image found
    }
  }
}
