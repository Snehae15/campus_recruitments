import 'package:campus_recruitment/screens/student/job application.dart';
import 'package:campus_recruitment/screens/student/notificaiton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({Key? key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 20),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/person.png'),
                        radius: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Welcome',
                          style: TextStyle(
                            fontSize: constraints.maxWidth > 600 ? 30 : 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 115.0),
                        child: IconButton(
                          icon: const Icon(
                            Icons.notification_add_outlined,
                            color: Colors.blue,
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
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 15),
                  child: Container(
                    height: 50,
                    width: constraints.maxWidth > 550
                        ? null
                        : constraints.maxWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0XFFD3D3D3),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.search),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) {
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                hintText: 'Search',
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recommendation',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: constraints.maxWidth > 600 ? 25 : 20,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Text(
                          'View more',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: constraints.maxWidth > 600 ? 20 : 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: constraints.maxWidth > 250 ? 210 : 250,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('jobs')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      var jobs = snapshot.data!.docs;
                      var filteredJobs = jobs.where((job) {
                        String title = job['jobTitle'].toString().toLowerCase();
                        String searchValue =
                            _searchController.text.toLowerCase().trim();
                        return title.contains(searchValue);
                      }).toList();

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filteredJobs.length,
                        itemBuilder: (context, index) {
                          var job = filteredJobs[index].data()
                              as Map<String, dynamic>;

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 5,
                              child: Container(
                                height: constraints.maxWidth > 500
                                    ? 180
                                    : constraints.maxWidth * 0.5,
                                width: constraints.maxWidth > 600
                                    ? 180
                                    : constraints.maxWidth * 0.7,
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: CircleAvatar(
                                            backgroundImage: AssetImage(
                                                'assets/Company-Vectors .png'),
                                            maxRadius: 30,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 20),
                                          child: Column(
                                            children: [
                                              Text(
                                                job['companyname'] ?? 'Unknown',
                                                style: TextStyle(
                                                  fontSize:
                                                      constraints.maxWidth > 600
                                                          ? 25
                                                          : 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(job['address'] ?? 'Unknown'),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  job['jobTitle'] ?? 'Unknown',
                                                  style: TextStyle(
                                                    fontSize:
                                                        constraints.maxWidth >
                                                                600
                                                            ? 20
                                                            : 16,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 50),
                                          child: GestureDetector(
                                            onTap: () async {
                                              // Handle saving job
                                            },
                                            child: Icon(Icons.confirmation_num),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Text(
                                              job['position'] ?? 'Unknown'),
                                        ),
                                        Text(
                                          '•',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(job['category'] ?? 'Unknown'),
                                        Text(
                                          '•',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(job['jobType'] ?? 'Unknown'),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 18.0),
                                      child: TextButton(
                                        onPressed: () async {
                                          String loggedInUserId =
                                              'yourLoggedInUserIdVariable';

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  JobApplication(
                                                userId: loggedInUserId,
                                                jobTitle: job['jobTitle'],
                                                address: job['address'],
                                                companyname: job['companyname'],
                                              ),
                                            ),
                                          );
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          primary: Colors.white,
                                        ),
                                        child: const Text('Apply Now'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Events',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: constraints.maxWidth > 600 ? 30 : 25,
                        ),
                      ),
                      Text(
                        'View more',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: constraints.maxWidth > 600 ? 20 : 15,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: constraints.maxWidth > 600 ? 230 : 280,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('events')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      var events = snapshot.data!.docs;

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          var event =
                              events[index].data() as Map<String, dynamic>;

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 5,
                              child: Container(
                                height: constraints.maxWidth > 300
                                    ? 100
                                    : constraints.maxWidth * 0.2,
                                width: constraints.maxWidth > 500
                                    ? 250
                                    : constraints.maxWidth * 0.7,
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        Image.asset(
                                          'assets/events.jpg',
                                          height: 150,
                                          width: double.infinity,
                                          fit: BoxFit.fill,
                                        ),
                                        Positioned(
                                          top: 8,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Event Date: ${event['eventDate']}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Event Name: ${event['eventName']}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Event Time: ${event['eventTime']}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Place: ${event['eventLocation']}',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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
        },
      ),
    );
  }
}
