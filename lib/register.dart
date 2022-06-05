
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'firebase_options.dart';

var email = TextEditingController();
var pass = TextEditingController();
var pass1 = TextEditingController();
var _hidden = true;
var _hidden1 =true;

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  void initState() {
    super.initState();
    context.loaderOverlay.show();
    startService();
    email.text = '';
    pass1.text = '';
    pass.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        const Center(child: Text('Thapar Scholarship Portal - Admin Mode')),
        actions:<Widget> [
          TextButton(
            onPressed: (){
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Student',style: TextStyle(color: Colors.white),),),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 224, 202, 2),
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
                    'Register',
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .2,
                    child: TextField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: pass1,
                      obscureText: _hidden1,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Enter Password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              if (_hidden1 == true) {
                                _hidden1 = false;
                              } else {
                                _hidden1 = true;
                              }
                            });
                          },
                          icon: Icon(_hidden1 == true
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
                        _hidden1 = true;
                      });
                      context.loaderOverlay.show();
                      authRegister();
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

  Future<void> authRegister() async {
    if (email.text.trim().split('@')[1] == 'thapar.edu'){
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
          if (kDebugMode) {
            print(e.code);
          }
          showAlert('System Error\nTry Again Later');
        }
        pass.text = '';
        return;
      }
    }else{
      showAlert('Only Thapar id allowed(@thapar.edu)!');
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
