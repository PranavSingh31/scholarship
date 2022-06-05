
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class FileUpload extends StatefulWidget {
  const FileUpload({Key? key}) : super(key: key);

  @override
  State<FileUpload> createState() => _FileUploadState();
}

class _FileUploadState extends State<FileUpload> {
  String year = DateTime.now().year.toString();
  var nameFile ='';
  var show = [0,0,0,0,0,0,0,0,0,0];
  @override
  Widget build(BuildContext context) {
    context.loaderOverlay.hide();
    Future<void> getFile(var documentName) async {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      var user = FirebaseAuth.instance.currentUser?.email;
      if (result != null) {
        Uint8List? fileBytes = result.files.first.bytes;
        String fileName = '$documentName.pdf'; //result.files.first.name;
        // Upload file
        try{
          context.loaderOverlay.show();
          await FirebaseStorage.instance.ref().child('uploads/$user/$year/$fileName').putData(
              fileBytes!,
              SettableMetadata(
                  contentType: 'application/pdf'
              )
          );
        }on FirebaseException catch (e){
          if (kDebugMode) {
            print(e);
          }
          return;
        }
        context.loaderOverlay.hide();
        return;
      }
      return;
    }

    Widget uploadRow(var displayText, var pdfName,var id) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(displayText),
          ),
          ElevatedButton(
              onPressed: () async {
                await getFile(pdfName);
                setState(() {
                  show[id] = 1;
                });
              },
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Text('Upload document'),
              ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: (show[id]==1)?Text('$pdfName.pdf'):const Text(''),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Supporting Documents'),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width*.7,
                child: Card(
                  child: Column(
                    children: [
                      //up to 10 documents supported
                      uploadRow('Birth Certificate', 'birthCertificate',0),
                      const Padding(padding: EdgeInsets.all(4)),
                      uploadRow('Aadhar Card', 'adhaarCard',1),
                      const Padding(padding: EdgeInsets.all(8)),
                      ElevatedButton(
                          onPressed: (){
                            context.loaderOverlay.show();
                            submitDocuments();
                          },
                          child: const Padding(padding: EdgeInsets.all(8),child: Text('Submit Documents'),),
                      ),
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
  Future<void> submitDocuments() async{
    try{
      FirebaseFirestore.instance.collection('user')
          .doc(FirebaseAuth.instance.currentUser?.email)
          .update({
        'uploadFiles':true,
      });
      //Get and set URL for the documents uploaded and push the values to Firestore.
    }catch (e) {
      if (kDebugMode) {
        print(e);
      }
      showAlert('Server Error\nTry again Later');
      return;
    }
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }
  void showAlert(var message){
    var alert = AlertDialog(
      title: const Text('Error!'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: (){
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
