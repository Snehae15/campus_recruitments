import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ViewResume extends StatefulWidget {
  final String userId;

  const ViewResume({Key? key, required this.userId}) : super(key: key);

  @override
  State<ViewResume> createState() => _ViewResumeState();
}

class _ViewResumeState extends State<ViewResume> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _userDataFuture;
  late String _resumeURL = '';

  @override
  void initState() {
    super.initState();
    _userDataFuture = _getUserData(widget.userId);
    _fetchResumeURL();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _getUserData(
      String userId) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
  }

  Future<void> _fetchResumeURL() async {
    try {
      final userDataSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();
      final userData = userDataSnapshot.data();
      if (userData != null) {
        final resumeImage = userData[
            'resumeImage']; // Assuming resumeImage field contains the image filename
        final ref =
            FirebaseStorage.instance.ref().child('resume_images/$resumeImage');
        final url = await ref.getDownloadURL();
        setState(() {
          _resumeURL = url;
        });
      }
    } catch (error) {
      print('Error fetching resume URL: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Resume'),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final userData = snapshot.data!.data();
            if (userData != null) {
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: ${userData['name']}',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'DOB: ${userData['dob']}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Phone Number: ${userData['phoneNumber']}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 10.0),
                      _resumeURL.isNotEmpty
                          ? Image.network(
                              _resumeURL) // Display the resume image
                          : Container(),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: Text('No resume data found for this user.'),
              );
            }
          } else {
            return Center(
              child: Text('No data available.'),
            );
          }
        },
      ),
    );
  }
}
