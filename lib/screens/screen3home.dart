import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:connect_red/screens/screen7profile.dart';
import 'package:connect_red/screens/screen6donations.dart';
import 'package:connect_red/screens/screen3.1confirm.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: Screen3Home(),
    );
  }
}

class Screen3Home extends StatefulWidget {
  @override
  _Screen3HomeState createState() => _Screen3HomeState();
}

class _Screen3HomeState extends State<Screen3Home> {
  String? _bloodGroup;

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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),

              // Blood Group and Donation Count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Blood Group Container
                  Flexible(
                    child: Container(
                      width: double.infinity,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Color(0xFFE6EFFF),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Your blood group is',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            _bloodGroup ?? '!',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 20),

                  // Donation Count Container
                  Flexible(
                    child: Container(
                      width: double.infinity,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Color(0xFFE6EFFF),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Times you donated\nblood this year',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'x',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Requests Section
              Text(
                'Requests',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              Expanded(
                child: RequestList(
                  onUpdateBloodGroup: (bloodGroup) {
                    setState(() {
                      _bloodGroup = bloodGroup;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
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
          currentIndex: 0, // current index of the bottom nav bar
          onTap: (int index) {
            // Handle navigation
            switch (index) {
              case 0:
                // Stay on home screen
                break;
              case 1:
                // Navigate to donations screen with transition
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
                // Navigate to profile screen with transition
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
        ),
      ),
    );
  }
}

class RequestList extends StatefulWidget {
  final Function(String?) onUpdateBloodGroup;

  RequestList({required this.onUpdateBloodGroup});

  @override
  _RequestListState createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  late DatabaseReference _databaseReference;
  String? _bloodGroup;
  List<DataSnapshot> _requestList = []; // Initialize the request list

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref().child('donors').child(FirebaseAuth.instance.currentUser!.uid);
    _databaseReference.once().then((DatabaseEvent event) {
      String? bloodGroup = event.snapshot.child('bloodGroup').value.toString();
      setState(() {
        _bloodGroup = bloodGroup;
      });
      widget.onUpdateBloodGroup(bloodGroup);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseDatabase.instance.ref().child('hospreq').onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasData && snapshot.data!.snapshot.exists) {
          _requestList = snapshot.data!.snapshot.children.toList();
        } else {
          _requestList = [];
        }

        if (_requestList.isEmpty) {
          return Center(
            child: Text(
              'No new requests',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'SF Pro Display',
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }

        return FirebaseAnimatedList(
          query: FirebaseDatabase.instance.ref().child('hospreq'),
          itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
            Map<dynamic, dynamic> hospreq = snapshot.value as Map;
            String requestId = snapshot.key ?? ''; // Get the request ID
            String bloodGroup = hospreq['bloodGroup'] ?? '';

            // Skip this request if the blood groups don't match
            if (_bloodGroup != null && bloodGroup != _bloodGroup) {
              return Container();
            }

            return RequestTile(
              hospitalName: hospreq['hospitalName'],
              bloodGroup: bloodGroup,
              urgentLevel: hospreq['urgencyLevel'],
              requestId: requestId,  // Pass the requestId
            );
          },
        );
      },
    );
  }
}

class RequestTile extends StatelessWidget {
  final String hospitalName;
  final String bloodGroup;
  final String urgentLevel;
  final String requestId;  // Add this line

  const RequestTile({
    Key? key,
    required this.hospitalName,
    required this.bloodGroup,
    required this.urgentLevel,
    required this.requestId,  // Add this line
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text('Hospital: $hospitalName'),
        subtitle: Text('Blood Group: $bloodGroup\nNeed: $urgentLevel'),
        trailing: IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {
            // Navigate to confirmation screen with requestId
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Screen3_1Confirm(
                  requestId: requestId,  // Pass the requestId
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
