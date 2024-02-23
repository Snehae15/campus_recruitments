import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StudentViewResume extends StatelessWidget {
  final String userId;

  const StudentViewResume({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Resume'),
      ),
      body: FutureBuilder<String?>(
        future: _getResumeUrl(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          var resumeUrl = snapshot.data;
          if (resumeUrl == null || resumeUrl.isEmpty) {
            return Center(child: Text('No resume URL found for this user.'));
          }
          return WebView(
            initialUrl: resumeUrl,
            javascriptMode: JavascriptMode.unrestricted,
          );
        },
      ),
    );
  }

  Future<String?> _getResumeUrl() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedUserId = prefs.getString('userId');
      if (storedUserId == null) {
        print('User ID not found in SharedPreferences.');
        return null;
      }

      print('User ID: $storedUserId');

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(storedUserId)
          .get();

      print('User data: ${userSnapshot.data()}');

      if (userSnapshot.exists && userSnapshot.id == storedUserId) {
        var resumeUrl = userSnapshot.get('resumeUrl') as String?;
        print('Resume URL: $resumeUrl');
        return resumeUrl;
      } else {
        print('User document not found or ID mismatch.');
        return null;
      }
    } catch (e) {
      print('Error fetching resume URL: $e');
      return null;
    }
  }
}
