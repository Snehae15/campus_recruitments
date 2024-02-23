import 'package:campus_recruitment/screens/company/Viewresume.dart';
import 'package:campus_recruitment/screens/company/notificationpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  TextEditingController searchController = TextEditingController();
  List<QueryDocumentSnapshot> appliedJobs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.purpleAccent,
                      size: 30,
                    ),
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: StudentSearchDelegate(appliedJobs),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.notifications_none_outlined,
                      color: Colors.purpleAccent,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 130),
            child: Text(
              'Recent Applicants',
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 30),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('applied_jobs')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  print("Error: ${snapshot.error}");
                  return const Center(
                    child: Text("Error loading data"),
                  );
                }

                appliedJobs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: appliedJobs.length,
                  itemBuilder: (context, index) {
                    var username = appliedJobs[index]['username'];
                    var jobName = appliedJobs[index]['jobName'];
                    var userId = appliedJobs[index]['userId'];
                    print('$userId');
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey),
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.purpleAccent,
                            child: Icon(Icons.person,
                                size: 30, color: Colors.white),
                          ),
                          title: Text(username),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(jobName),
                            ],
                          ),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CompanyViewStudentProfile(
                                  username: username,
                                  jobName: jobName,
                                  userId: userId,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class StudentSearchDelegate extends SearchDelegate<String> {
  final List<QueryDocumentSnapshot> appliedJobs;

  StudentSearchDelegate(this.appliedJobs);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, "");
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = appliedJobs
        .where((appliedJob) =>
            appliedJob['jobName'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index]['jobName']),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CompanyViewStudentProfile(
                  username: suggestionList[index]['username'],
                  jobName: suggestionList[index]['jobName'],
                  userId: suggestionList[index]['userId'],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class CompanyViewStudentProfile extends StatefulWidget {
  final String username;
  final String jobName;
  final String userId;

  const CompanyViewStudentProfile({
    Key? key,
    required this.username,
    required this.jobName,
    required this.userId,
  }) : super(key: key);

  @override
  State<CompanyViewStudentProfile> createState() =>
      _CompanyViewStudentProfileState();
}

class _CompanyViewStudentProfileState extends State<CompanyViewStudentProfile> {
  var dob = TextEditingController();
  var phoneNumber = TextEditingController();
  var age = TextEditingController();
  var gender = TextEditingController();
  var experience = TextEditingController();
  var qualification = TextEditingController();
  var certification = TextEditingController();
  var skills = TextEditingController();
  var username = '';
  var field = '';
  var email = '';
  var userId = '';

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;

        setState(() {
          username = userData['username'] ?? '';
          field = userData['field'] ?? '';
          email = userData['email'] ?? '';
          dob.text = userData['dob'] ?? '';
          phoneNumber.text = userData['phoneNumber'] ?? '';
          gender.text = userData['gender'] ?? '';
          experience.text = userData['experience'] ?? '';
          qualification.text = userData['qualification'] ?? '';
          certification.text = userData['certification'] ?? '';
          skills.text = userData['skills'] ?? '';
        });
      } else {
        print('No data found for userId: ${widget.userId}');
      }
    } catch (error) {
      print('Error fetching user details: $error');
    }
  }

  Future<void> _shortListCandidate() async {
    try {
      await FirebaseFirestore.instance
          .collection('applied_jobs')
          .where('username', isEqualTo: widget.username)
          .where('jobName', isEqualTo: widget.jobName)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          querySnapshot.docs.first.reference.update({'status': 'shortlisted'});
          showToast('Candidate shortlisted');
        }
      });
    } catch (error) {
      print('Error shortlisting candidate: $error');
    }
  }

  Future<void> _rejectCandidate() async {
    try {
      await FirebaseFirestore.instance
          .collection('applied_jobs')
          .where('username', isEqualTo: widget.username)
          .where('jobName', isEqualTo: widget.jobName)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          querySnapshot.docs.first.reference.update({'status': 'rejected'});
          showToast('Candidate rejected');
        }
      });
    } catch (error) {
      print('Error rejecting candidate: $error');
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: ListView(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: SizedBox(
                    height: 100,
                    width: 300,
                    child: Image.asset('assets/person.png'),
                  ),
                ),
                Text(
                  username,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 30,
                  ),
                ),
                Text(
                  field,
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  email,
                  style: TextStyle(color: Colors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text('DOB'),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    readOnly: true,
                    controller: dob,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Date of Birth',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text('Phone Number'),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    readOnly: true,
                    controller: phoneNumber,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Phone No',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text('Gender'),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    readOnly: true,
                    controller: gender,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Gender',
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text('Experience'),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                readOnly: true,
                controller: experience,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Experience',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text('Qualification'),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                readOnly: true,
                controller: qualification,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Qualification',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text('Skill'),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                readOnly: true,
                controller: skills,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Skills',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ViewResume(userId: widget.userId)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('View Resume'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    onPressed: _shortListCandidate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('ShortList'),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed: _rejectCandidate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Reject'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
