import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart'; // for date formatting
import 'package:connect_red/screens/screen3home.dart';
import 'package:connect_red/screens/screen7profile.dart';

class Screen6Donations extends StatelessWidget {
  Future<bool> _onWillPop() async {
    // Return false to cancel the back navigation
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0), // Hide the app bar
          child: Container(),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 70),
              child: Text(
                'My Donations',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 34,
                  fontFamily: 'SF Pro Display',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 20), // Adding space below "My Donations"
            Expanded(
              child: ConfirmationsList(),
            ),
          ],
        ),
        bottomNavigationBar: MyBottomNavigationBar(),
      ),
    );
  }
}

class ConfirmationsList extends StatefulWidget {
  @override
  _ConfirmationsListState createState() => _ConfirmationsListState();
}

class _ConfirmationsListState extends State<ConfirmationsList> {
  late DatabaseReference _databaseReference;
  late String _currentUid;

  @override
  void initState() {
    super.initState();
    _currentUid = FirebaseAuth.instance.currentUser!.uid;
    _databaseReference = FirebaseDatabase.instance.ref('confirm');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DatabaseEvent>(
      future: _databaseReference.once(),
      builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
          return Center(child: Text('No recent donations.'));
        }

        // Extract data from snapshot
        DataSnapshot data = snapshot.data!.snapshot;
        Map<dynamic, dynamic> confirmations = data.value as Map<dynamic, dynamic>;

        // Filter confirmations for the current user
        List<Widget> tiles = [];
        confirmations.forEach((key, value) {
          if (value['donorUid'] == _currentUid) {
            tiles.add(ConfirmationTile(
              hospitalName: value['hospitalName'],
              donationDateTime: value['donationDateTime'],
            ));
          }
        });

        if (tiles.isEmpty) {
          return Center(
            child: Text(
              'No recent donations',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'SF Pro Display',
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }

        return ListView(
          children: tiles,
        );
      },
    );
  }
}

class ConfirmationTile extends StatelessWidget {
  final String hospitalName;
  final String donationDateTime;

  ConfirmationTile({required this.hospitalName, required this.donationDateTime});

  @override
  Widget build(BuildContext context) {
    // Format donation date/time
    DateTime dateTime = DateTime.parse(donationDateTime);
    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text('Hospital: $hospitalName'),
        subtitle: Text('Donation Date/Time: $formattedDateTime'),
      ),
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
      currentIndex: 1, // current index of the bottom nav bar (Donations)
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
            // Stay on donations screen
            break;
          case 2:
            // Navigate to profile screen with zero transition duration
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => Screen7Profile(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
            break;
        }
      },
    );
  }
}
