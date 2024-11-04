import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:connect_red/screens/screen3home.dart';
import 'package:connect_red/screens/screen6donations.dart';
import 'package:connect_red/screens/screen1loginpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connect Red',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Screen7Profile(),
    );
  }
}

class Screen7Profile extends StatefulWidget {
  @override
  _Screen7ProfileState createState() => _Screen7ProfileState();
}

class _Screen7ProfileState extends State<Screen7Profile> {
  File? _selectedImage;

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back navigation
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0), // Hide the app bar
          child: Container(),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 70),
                child: Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 34,
                    fontFamily: 'SF Pro Display',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ProfileContent(_selectedImage, _selectImage),
              SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Hey lifesaver"),
                          content: Text("Are you sure you want to logout?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                FirebaseAuth.instance.signOut();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Screen1LoginPage(),
                                  ),
                                );
                              },
                              child: Text("Logout"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'SF Pro Display',
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: MyBottomNavigationBar(),
      ),
    );
  }
}

class ProfileContent extends StatefulWidget {
  final File? selectedImage;
  final Function selectImage;

  ProfileContent(this.selectedImage, this.selectImage);

  @override
  _ProfileContentState createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  String? _name;
  String? _address;
  String? _bloodGroup;
  String? _donorId;
  bool _showDonorId = false;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final dbRef = FirebaseDatabase.instance.ref('donors/${user.uid}');
      final snapshot = await dbRef.get();
      if (mounted) { // Check if the widget is still mounted
        setState(() {
          _name = snapshot.child('name').value.toString();
          _address = snapshot.child('address').value.toString();
          _bloodGroup = snapshot.child('bloodGroup').value.toString();
          _donorId = user.uid;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfilePicture(widget.selectedImage, widget.selectImage),
            SizedBox(height: 20),
            Text(
              _name ?? '',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'SF Pro Display',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              _address ?? '',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'SF Pro Display',
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Blood Type: $_bloodGroup',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'SF Pro Display',
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showDonorId = !_showDonorId;
                });
              },
              child: Text(
                'Donor ID',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'SF Pro Display',
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 10),
            if (_showDonorId)
              Text(
                '$_donorId',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'SF Pro Display',
                ),
              ),
            SizedBox(height: 10),
            Container(
              width: 318,
              height: 81,
              decoration: BoxDecoration(
                color: Color(0xFFFFE763),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  'Reward Points = 500',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePicture extends StatelessWidget {
  final File? selectedImage;
  final Function selectImage;

  ProfilePicture(this.selectedImage, this.selectImage);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 145,
          height: 145,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
          ),
          child: selectedImage != null
              ? ClipOval(child: Image.file(selectedImage!))
              : Center(
                  child: Icon(
                    Icons.person,
                    size: 100,
                    color: Colors.grey[600],
                  ),
                ),
        ),
        Positioned(
          right: 10,
          bottom: 10,
          child: GestureDetector(
            onTap: () {
              selectImage();
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: Icon(
                Icons.edit,
                size: 20, // Smaller size for the edit icon
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MyBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_hospital), // Hospital icon for Donations
          label: 'Donations',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      selectedItemColor: Color.fromARGB(255, 206, 44, 107),
      currentIndex: 2, // current index of the bottom nav bar (Profile)
      onTap: (int index) {
        // Handle navigation
        switch (index) {
          case 0:
            // Navigate to home screen with zero transition duration
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => Screen3Home(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
            break;
          case 1:
            // Navigate to donations screen with zero transition duration
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => Screen6Donations(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
            break;
          case 2:
            // Stay on profile screen
            break;
        }
      },
    );
  }
}
