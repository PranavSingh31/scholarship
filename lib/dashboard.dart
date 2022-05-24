import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:portal/var.dart';
import 'package:flutter/services.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.loaderOverlay.show();
    type = 0;
    userInfo();
  }

  @override
  Widget build(BuildContext context) {
    if (type == 3) {
      context.loaderOverlay.show();
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushNamedAndRemoveUntil(context, '/documents', (route) => false);
      });
    } else if (type == 0) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (kDebugMode) {
          print('Reload to set state');
        }
        setState(() {

        });
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
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
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              formOption(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> userInfo() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference userDetails = firestore.collection('user');
    userDetails
        .doc(FirebaseAuth.instance.currentUser?.email.toString())
        .get()
        .then((value) {
      if (value.data() != null) {
        if(value['uploadFiles']==true) {
          type = 1;
        }else{
          type = 3;
        }
      } else {
        type = 2;
      }
    });
    setState(() {
      type;
    });
  }

  Widget formOption() {
    if (type == 1) {
      //show application site....
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      context.loaderOverlay.hide();
      return const Text('Under Build.........');

    } else if (type == 2) {
      Navigator.pushNamedAndRemoveUntil(context, '/documents', (route) => false);
      context.loaderOverlay.hide();
      return noInfo();
    }else if(type == 3){
      context.loaderOverlay.hide();
      return noInfo();
    } else {
      return const Text('Loading......');
    }
  }

  Widget noInfo() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .7,
      child: Card(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(12)),
            const Text(
              'Personal Details',
              style: TextStyle(fontSize: 32),
            ),
            const Padding(padding: EdgeInsets.all(12)),
            const Padding(padding: EdgeInsets.all(12)),
            //First Name input
            SizedBox(
              width: MediaQuery.of(context).size.width * .5,
              child: TextField(
                enabled: edit,
                keyboardType: TextInputType.text,
                controller: firstName,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'First Name',
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(12)),
            //Middle Name Input
            SizedBox(
              width: MediaQuery.of(context).size.width * .5,
              child: TextField(
                enabled: edit,
                keyboardType: TextInputType.text,
                controller: middleName,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Middle Name',
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(12)),
            //Last Name Input
            SizedBox(
              width: MediaQuery.of(context).size.width * .5,
              child: TextField(
                enabled: edit,
                keyboardType: TextInputType.text,
                controller: lastName,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Last Name',
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(12)),
            //Aadhaar Number
            SizedBox(
              width: MediaQuery.of(context).size.width * .5,
              child: TextField(
                enabled: edit,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: aadhaar,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Aadhaar Number',
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(12)),
            //Thapar Roll Number
            SizedBox(
              width: MediaQuery.of(context).size.width * .5,
              child: TextField(
                enabled: edit,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: rollNumber,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Thapar Roll Number',
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(12)),
            //Mobile Number
            SizedBox(
              width: MediaQuery.of(context).size.width * .5,
              child: TextField(
                enabled: edit,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: personalMobile,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Personal Mobile Number',
                  prefixIcon: Padding(
                    child: Text(
                      '+91',
                      style: TextStyle(fontSize: 16),
                    ),
                    padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(12)),
            //Address Line 1
            SizedBox(
              width: MediaQuery.of(context).size.width * .5,
              child: TextField(
                enabled: edit,
                keyboardType: TextInputType.streetAddress,
                controller: addressLine1,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Address Line 1',
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(12)),
            //Address Line 2
            SizedBox(
              width: MediaQuery.of(context).size.width * .5,
              child: TextField(
                enabled: edit,
                keyboardType: TextInputType.streetAddress,
                controller: addressLine2,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Address Line 2',
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(12)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //City
                SizedBox(
                  width: MediaQuery.of(context).size.width * .25 - 10,
                  child: TextField(
                    enabled: edit,
                    keyboardType: TextInputType.streetAddress,
                    controller: city,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'City',
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(12)),
                //State
                SizedBox(
                  width: MediaQuery.of(context).size.width * .25 - 10,
                  child: TextField(
                    enabled: edit,
                    keyboardType: TextInputType.streetAddress,
                    controller: state,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'State',
                    ),
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(12)),
            //Mother's Details
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Mother's Name
                SizedBox(
                  width: MediaQuery.of(context).size.width * .25 - 10,
                  child: TextField(
                    enabled: edit,
                    keyboardType: TextInputType.name,
                    controller: motherName,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Mother's Name",
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(12)),
                //Mother's Occupation
                SizedBox(
                  width: MediaQuery.of(context).size.width * .25 - 10,
                  child: TextField(
                    enabled: edit,
                    keyboardType: TextInputType.text,
                    controller: motherOccupation,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Mother's Occupation",
                    ),
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(12)),
            //Father's Details
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Father's Name
                SizedBox(
                  width: MediaQuery.of(context).size.width * .25 - 10,
                  child: TextField(
                    enabled: edit,
                    keyboardType: TextInputType.name,
                    controller: fatherName,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Father's Name",
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(12)),
                //Father's Occupation
                SizedBox(
                  width: MediaQuery.of(context).size.width * .25 - 10,
                  child: TextField(
                    enabled: edit,
                    keyboardType: TextInputType.text,
                    controller: fatherOccupation,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Father's Occupation",
                    ),
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(12)),
            //Father's Details
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Father's Name
                SizedBox(
                  width: MediaQuery.of(context).size.width * .25 - 10,
                  child: TextField(
                    enabled: edit,
                    keyboardType: TextInputType.phone,
                    controller: fatherMobile,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Father's Mobile Number",
                      prefixIcon: Padding(
                        child: Text(
                          '+91',
                          style: TextStyle(fontSize: 16),
                        ),
                        padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
                      ),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(12)),
                //Father's Occupation
                SizedBox(
                  width: MediaQuery.of(context).size.width * .25 - 10,
                  child: TextField(
                    enabled: edit,
                    keyboardType: TextInputType.phone,
                    controller: motherMobile,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Mother's Mobile Number",
                      prefixIcon: Padding(
                        child: Text(
                          '+91',
                          style: TextStyle(fontSize: 16),
                        ),
                        padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(12)),
            //Bank Details-------------------------------------------------------------
            //Account Name
            SizedBox(
              width: MediaQuery.of(context).size.width * .5,
              child: TextField(
                enabled: edit,
                keyboardType: TextInputType.name,
                controller: accountName,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Bank Account Holder Name",
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(12)),
            //Account Number
            SizedBox(
              width: MediaQuery.of(context).size.width * .5,
              child: TextField(
                enabled: edit,
                keyboardType: TextInputType.number,
                controller: accountNumber,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Bank Account Number",
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(12)),
            //Bank IFSC Code
            SizedBox(
              width: MediaQuery.of(context).size.width * .5,
              child: TextField(
                enabled: edit,
                keyboardType: TextInputType.text,
                controller: bankIFSC,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Bank IFSC Code",
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(12)),
            //Income Value
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .2,
                  child: DropdownButton(
                    hint: const Text('Annual Income'),
                    value: selectedIncome,
                    onChanged: (newValue) {
                      setState(() {
                        selectedIncome = newValue;
                      });
                    },
                    items: incomeOptions.map((value) {
                      return DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      );
                    }).toList(),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(12)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .2,
                  child: DropdownButton(
                    hint: const Text('Year'),
                    value: selectedYear,
                    onChanged: (newValue) {
                      setState(() {
                        selectedYear = newValue;
                      });
                    },
                    items: yearOptions.map((value) {
                      return DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(12)),
            marks(),
            const Padding(padding: EdgeInsets.all(12)),
            SizedBox(
              width: MediaQuery.of(context).size.width * .2,
              child: DropdownButton(
                hint: const Text('Special Case Request'),
                value: selectedCase,
                onChanged: (newValue) {
                  setState(() {
                    selectedCase = newValue;
                  });
                },
                items: specialOptions.map((value) {
                  return DropdownMenuItem(
                    child: Text(value),
                    value: value,
                  );
                }).toList(),
              ),
            ),
            const Padding(padding: EdgeInsets.all(12)),
            finalSet(),
            const Padding(padding: EdgeInsets.all(12)),
          ],
        ),
      ),
    );
  }

  Widget marks() {
    if (selectedYear == '1st') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * .2,
            child: TextField(
              enabled: edit,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))
              ],
              controller: boards,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "10+2 Marks",
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(12)),
          SizedBox(
            width: MediaQuery.of(context).size.width * .2,
            child: TextField(
              enabled: edit,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,12}'))
              ],
              controller: jee,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Jee Mains Percentile",
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(12)),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * .2,
            child: TextField(
              enabled: edit,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))
              ],
              controller: cg,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Cumulative Grade Points ",
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(12)),
          SizedBox(
            width: MediaQuery.of(context).size.width * .2,
            child: TextField(
              enabled: edit,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: backlog,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Backlogs",
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(12)),
        ],
      );
    }
  }

  Widget finalSet() {
    if (selectedCase == 'Yes') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * .5,
            child: TextField(
              enabled: edit,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              minLines: 1,
              controller: specialText,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Reason for Special Case Request",
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(12)),
          submitDetails(),
        ],
      );
    } else {
      return submitDetails();
    }
  }

  Widget submitDetails(){
    return ElevatedButton(
      onPressed: () {
        context.loaderOverlay.show();
        saveInfo();
      },
      child: const Padding(
        padding: EdgeInsets.all(8),
        child: Text('Upload Supporting Documents'),
      ),
    );
  }

  Future<void> saveInfo() async {
    try {
       await FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser?.email)
          .set({
        'firstName': firstName.text.trim(),
        'middleName': middleName.text.trim(),
        'lastName': lastName.text.trim(),
        'rollNumber': rollNumber.text.trim(),
        'personalMobile': personalMobile.text.trim(),
        'addressLine1': addressLine1.text.trim(),
        'addressLine2': addressLine2.text.trim(),
        'city': city.text.trim(),
        'state': state.text.trim(),
        'motherOccupation': motherOccupation.text.trim(),
        'motherName': motherName.text.trim(),
        'fatherOccupation': fatherOccupation.text.trim(),
        'fatherName': fatherName.text.trim(),
        'fatherMobile': fatherMobile.text.trim(),
        'motherMobile': motherMobile.text.trim(),
        'aadhaar': aadhaar.text.trim(),
        'accountNumber': accountNumber.text.trim(),
        'accountName': accountName.text.trim(),
        'bankIFSC': bankIFSC.text.trim(),
        'incomeOptions': selectedIncome,
        'yearOptions': selectedYear,
        'cg': cg.text.trim(),
        'backlog': backlog.text.trim(),
        'jee': jee.text.trim(),
        'boards': boards.text.trim(),
        'specialOptions': selectedCase,
        'specialText': specialText.text.trim(),
        'isAdmin':false,
        'uploadFiles':false,
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return;
    }
    if (kDebugMode) {
      print('Data Save Complete');
    }
    Navigator.pushNamedAndRemoveUntil(context, '/documents', (route) => false);
  }
}
