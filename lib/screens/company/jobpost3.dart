import 'package:campus_recruitment/screens/company/jobpost4.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Jobpost3 extends StatefulWidget {
  final String documentId;

  const Jobpost3({required this.documentId, super.key});

  @override
  State<Jobpost3> createState() => _Jobpost3State();
}

class _Jobpost3State extends State<Jobpost3> {
  TextEditingController currentSalaryController = TextEditingController();
  TextEditingController expectedSalaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Column(
            children: [
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 70, right: 210),
                    child: Text(
                      "Current Salary",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: currentSalaryController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "Enter Amount",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15, right: 210),
                    child: Text(
                      "Expected Salary",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: expectedSalaryController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "Enter Amount",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 100),
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('jobs')
                          .doc(widget.documentId)
                          .update({
                        'currentSalary': currentSalaryController.text,
                        'expectedSalary': expectedSalaryController.text,
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Jobpost4(jobDocumentId: widget.documentId),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.purple,
                    ),
                    child: const Text('Next'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
