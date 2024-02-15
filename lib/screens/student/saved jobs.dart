// import 'package:flutter/material.dart';

// class SavedJobs extends StatefulWidget {
//   const SavedJobs({
//     Key? key,
//     required this.savedJobs,
//   }) : super(key: key);

//   final List<Map<String, String>> savedJobs;

//   @override
//   _SavedJobsState createState() => _SavedJobsState();
// }

// class _SavedJobsState extends State<SavedJobs> {
//   @override
//   Widget build(BuildContext context) {
//     // Replace 'loggedInUsername' and 'loggedInUserEmail' with actual user information
//     List<Map<String, String>> userSavedJobs = widget.savedJobs
//         .where((job) =>
//             job['username'] == 'loggedInUsername' &&
//             job['email'] == 'loggedInUserEmail')
//         .toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Saved Job Details"),
//       ),
//       body: Column(
//         children: userSavedJobs.map(buildCard).toList(),
//       ),
//     );
//   }

//   Widget buildCard(Map<String, String> jobDetails) {
//     String companyname = jobDetails['companyname'] ?? '';
//     String companyaddress = jobDetails['address'] ?? '';
//     String jobTitle = jobDetails['jobTitle'] ?? '';
//     String field = jobDetails['field'] ?? '';
//     String schedule = jobDetails['schedule'] ?? '';
//     String jobType = jobDetails['jobType'] ?? '';

//     return Card(
//       margin: const EdgeInsets.all(10),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // First Row: Image, Company Name, Place, Save Button
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Image
//                 Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     image: const DecorationImage(
//                       image: AssetImage(
//                           'assets/google.png'), // Replace with your image path
//                       fit: BoxFit.cover,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 const Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         companyname,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                         ),
//                       ),
//                       Text(address),
//                     ],
//                   ),
//                 ),

//                 // Save Button as Icon
//                 IconButton(
//                   onPressed: () {
//                     // Handle save button tap
//                   },
//                   icon: const Icon(Icons.save),
//                 ),
//               ],
//             ),

//             // Second Row: Job Heading, Post, Time Schedule, Job Type
//             const SizedBox(height: 10), // Add some space between rows
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Job Heading
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         jobTitle,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(
//                           height:
//                               5), // Add some space between heading and other details

//                       // Other details with dotted pointers
//                       Row(
//                         children: [
//                           Text(field),
//                           const SizedBox(width: 5),
//                           const Icon(Icons.fiber_manual_record, size: 8),
//                           const SizedBox(width: 5),
//                           Text(schedule),
//                           const SizedBox(width: 5),
//                           const Icon(Icons.fiber_manual_record, size: 8),
//                           const SizedBox(width: 5),
//                           Text(jobType),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
