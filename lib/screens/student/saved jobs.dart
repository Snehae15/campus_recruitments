import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedJobs extends StatefulWidget {
  const SavedJobs({
    Key? key,
    required this.savedJobs,
    required String userid,
  }) : super(key: key);

  final List<Map<String, String>> savedJobs;

  @override
  _SavedJobsState createState() => _SavedJobsState();
}

class _SavedJobsState extends State<SavedJobs> {
  List<Map<String, dynamic>> savedJobsList = [];

  @override
  void initState() {
    super.initState();
    getSavedJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Job Details"),
      ),
      body: savedJobsList.isEmpty
          ? const Center(
              child: Text('No Saved jobs'),
            )
          : ListView.builder(
              itemCount: savedJobsList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> jobData = savedJobsList[index];
                return ListTile(
                  title: Text(jobData['jobTitle']),
                  subtitle: Text(jobData['companyname']),
                );
              },
            ),
    );
  }

  Future<void> getSavedJobs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (userId == null) {
      print('User ID not found in SharedPreferences');
      return;
    }
    try {
      QuerySnapshot savedJobsSnapshot = await FirebaseFirestore.instance
          .collection('saved_jobs')
          .where('userId', isEqualTo: userId)
          .get();

      for (var savedJobDoc in savedJobsSnapshot.docs) {
        String jobId = savedJobDoc.id;
        DocumentSnapshot jobSnapshot = await FirebaseFirestore.instance
            .collection('jobs')
            .doc(jobId)
            .get();
        if (jobSnapshot.exists) {
          Map<String, dynamic> jobData = {
            'jobTitle': jobSnapshot['jobTitle'],
            'companyname': jobSnapshot['companyname'],
          };

          if (!savedJobsList.any((job) =>
              job['jobTitle'] == jobData['jobTitle'] &&
              job['companyname'] == jobData['companyname'])) {
            savedJobsList.add(jobData);
          }
        } else {
          print('Job with ID $jobId not found');
        }
      }
      setState(() {});
    } catch (e) {
      print('Error fetching saved jobs: $e');
    }
  }
}
