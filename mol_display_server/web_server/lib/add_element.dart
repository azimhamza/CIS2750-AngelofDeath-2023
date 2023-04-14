import 'package:flutter/material.dart';
import 'constants.dart';
import 'add_remove_elements.dart';
import 'api.dart';
import 'dart:convert';
import 'package:logger/logger.dart';

class AddElement extends StatefulWidget {
  final Function(ElementListItem) onSubmit;
  final String? id;
  final String? elementName;
  final String? elementCode;

  // Constructor for creating a new element
  const AddElement.create({
    Key? key,
    required this.onSubmit,
  })  : id = null,
        elementName = null,
        elementCode = null,
        super(key: key);

  // Constructor for updating an existing element
  const AddElement.update({
    Key? key,
    required this.onSubmit,
    required this.id,
    required this.elementName,
    required this.elementCode,
  }) : super(key: key);

  @override
  State<AddElement> createState() => _AddElementState();
}


class _AddElementState extends State<AddElement> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _elementNameController = TextEditingController();
  final TextEditingController _elementCodeController = TextEditingController();
  final TextEditingController _colorVal1Controller = TextEditingController();
  final TextEditingController _colorVal2Controller = TextEditingController();
  final TextEditingController _colorVal3Controller = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();

  @override
  void dispose() {
    _elementNameController.dispose();
    _elementCodeController.dispose();
    _colorVal1Controller.dispose();
    _colorVal2Controller.dispose();
    _colorVal3Controller.dispose();
    _radiusController.dispose();
    super.dispose();
  }

Future<void> _submitForm () async {
  if (_formKey.currentState!.validate()) {

    // call the api to add the element
    
      String elementName =  _elementNameController.text;
      String elementCode = _elementCodeController.text;
      String colorVal1 = _colorVal1Controller.text.isEmpty ? '#81c2be' : _colorVal1Controller.text;
      String colorVal2 = _colorVal2Controller.text.isEmpty ? '#1bd8d8' : _colorVal2Controller.text;
      String colorVal3 = _colorVal3Controller.text.isEmpty ? '#b5f7ec' : _colorVal3Controller.text;
      double radius = _radiusController.text.isEmpty ? 10 : double.parse(_radiusController.text);

      final responseString = await molSQLApi.addElement(elementName, elementCode, colorVal1, colorVal2, colorVal3, radius);
     
      //final response = jsonDecode(responseString);

      // use the response to create new ElementListItem
      final ElementListItem elementListItem = ElementListItem(
        id: '123',
        elementName: elementName,
        elementCode: elementCode,
        colorVal1: colorVal1,
        colorVal2: colorVal2,
        colorVal3: colorVal3,
        radius: radius,
      );

      widget.onSubmit(elementListItem);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
   
  }
}


  @override
  Widget build(BuildContext context) {
// regex patterns
    final RegExp hexColorRegex = RegExp(r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$');
    final RegExp elementNamePattern = RegExp(r'^[a-zA-Z]+(?:[\s-][a-zA-Z]+)*$');
    final RegExp elementCodePattern = RegExp(r'^[A-Z][a-z]?$');
    final RegExp numberPattern = RegExp(r'^-?\d+(\.\d+)?$');
    final RegExp oneToThirty = RegExp(r'^((0\.[1-9])|([1-9]\d{0,1}(\.\d+)?)|(30(\.0*)?))$');

    return Scaffold(
      backgroundColor: primaryWhite,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: primaryBlue),
        elevation: 0,
        backgroundColor: primaryWhite,
        title: const Text(
          'Add Element',
          style: TextStyle(color: primaryBlue, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(70)),
                ),
                width: MediaQuery.of(context).size.width * 0.8,
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Add TextFormField widgets for each attribute
                        // elementName
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: _buildTextField(
                            controller: _elementNameController,
                            labelText: 'Element Name',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Element name is required';
                              } else if (!elementNamePattern.hasMatch(value)) {
                                return 'Element Name is Incorrect, Try Again';
                              }
                              return null;
                            },
                          ),
                        ),
                        // elementCode
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: _buildTextField(
                            controller: _elementCodeController,
                            labelText: 'Element Code',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Element code is required';
                              } else if (!elementCodePattern.hasMatch(value)) {
                                return 'Element Code is Incorrect, Try Again';
                              }
                              return null;
                            },
                          ),
                        ),
                        // colorVal1
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: _buildTextField(
                            controller: _colorVal1Controller,
                            labelText: 'HEX Color 1',
                            validator: (p0) {
                              if (p0 != null &&
                                  p0.isNotEmpty &&
                                  !hexColorRegex.hasMatch(p0)) {
                                return 'Incorrect HEX pattern';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        // colorVal2
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: _buildTextField(
                            controller: _colorVal2Controller,
                            labelText: 'HEX Color 2',
                            validator: (p0) {
                              if (p0 != null &&
                                  p0.isNotEmpty &&
                                  !hexColorRegex.hasMatch(p0)) {
                                return 'Incorrect HEX pattern';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        // colorVal3
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: _buildTextField(
                            controller: _colorVal3Controller,
                            labelText: 'HEX Color 3',
                            validator: (p0) {
                              if (p0 != null &&
                                  p0.isNotEmpty &&
                                  !hexColorRegex.hasMatch(p0)) {
                                return 'Incorrect HEX pattern'; 
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        // radius
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: _buildTextField(
                            controller: _radiusController,
                            labelText: 'Radius',
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                if (!numberPattern.hasMatch(value)) {
                                  return 'Incorrect Number Parameter';
                                } else if (!oneToThirty.hasMatch(value)) {
                                  return 'Value is either way too big or too small, figure it out.';
                                }
                              } else {
                                return null;
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 100.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 80,
                            decoration: const BoxDecoration(
                                color: primaryBlue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: InkWell(
                              onTap: () {
                                _submitForm();
                              },
                              child: const Center(
                                  child: Text(
                                "Submit",
                                style: TextStyle(
                                    fontSize: 25, color: Colors.white),
                              ),),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      cursorColor: primaryBlue,
      style: const TextStyle(
        color: primaryBlue,
        fontSize: 18,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: primaryBlue, fontSize: 18),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: primaryYellow, width: 3.0),
        ),
        //
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: primaryBlue, width: 3.0),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: primaryYellow, width: 3.0),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: primaryRed, width: 3.0),
        ),
      ),
      validator: validator,
    );
  }
}
