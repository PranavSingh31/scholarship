import 'dart:typed_data';

import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FileUpload extends StatefulWidget {
  const FileUpload({Key? key}) : super(key: key);

  @override
  State<FileUpload> createState() => _FileUploadState();
}

class _FileUploadState extends State<FileUpload> {
  @override
  Widget build(BuildContext context) {
    Future<void> getFile(var documentName) async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      var user = FirebaseAuth.instance.currentUser?.email;
      if (result != null) {
        Uint8List? fileBytes = result.files.first.bytes;
        String fileName = result.files.first.name;

        // Upload file
        await FirebaseStorage.instance.ref('uploads/$user/$fileName').putData(fileBytes!);
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width*.7,
              child: Card(
                child: Column(
                  children: [
                    ElevatedButton(
                        onPressed: (){
                          getFile('test');
                        },
                        child: Text('Upload'),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
