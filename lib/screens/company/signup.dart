import 'package:campus_recruitment/screens/company/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CompanyRegister extends StatefulWidget {
  const CompanyRegister({Key? key}) : super(key: key);

  @override
  State<CompanyRegister> createState() => _CompanyRegisterState();
}

class _CompanyRegisterState extends State<CompanyRegister> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  var companyNameController = TextEditingController();
  var companyemailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var addressController = TextEditingController();
  List<bool> isCheckedList = [false];

  String? _validateCompanyName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter company name.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter email address.';
    } else if (!RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
        .hasMatch(value)) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter password.';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm password.';
    } else if (value != passwordController.text) {
      return 'Passwords do not match.';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter company address.';
    }
    return null;
  }

  Future<void> _createAccount(BuildContext context) async {
    try {
      if (_formKey.currentState!.validate() && isCheckedList[0]) {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: companyemailController.text,
          password: passwordController.text,
        );

        if (userCredential.user != null) {
          String companyId = userCredential.user!.uid; // Use uid as companyId

          await userCredential.user!.sendEmailVerification();

          await _firestore
              .collection('companies')
              .doc(companyId) // Use companyId
              .set({
            'companyId': companyId, // Store companyId in Firestore
            'companyname': companyNameController.text,
            'email': companyemailController.text,
            'address': addressController.text,
          });

          print("Company registration successful");

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Company registration successful. Verification email sent.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      print("Error in registration: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error in registration: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: companyNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Company Name',
                    ),
                    validator: _validateCompanyName,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: companyemailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Email',
                    ),
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Password',
                    ),
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: confirmPasswordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Confirm Password',
                    ),
                    validator: _validateConfirmPassword,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Company Address',
                    ),
                    maxLines: 5,
                    validator: _validateAddress,
                  ),
                  const SizedBox(height: 16.0),
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Row(
                      children: [
                        Text('I agree to the '),
                        Text(
                          'Terms & service policy',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue,
                            decorationThickness: 2,
                          ),
                        ),
                      ],
                    ),
                    value: isCheckedList[0],
                    onChanged: (bool? value) {
                      setState(() {
                        isCheckedList[0] = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          isCheckedList[0]) {
                        _createAccount(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Create Account'),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? '),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CompanyLogIn(),
                            ),
                          );
                        },
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue,
                            decorationThickness: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
