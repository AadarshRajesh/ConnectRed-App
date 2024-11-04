import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'screen3home.dart'; // Importing Screen3Home.dart

class Screen2Register extends StatefulWidget {
  @override
  _Screen2RegisterState createState() => _Screen2RegisterState();
}

class _Screen2RegisterState extends State<Screen2Register> {
  TextEditingController _dobController = TextEditingController();
  TextEditingController _lastDonationController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _bodyWeightController = TextEditingController();

  bool? hasDonatedBefore; // Updated to nullable
  bool? dateOfLastDonationSelected = false; // Added to track if the date of last donation is selected
  DateTime? selectedDate;
  DateTime? selectedDOB;
  double? bodyWeight;
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  String _password = ''; // Store the entered password
  bool _passwordVisible = false; // To toggle password visibility

  // List of blood groups
  List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  // Selected blood group
  String? selectedBloodGroup;

  // Function to show date picker for date of last donation
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateOfLastDonationSelected = true; // Update the state when a date is selected
        _lastDonationController.text =
            '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  // Function to show date picker for date of birth
  Future<void> _selectDOB(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1959),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDOB = picked;
        _dobController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  // Function to show the underweight popup
  void _showUnderweightPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Icon(
              Icons.cancel,
              color: Colors.red,
              size: 48,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              Text(
                'You are underweight',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Function to show the age criteria not met popup
  void _showAgeCriteriaNotMetPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Icon(
              Icons.cancel,
              color: Colors.red,
              size: 48,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              Text(
                'Age criteria not met',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Function to check if email is already registered
  Future<bool> isEmailRegistered(String email) async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      // ignore: deprecated_member_use
      final List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(email);
      // If any sign-in methods are returned, then the email is already registered.
      return signInMethods.isNotEmpty;
    } catch (e) {
      print('Error checking email registration: $e');
      return false; // Return false in case of any errors
    }
  }

  // Function to fetch Google profile picture URL
  Future<String?> _fetchGoogleProfilePicUrl() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      return user?.photoURL;
    } catch (e) {
      print("Error fetching profile pic URL: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 34,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter your email address',
                      labelText: 'Email Address',
                      suffixIcon: FutureBuilder<bool>(
                        future: isEmailRegistered(_emailController.text),
                        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator(); // Show loading indicator while waiting for the result
                          } else if (snapshot.hasError) {
                            return Icon(Icons.error, color: Colors.red); // Show error icon if there's an error
                          } else if (snapshot.data == true && _emailController.text.endsWith('@gmail.com')) {
                            return Icon(Icons.check, color: Colors.green); // Show green check icon if email ends with @gmail.com
                          } else {
                            return SizedBox.shrink(); // Hide icon if email does not end with @gmail.com
                          }
                        },
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _emailController.text = value;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email address';
                      }
                      if (!value.endsWith('@gmail.com')) {
                        return 'Please enter a valid Gmail address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your full name',
                      labelText: 'Full Name',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      hintText: 'Enter your address',
                      labelText: 'Address',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _mobileNumberController,
                    decoration: InputDecoration(
                      hintText: 'Enter your mobile number',
                      labelText: 'Mobile Number',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your mobile number';
                      }
                      if (value.length != 10) {
                        return 'Mobile number must be 10 digits';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      _selectDOB(context);
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _dobController,
                        decoration: InputDecoration(
                          hintText: 'Select date of birth',
                          labelText: 'Date of Birth',
                          suffixIcon: Icon(Icons.calendar_today), // Calendar icon
                        ),
                        validator: (value) {
                          if (selectedDOB == null) {
                            return 'Please select your date of birth';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      hintText: 'Select blood group',
                      labelText: 'Blood Group',
                    ),
                    value: selectedBloodGroup,
                    items: bloodGroups.map((String bloodGroup) {
                      return DropdownMenuItem<String>(
                        value: bloodGroup,
                        child: Text(bloodGroup),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedBloodGroup = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select your blood group';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _bodyWeightController,
                    decoration: InputDecoration(
                      hintText: 'Enter your body weight',
                      labelText: 'Body Weight',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        bodyWeight = double.tryParse(value);
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your body weight';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Have you donated before? ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                hasDonatedBefore = true;
                                dateOfLastDonationSelected = true; // Update the state when "Yes" is selected
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: hasDonatedBefore == true ? Color(0xFFCE2C6B) : null,
                              foregroundColor: Color.fromARGB(255, 207, 207, 207), // Change color if "Yes" is selected
                            ),
                            child: Text('Yes'),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                hasDonatedBefore = false;
                                dateOfLastDonationSelected = null; // Reset the state when "No" is selected
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: hasDonatedBefore == false ? Color(0xFFCE2C6B) : null,
                              foregroundColor: Color.fromARGB(255, 207, 207, 207), // Change color if "No" is selected
                            ),
                            child: Text('No'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Conditionally render the date of last donation field
                  if (hasDonatedBefore == true)
                    GestureDetector(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _lastDonationController,
                          decoration: InputDecoration(
                            hintText: 'Select last donation date',
                            labelText: 'Last Donation Date',
                            suffixIcon: Icon(Icons.calendar_today), // Calendar icon
                          ),
                          validator: (value) {
                            if (dateOfLastDonationSelected == null || !dateOfLastDonationSelected!) {
                              return 'Please select date of last donation';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (bodyWeight != null && bodyWeight! < 50) {
                          _showUnderweightPopup(context);
                          return;
                        }

                        if (selectedDOB != null) {
                          final age = DateTime.now().year - selectedDOB!.year;
                          if (age < 18) {
                            _showAgeCriteriaNotMetPopup(context);
                            return;
                          }
                        }

                        try {
                          final FirebaseAuth _auth = FirebaseAuth.instance;
                          final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                            email: _emailController.text,
                            password: _password,
                          );

                          // After the user account is created, store the additional user information in Firebase Realtime Database
                          final FirebaseDatabase _database = FirebaseDatabase.instance;
                          String? profilePicUrl = await _fetchGoogleProfilePicUrl();
                          await _database.ref().child('donors').child(userCredential.user!.uid).set({
                            'email': _emailController.text,
                            'name': _nameController.text,
                            'address': _addressController.text,
                            'mobileNumber': _mobileNumberController.text,
                            'dateOfBirth': _dobController.text,
                            'bloodGroup': selectedBloodGroup,
                            'bodyWeight': _bodyWeightController.text,
                            'lastDonationDate': hasDonatedBefore == true ? _lastDonationController.text : null, // Only set this if the user has donated before
                            'profilePicUrl': profilePicUrl,
                            // Add other fields as needed
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Screen3Home()),
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('The password provided is too weak.'),
                              ),
                            );
                          } else if (e.code == 'email-already-in-use') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('The account already exists for that email.'),
                              ),
                            );
                          }
                        } catch (e) {
                          print(e);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('All fields are mandatory'),
                          ),
                        );
                      }
                    },
                    child: Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(329, 60),
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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
