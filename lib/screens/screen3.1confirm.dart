import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screen3home.dart'; 

class Screen3_1Confirm extends StatelessWidget {
  final String requestId;

  const Screen3_1Confirm({
    Key? key,
    required this.requestId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Donation'),
      ),
      body: FutureBuilder(
        future: _fetchHospitalName(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${snapshot.data}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      _confirmDonation(context);
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(320, 60),
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w700,
                      ),
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFFCE2C6B),
                    ),
                    child: Text('I want to donate', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<String> _fetchHospitalName() async {
    DatabaseReference hospreqRef = FirebaseDatabase.instance.ref().child('hospreq').child(requestId);
    DataSnapshot snapshot = await hospreqRef.get();
    if (snapshot.exists) {
      return snapshot.child('hospitalName').value.toString();
    } else {
      return 'Unknown Hospital';
    }
  }

  void _confirmDonation(BuildContext context) async {
    DatabaseReference hospreqRef = FirebaseDatabase.instance.ref().child('hospreq').child(requestId);
    DatabaseReference accreqRef = FirebaseDatabase.instance.ref().child('accreq').child(requestId);

    // Fetch the request details
    DataSnapshot snapshot = await hospreqRef.get();

    if (snapshot.exists) {
      Map<dynamic, dynamic> requestData = snapshot.value as Map;

      // Fetch donor details from 'donors' node
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DatabaseReference donorRef = FirebaseDatabase.instance.ref().child('donors').child(userId);
      DataSnapshot donorSnapshot = await donorRef.get();

      if (donorSnapshot.exists) {
        String donorName = donorSnapshot.child('name').value.toString();
        requestData['donorUid'] = userId;
        requestData['donorName'] = donorName;
      } else {
        // If donor details are not found, set donor name to 'Unknown'
        requestData['donorUid'] = userId;
        requestData['donorName'] = "Unknown";
      }

      // Add date and time of donation
      DateTime now = DateTime.now();
      requestData['donationDateTime'] = now.toIso8601String();

      // Move to accreq
      await accreqRef.set(requestData);

      // Delete from hospreq
      await hospreqRef.remove();

      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 100),
                  SizedBox(height: 20),
                  Text(
                    "Confirmed",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      );

      // Automatically exit after 2 seconds
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop(); // Pop the dialog
        Navigator.pushReplacement(  // Navigate to Screen3Home
          context,
          MaterialPageRoute(builder: (context) => Screen3Home()),
        );
      });
    }
  }
}
