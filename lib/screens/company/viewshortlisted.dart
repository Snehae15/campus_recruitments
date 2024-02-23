import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShortListCandidates extends StatefulWidget {
  const ShortListCandidates({Key? key}) : super(key: key);

  @override
  State<ShortListCandidates> createState() => _ShortListCandidatesState();
}

class _ShortListCandidatesState extends State<ShortListCandidates> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shortlisted Candidates'),
        backgroundColor: Colors.purple, // Set app bar background color
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('applied_jobs')
            .where('status', isEqualTo: 'shortlisted')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("Error loading data"),
            );
          }

          var shortlistedCandidates = snapshot.data!.docs;

          if (shortlistedCandidates.isEmpty) {
            return const Center(
              child: Text("No shortlisted candidates found."),
            );
          }

          return ListView.builder(
            itemCount: shortlistedCandidates.length,
            itemBuilder: (context, index) {
              var username = shortlistedCandidates[index]['username'];
              var jobName = shortlistedCandidates[index]['jobName'];

              return Card(
                elevation: 3, // Add elevation for a card-like effect
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    username,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(jobName),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
