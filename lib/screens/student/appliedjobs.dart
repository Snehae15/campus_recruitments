import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppliedJobs extends StatefulWidget {
  const AppliedJobs({Key? key}) : super(key: key);

  @override
  State<AppliedJobs> createState() => _AppliedJobsState();
}

class _AppliedJobsState extends State<AppliedJobs> {
  late String userId;

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
  }

  void getCurrentUserId() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    } else {
      print('User not signed in');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(userId);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text(
                  "All Jobs",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              Tab(
                child: Text(
                  "Shotlisted/Completed",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
            indicatorColor: Colors.blue,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 5,
          ),
          title: const Text(
            "Applied Jobs",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: TabBarView(
          children: [
            // All Jobs Tab
            FutureBuilder(
              future: getPendingJobs(userId),
              builder: (context, snapshot) {
                print('///////////FUTURE BUILDER : $userId///////////');
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.data == null) {
                  return const Center(child: Text('No data available'));
                } else {
                  List<QueryDocumentSnapshot> appliedJobs =
                      snapshot.data as List<QueryDocumentSnapshot>;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: ListView.builder(
                      itemCount: appliedJobs.length,
                      itemBuilder: (context, index) {
                        var jobData =
                            appliedJobs[index].data() as Map<String, dynamic>;
                        return Card(
                          child: ListTile(
                            title: Text(jobData['jobName']),
                            subtitle: Text(
                              'Company: ${jobData['companyname']}\nStatus: ${jobData['status']}',
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            // Completed Tab
            FutureBuilder(
              future: getCompletedJobs(userId),
              builder: (context, snapshot) {
                print('///////////FUTURE BUILDER : $userId///////////');
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.data == null) {
                  return const Center(child: Text('No data available'));
                } else {
                  List<QueryDocumentSnapshot> appliedJobs =
                      snapshot.data as List<QueryDocumentSnapshot>;

                  List<String> length = [];
                  for (var i in appliedJobs) {
                    if (i["status"] != "shortlisted") {
                      length.add(i["status"]);
                    }
                  }
                  print(length.length);

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: ListView.builder(
                      itemCount: length.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> dataa = {};
                        if (appliedJobs[index]["status"] != "shortlisted") {
                          dataa =
                              appliedJobs[index].data() as Map<String, dynamic>;
                        }

                        return Card(
                          child: ListTile(
                            title: dataa['jobName'] == null
                                ? Text("Job not found")
                                : Text(dataa['jobName']),
                            subtitle: Text(
                              'Company: ${dataa['companyname']}\nStatus: ${dataa['status']}',
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<List<QueryDocumentSnapshot>> getPendingJobs(String userId) async {
    print('//////////FETCHING JOBS///////////////////');
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await firestore
        .collection('applied_jobs')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'applied')
        .get();

    print('//////////FETCHING JOBS COMPLETED///////////////////');
    return querySnapshot.docs;
  }

  Future<List<QueryDocumentSnapshot>> getCompletedJobs(String userId) async {
    print('//////////FETCHING JOBS///////////////////');
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await firestore
        .collection('applied_jobs')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'shortlisted')
        .get();

    print('//////////FETCHING JOBS COMPLETED///////////////////');
    return querySnapshot.docs;
  }
}
