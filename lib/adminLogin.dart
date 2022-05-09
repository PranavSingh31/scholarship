import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:portal/login.dart';

import 'firebase_options.dart';

var email = TextEditingController();
var pass = TextEditingController();
var _hidden = true;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.loaderOverlay.show();
    startService();
    email.text = '';
    pass.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Center(child: Text('Thapar Scholarship Portal - Admin Mode')),
      ),
      backgroundColor: Colors.grey,
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .4,
          height: MediaQuery.of(context).size.height * .45,
          child: Card(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(padding: EdgeInsets.all(20)),
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 32.0,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(20)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .2,
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: email,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        hintText: 'Enter Email-Id',
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(8)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .2,
                    child: TextField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: pass,
                      obscureText: _hidden,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Enter Password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              if (_hidden == true) {
                                _hidden = false;
                              } else {
                                _hidden = true;
                              }
                            });
                          },
                          icon: Icon(_hidden == true
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(8)),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _hidden = true;
                      });
                      context.loaderOverlay.show();
                      authValidate();
                    },
                    child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 20.0),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> startService() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/dashboard', (route) => false);
    } else {
      context.loaderOverlay.hide();
    }
  }

  Future<void> authValidate() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: pass.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      pass.text = '';
      if (e.code == 'user-not-found') {
        //print('No user found for that email.');
        showAlert('No User Found');
      } else if (e.code == 'wrong-password') {
        //print('Wrong password provided for that user.');
        showAlert('Invalid EmailID/Password\nTry Again');
      } else if (e.code == 'invalid-email') {
        //print('Invalid Email Entered');
        showAlert('Enter valid EmailID');
      } else if (e.code == 'network-request-failed') {
        //print('Internet not connected');
        showAlert('Please Check Internet Connection');
      } else {
        print(e.code);
        showAlert('System Error\nTry Again Later');
      }
      return;
    }
    admincheck();
    print('Login Complete');
    Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
  }

  void admincheck() {
    var Admin;
    try {
      final docRef = FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser?.email);
      docRef.get().then((DocumentSnapshot doc) {
        Admin = doc['isAdmin'];
      });
    } catch (e) {
      print(e);
      return;
    }
    if (Admin == true) {
      Navigator.pushNamedAndRemoveUntil(context, 'adminDash', (route) => false);
    } else {
      showAlert('Not an Admin-ID\n Try with different account');
      FirebaseAuth.instance.signOut();
    }
  }

  void showAlert(var message) {
    var alert = AlertDialog(
      title: const Text('Error!'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return alert;
        });
    context.loaderOverlay.hide();
  }
}
