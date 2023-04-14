// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:flutter/material.dart';
import 'add_element.dart';
import 'constants.dart';
import 'api.dart';
import 'dart:math';
//String name, String symbol, String colorVal1, String colorVal2, String colorVal3, double radius
class AddRemoveElements extends StatefulWidget {
  final Function(String, String, String, String, String, double) onSubmit;
  const AddRemoveElements({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<AddRemoveElements> createState() => _AddRemoveElementsState();
}

class _AddRemoveElementsState extends State<AddRemoveElements> {

  List<ElementListItem> _elements = [
    // add carbon element with 3 random HEX colors
    ElementListItem(
      elementName: 'Carbon',
      elementCode: 'C',
      colorVal1: Random().nextInt(1 << 24).toRadixString(16),
      colorVal2: Random().nextInt(1 << 24).toRadixString(16),
      colorVal3: Random().nextInt(1 << 24).toRadixString(16),
      radius: 1.7,
      id: '23',
    ),
    // add hydrogen element with 3 random HEX colors
    ElementListItem(
      elementName: 'Hydrogen',
      elementCode: 'H',
      colorVal1: Random().nextInt(1 << 24).toRadixString(16),
      colorVal2: Random().nextInt(1 << 24).toRadixString(16),
      colorVal3: Random().nextInt(1 << 24).toRadixString(16),
      radius: 1.2,
      id: '1',
    ),
    // add oxygen element with 3 random HEX colors
    ElementListItem(
      elementName: 'Oxygen',
      elementCode: 'O',
      colorVal1: Random().nextInt(1 << 24).toRadixString(16),
      colorVal2: Random().nextInt(1 << 24).toRadixString(16),
      colorVal3: Random().nextInt(1 << 24).toRadixString(16),
      radius: 1.52,
      id: '8',
    ),
    
    
    
  ];
  


void _addElement() async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AddElement.create(
        onSubmit: (newElement) async {
          try {
            await molSQLApi.addElement(
              newElement.elementName,
              newElement.elementCode,
              newElement.colorVal1,
              newElement.colorVal2,
              newElement.colorVal3,
              newElement.radius.toDouble(),
            );

            setState(() {
              _elements.add(newElement);
            });
          } catch (e) {
            print('Error adding element: $e');
            // You can also show a message to the user informing them of the error
          }
        },
      ),
    ),
  );
}




 void _removeElement(int index) async {
  String elementSymbol = _elements[index].elementCode;

  try {
    await molSQLApi.removeElement(elementSymbol);
    setState(() {
      _elements.removeAt(index);
    });
  } catch (e) {
    print('Error deleting element: $e');
    // You can also show a message to the user informing them of the error
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: _elements.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 30, right: 30),
            child: Dismissible(
              background: Container(
                decoration: const BoxDecoration(
                  color: primaryRed,
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: const Center(
                  child: Icon(Icons.delete_forever_rounded, size: 50, color: Colors.white,),
                ),
              ),
              
              key: UniqueKey(),
              onDismissed: (direction) {
                _removeElement(index);
              },
              child: _elements[index],
            ),
          );
        },
      ),
  floatingActionButton: InkWell(
    onTap: () {
      _addElement();
    },
    child: Container(
                      decoration: const BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
      width: MediaQuery.of(context).size.width * 0.3,
      height: 60,
      child: const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.add_rounded, color: Colors.white, size: 30,),
            ),
            Text("Add Element", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),),
            
          ],
        ),
      ),
    ),
  ),
  floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ElementListItem extends StatelessWidget {
  final String id; 
  final String elementName;
  final String elementCode;
  final String colorVal1;
  final String colorVal2;
  final String colorVal3;
  final double radius;

  const ElementListItem({
    Key? key,
    required this.id,
    required this.elementName,
    required this.elementCode,
    required this.colorVal1,
    required this.colorVal2,
    required this.colorVal3,
    required this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 100,
          decoration: BoxDecoration(
            color: primaryWhite,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 20, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // column
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25.0, right: 20),
                      child: Text(
                        elementCode,
                        style: const TextStyle(
                            fontSize: 50, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          elementName,
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'Element Radius: $radius  |  HEX 1: $colorVal1  | HEX2: $colorVal2  | HEX3: $colorVal3',
                          style: const TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  ],
                ),
                // Selected Button
              ],
            ),
          ),
        ),
      ),
    );
  }
}
