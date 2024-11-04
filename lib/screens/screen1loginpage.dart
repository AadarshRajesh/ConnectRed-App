import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'screen2register.dart';
import 'screen3home.dart';

class Screen1LoginPage extends StatelessWidget {
  // ignore: unused_field
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // ignore: unused_field
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Image.asset(
                "assets/bloodbag.png",
                fit: BoxFit.fill,
              ),
              SizedBox(height: 30),
              Text(
                'Your blood can \nsave lives',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 36,
                  fontFamily: 'SF Pro Display',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'The blood you donate gives someone\n another chance at life',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF717171),
                  fontSize: 12,
                  fontFamily: 'SF Pro Display',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Navigate to Screen2Register
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Screen2Register()),
                  );
                },
                child: Text('Become a donor'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFFCE2C6B),
                  fixedSize: Size(329, 60),
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontFamily: 'SF Pro Display',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return LoginDialog();
                    },
                  );
                },
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFFCE2C6B),
                  fixedSize: Size(329, 60),
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontFamily: 'SF Pro Display',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginDialog extends StatefulWidget {
  @override
  _LoginDialogState createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  String _emailErrorMessage = '';
  String _passwordErrorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text;

      if (!email.endsWith('@gmail.com')) {
        setState(() {
          _emailErrorMessage = 'Enter valid Gmail';
        });
        return;
      }

      final UserCredential authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = authResult.user;

      if (user != null) {
        final DatabaseReference userRef = _database.ref().child('donors').child(user.uid);
        final DataSnapshot snapshot = (await userRef.once()).snapshot;

        if (snapshot.value != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Screen3Home()),
          );
        }
      } else {
        setState(() {
          _passwordErrorMessage = 'Account not registered';
        });
      }
    } catch (e) {
      setState(() {
        _passwordErrorMessage = 'Password or Email incorrect';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Login"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: "Email",
              errorText: _emailErrorMessage.isNotEmpty ? _emailErrorMessage : null,
            ),
            onChanged: (_) {
              setState(() {
                _emailErrorMessage = '';
              });
            },
          ),
          SizedBox(height: 10),
          TextField(
            controller: _passwordController,
            obscureText: !_passwordVisible,
            decoration: InputDecoration(
              labelText: "Password",
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
              errorText: _passwordErrorMessage.isNotEmpty ? _passwordErrorMessage : null,
            ),
            onChanged: (_) {
              setState(() {
                _passwordErrorMessage = '';
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            setState(() {
              _emailErrorMessage = '';
              _passwordErrorMessage = '';
            });
          },
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _signInWithEmailAndPassword,
          child: Text("Login"),
        ),
      ],
    );
  }
}
