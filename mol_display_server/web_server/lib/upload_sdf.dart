// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:core';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:web_server/api.dart';
import 'package:web_server/constants.dart';
import 'package:path/path.dart' as path;


class MainPageUploadSDF extends StatefulWidget {
  const MainPageUploadSDF({super.key});

  @override
  State<MainPageUploadSDF> createState() => _MainPageUploadSDFState();
}

class _MainPageUploadSDFState extends State<MainPageUploadSDF> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // files image
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    child: Center(
                        child: Icon(Icons.upload_rounded,
                            size: 200, color: primaryGrey))),
                Text(
                  "Select a file to Upload. SDF files only.",
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                height: 60,
                child: InkWell(
                  onTap: () async {

                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['sdf'],
                    );
                    if ( result != null) { 
                      File file = File(result.files.single.path!);
                      String fileContent = await file.readAsString();
                      String fileExtension = path.extension(file.path);
                      
                      if (fileExtension == '.sdf'){ 
                        await showUploadResultDialog(context, fileExtension);
                        return;
                      }
                    
               
                    
  TextEditingController moleculeNameController = TextEditingController();
    String? moleculeName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Molecule Name'),
          content: TextFormField(
            controller: moleculeNameController,
            decoration: const InputDecoration(
              labelText: 'Molecule Name',
              hintText: 'Molecule Name',
            ),
          ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(moleculeNameController.text);
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
  if (moleculeName != null && moleculeName.isNotEmpty) {
    
    final addMoleculeResult = await molSQLApi.addMolecule(moleculeName, fileContent);
    
    await showUploadResultDialog(context, '.sdf');
  } 
  else {
    await showUploadResultDialog(context, null);
  }
                    }},

                  child: Container(
                    //circular rectangle
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: primaryBlue),
                    child: const Center(
                        child: Text(
                      "Select File",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }




  Future<void> showUploadResultDialog(
      BuildContext context, String? fileExtension) async {
    String title;
    String message;

    if (fileExtension == null) {
      title = 'Upload Failed';
      message = 'File upload failed. Please try again.';
    } else if (fileExtension != '.sdf') {
      title = 'Invalid File Format';
      message = 'Please upload a file with the .sdf extension.';
    } else {
      title = 'Upload Successful';
      message = 'Please name your molecule.';
    }

    TextEditingController moleculeNameController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              if (fileExtension == '.sdf')
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: TextFormField(
                      cursorColor: primaryYellow,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                        color: primaryYellow,
                        fontFamily: "Manrope-Regular",
                        fontSize: 18,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Molecule Name',
                        labelStyle: TextStyle(
                            color: primaryGrey,
                            fontFamily: 'manrope',
                            fontSize: 18),
                        border: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: primaryYellow, width: 3.0),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: primaryYellow, width: 3.0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: primaryYellow, width: 3.0),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: primaryRed, width: 3.0),
                        ),
                        hintText: 'Molecule Name',
                        hintStyle: TextStyle(
                          color: primaryYellow,
                          fontFamily: "Manrope",
                          fontSize: 18,
                        ),
                      ),
                      controller: moleculeNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Molecule name required';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: primaryRed),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            if (fileExtension == '.sdf')
              TextButton(
                child: const Text(
                  'Save',
                  style: TextStyle(
                      color: primaryBlue, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  // Save the molecule name and other information in a list.
                  // For example: moleculeList.add(moleculeNameController.text);
                  Navigator.of(context).pop();
                },
              ),
          ],
        );
      },
    );
  }

}