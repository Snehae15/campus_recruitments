import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CompanySettingsPage extends StatefulWidget {
  const CompanySettingsPage({Key? key}) : super(key: key);

  @override
  _CompanySettingsPageState createState() => _CompanySettingsPageState();
}

class _CompanySettingsPageState extends State<CompanySettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String companyname = '';
  String companyProfileImageUrl = '';
  bool isNotificationEnabled = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _loadCompanyInfo();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _updateStateEverySecond();
    });
  }

  Future<void> _loadCompanyInfo() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        var snapshot = await FirebaseFirestore.instance
            .collection('companies')
            .doc(user.uid)
            .get();

        if (snapshot.exists) {
          if (mounted) {
            setState(() {
              companyname = snapshot['companyname'];
              companyProfileImageUrl =
                  snapshot['profileImageUrl']; // Load profile image URL
            });
          }
        }
      }
    } catch (e) {
      print("Error loading company information: $e");
    }
  }

  void _toggleNotification(bool value) {
    if (mounted) {
      setState(() {
        isNotificationEnabled = value;
      });
    }
  }

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      Navigator.pushReplacementNamed(context, '/onboardingScreen');
    } catch (e) {
      print("Error during logout: $e");
    }
  }

  void _navigateToFeedbackPage() {
    Navigator.pushNamed(context, '/feedbackpage');
  }

  void _updateStateEverySecond() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Account',
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                leading: companyProfileImageUrl.isNotEmpty
                    ? Image.network(
                        companyProfileImageUrl) // Display company profile image if available
                    : const CircleAvatar(
                        backgroundImage: AssetImage('assets/person.png'),
                      ),
                title: Text(companyname),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'GENERAL',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.notifications_none_outlined,
              color: Colors.purpleAccent,
            ),
            title: const Text('Notification'),
            trailing: Switch(
              value: isNotificationEnabled,
              onChanged: _toggleNotification,
              activeColor: Colors.purpleAccent,
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.purpleAccent,
            ),
            title: const Text('Logout'),
            trailing: const Icon(
              Icons.arrow_forward,
              color: Colors.grey,
              size: 30,
            ),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
