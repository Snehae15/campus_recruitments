import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RegisteredCompanies extends StatelessWidget {
  const RegisteredCompanies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registered Companies'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('companies').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Extract data from snapshot
          final List<DocumentSnapshot> companies = snapshot.data!.docs;

          return SingleChildScrollView(
            child: Column(
              children: companies.map((document) {
                // Extract fields from the company document with null checks
                final companyName = document['companyname'] as String? ?? 'N/A';
                final companyAddress = document['address'] as String? ?? 'N/A';
                final companyEmail = document['email'] as String? ?? 'N/A';

                return Card(
                  margin: EdgeInsets.all(16.0),
                  child: ListTile(
                    leading: Icon(Icons.account_circle,
                        size: 40.0), // Add user icon here
                    title: Text(
                      companyName,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.0),
                        Text('Address: $companyAddress',
                            style: TextStyle(fontSize: 16.0)),
                        Text('Email: $companyEmail',
                            style: TextStyle(fontSize: 16.0)),
                      ],
                    ),
                    // You can add more actions if needed
                    // For example, navigate to a detailed view of the company
                    onTap: () {
                      // Implement navigation to the detailed view
                    },
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
