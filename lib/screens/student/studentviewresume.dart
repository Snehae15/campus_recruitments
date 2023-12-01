import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resume Downloader',
      home: StudentViewResume(resumeUrl: 'path/to/your/resume.pdf'),
    );
  }
}

class StudentViewResume extends StatelessWidget {
  final String resumeUrl;

  const StudentViewResume({Key? key, required this.resumeUrl})
      : super(key: key);

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _downloadResume() async {
    try {
      String downloadUrl = await _getDownloadUrl(resumeUrl);
      print('Download URL: $downloadUrl');
      _launchURL(downloadUrl);
    } catch (e) {
      print('Error downloading resume: $e');
      // Handle error as needed
    }
  }

  Future<String> _getDownloadUrl(String resumeUrl) async {
    try {
      return await FirebaseStorage.instance.ref(resumeUrl).getDownloadURL();
    } catch (e) {
      print('Error getting download URL: $e');
      throw Exception('Failed to get download URL');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download Resume'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _downloadResume();
          },
          child: const Text('Download Resume'),
        ),
      ),
    );
  }
}
