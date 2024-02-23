import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  // final String companyId; // Add companyId as a parameter
  const NotificationPage({
    Key? key,
  }) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late Stream<QuerySnapshot> _applicationsStream;

  @override
  void initState() {
    super.initState();
    _applicationsStream =
        FirebaseFirestore.instance.collection('applied_jobs').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1),
              child: const Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: Text(
                  'Notifications',
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
            const SizedBox(height: 20),
            StreamBuilder<QuerySnapshot>(
              stream: _applicationsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final documents = snapshot.data!.docs;
                  return Column(
                    children: documents.map((doc) {
                      final username = doc['username'];
                      final jobId = doc['jobId'];
                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('jobs')
                            .doc(jobId)
                            .get(),
                        builder: (context, jobSnapshot) {
                          if (jobSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (jobSnapshot.hasError) {
                            return Text('Error: ${jobSnapshot.error}');
                          } else {
                            final jobName = jobSnapshot.data!['jobName'];
                            return Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: Icon(
                                      Icons.wallet,
                                      color: Colors.purpleAccent,
                                    ),
                                  ),
                                  title: Text('$username applied to $jobName'),
                                  // subtitle:
                                  // Text('Company: ${widget.companyId}'),
                                ),
                              ),
                            );
                          }
                        },
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
