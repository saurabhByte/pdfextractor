import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PlatformFile? file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: (){
                  pickFile();
                },
                child: Text('Press Me'),
            ),
            SizedBox(height: 50,),
            TextButton(
              onPressed: (){
                extractText();
              },
              child: Text('Extract Text'),
            ),
          ],
        ),
      ),
    );
  }

  void pickFile() async {

    // opens storage to pick files and the picked file or files
    // are assigned into result and if no file is chosen result is null.
    // you can also toggle "allowMultiple" true or false depending on your need
    /*final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    // if no file is picked
    if (result == null) return;

    // we will log the name, size and path of the
    // first picked file (if multiple are selected)
    print(result.files.first.name);
    print(result.files.first.size);
    print(result.files.first.path);*/

    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf']);
    if (result != null) {
      //PlatformFile file = result.files.first;
       file = result.files.first;
      print(file!.name);
      print(file!.path);
      print(file!.size);

      //uploadImage(file.path!, file.extension!);
    }
  }

  Future<void> extractText() async {
    PdfDocument document = PdfDocument(inputBytes: await readDocumentData('${file!.path}'));
    PdfTextExtractor extractor = PdfTextExtractor(document);
    String text = extractor.extractText();
    print("Text : $text");

    showResult(text);
  }

  Future<List<int>>readDocumentData(String s) async {
    File file = File(s);
    Uint8List bytes = file.readAsBytesSync();
    print('Bytes : $bytes');
    return bytes.buffer.asUint8List(bytes.offsetInBytes,bytes.lengthInBytes);
   // Uint8List uint8list = Uint8List.fromList(File(s as List<Object>).relativePath);

    //return uint8list.buffer.asUint8List(uint8list.offsetInBytes,uint8list.lengthInBytes);
  }

  void showResult(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('A'),
            content: Scrollbar(
              child: SingleChildScrollView(
                child: Text(text),
                  physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()
                  ),
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: Text('Close'))
            ],
          );
        });
  }
}
