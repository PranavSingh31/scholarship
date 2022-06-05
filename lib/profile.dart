import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:portal/var.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: <Widget>[
          TextButton(
            onPressed: (){
              context.loaderOverlay.show();
              FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Logout',style: TextStyle(color: Colors.white),),),
          ),
          TextButton(
            onPressed: (){
              context.loaderOverlay.show();
              FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
            },
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Home',style: TextStyle(color: Colors.white),),),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width*.7,
                child: Card(
                  child: Column(
                    children: [
                      showInfo('Name', firstName.text +' '+middleName.text + ' '+lastName.text),
                      const Padding(padding: EdgeInsets.all(4)),
                      showInfo('Email-ID', FirebaseAuth.instance.currentUser?.email.toString()),
                      const Padding(padding: EdgeInsets.all(4)),
                      showInfo('Roll Number', rollNumber.text),
                      const Padding(padding: EdgeInsets.all(4)),
                      showInfo('Mobile Number', personalMobile.text),
                      const Padding(padding: EdgeInsets.all(4)),
                      showInfo("Mother's Name", motherName.text),
                      const Padding(padding: EdgeInsets.all(4)),
                      showInfo("Mother's Mobile Number", motherMobile.text),
                      const Padding(padding: EdgeInsets.all(4)),
                      showInfo("Father's Name", fatherName.text),
                      const Padding(padding: EdgeInsets.all(4)),
                      showInfo("Father's Mobile Number", fatherMobile.text),
                      const Padding(padding: EdgeInsets.all(4)),
                      showInfo("Aadhar Number", aadhaar.text),
                      const Padding(padding: EdgeInsets.all(4)),
                      showInfo('Account Number', accountNumber.text),
                      const Padding(padding: EdgeInsets.all(4)),
                      showInfo('Bank IFCS Code', bankIFSC.text),
                      const Padding(padding: EdgeInsets.all(4)),
                      showInfo('Year Selected', selectedYear),
                      const Padding(padding: EdgeInsets.all(4)),
                      const Padding(padding: EdgeInsets.all(4)),
                      const Padding(padding: EdgeInsets.all(4)),
                      showInfo('Note', 'The information can be updated while filling an application!'),
                      const Padding(padding: EdgeInsets.all(4)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget showInfo(var title, var value){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(title + ':- '+value),
        ),
      ],
    );
  }
}
