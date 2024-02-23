import 'package:campus_recruitment/screens/student/job%20application.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JobDetails {
  final String companyname;
  final String jobTitle;
  final String jobType;
  final String position;
  final String category;
  final String expectedSkills;
  final String description;
  final String currentSalary;
  final bool immediatStart;
  final List<String> workDays;

  JobDetails({
    required this.companyname,
    required this.jobTitle,
    required this.jobType,
    required this.position,
    required this.category,
    required this.expectedSkills,
    required this.description,
    required this.currentSalary,
    required this.immediatStart,
    required this.workDays,
  });
}

class JObview1 extends StatefulWidget {
  final JobDetails jobDetails;

  const JObview1({required this.jobDetails, Key? key}) : super(key: key);

  @override
  State<JObview1> createState() => _JObview1State();
}

class _JObview1State extends State<JObview1> {
  late String description;
  late String expectedSkills;
  late String about;

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  void fetchDataFromFirebase() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('jobs')
          .where('companyname', isEqualTo: widget.jobDetails.companyname)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs[0].data() as Map<String, dynamic>;

        // Ensure that the required fields exist in the document
        if (data.containsKey('description') &&
            data.containsKey('expectedSkills')) {
          setState(() {
            description = data['description'] ?? 'N/A';

            // Check the type of 'expectedSkills' and convert if necessary
            if (data['expectedSkills'] is List<dynamic>) {
              expectedSkills = (data['expectedSkills'] as List<dynamic>)
                  .cast<String>()
                  .join(', ');
            } else {
              expectedSkills = data['expectedSkills'] ?? 'N/A';
            }
          });
        } else {
          print('Required fields do not exist in the document');
        }
      } else {
        print('Document does not exist');
      }
    } catch (e, stackTrace) {
      print('Error fetching data: $e\n$stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Stack(
                children: [
                  // Background Image
                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: const Image(
                      image: AssetImage('assets/bg.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Company Logo
                  const Padding(
                    padding: EdgeInsets.only(left: 150, top: 100),
                    child: CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/Company-Vectors .png'),
                      radius: 45,
                    ),
                  ),
                  // Back Button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context); // Navigate back
                      },
                      icon: const Icon(
                        Icons.keyboard_backspace_rounded,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              Container(
                height: 110,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        widget.jobDetails.jobTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        widget.jobDetails.companyname,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const TabBar(
                        isScrollable: true, // Set this property to true
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Tab(text: 'Description'),
                          Tab(text: 'Company'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Description Tab

                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Job Description: $description',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Skills: $expectedSkills',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => JobApplication(
                                              address:
                                                  'pass_logged_user_address_here',
                                              jobTitle:
                                                  widget.jobDetails.jobTitle,
                                              companyname:
                                                  widget.jobDetails.companyname,
                                              jobId: '',
                                            )),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  onPrimary: Colors.white,
                                ),
                                child: const Text('Apply Job'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Company Tab
                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection(
                              'companies') // Use 'companies' collection instead of 'jobs'
                          .doc(widget.jobDetails.companyname)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }

                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.data == null || !snapshot.data!.exists) {
                          return Text('Document does not exist');
                        }

                        var companyData =
                            snapshot.data!.data() as Map<String, dynamic>;

                        setState(() {
                          about = companyData['about'] ?? 'N/A';
                        });

                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  'About: $about',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
