import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 150,),
            TextButton(
                onPressed: (){
                  pickFile();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Text(
                      'Open PDF',
                    style: const TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              style: TextButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)
                  )
              ),
            ),
            SizedBox(height: 30,),
            file?.path.toString() == null || file?.path.toString() == ""
            ? Text('')
            : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Text(
                  file!.path.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,

                ),
              ),
            ),
            SizedBox(height: 30,),
            TextButton(
              onPressed: (){
                extractText();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Text(
                  'Extract Text',
                  style: const TextStyle(
                      color: Colors.white
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf']);
    if (result != null) {
      //PlatformFile file = result.files.first;
       file = result.files.first;
      print(file!.name);
      print(file!.path);
      print(file!.size);

    }
    setState(() {

    });
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
            title: Text('Extracted Text'),
            content: Scrollbar(
              child: SingleChildScrollView(
                child: Text(text),
                  physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()
                  ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                Navigator.of(context).pop();
              },
                  child: Text(
                      'Close',
                    style: const TextStyle(
                        color: Colors.white
                    ),
                  ),
                style: TextButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    )
                ),
              )
            ],
          );
        });
  }
}
