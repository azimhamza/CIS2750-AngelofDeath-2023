import 'package:flutter/material.dart';
import 'package:web_server/constants.dart';

class MoleculeListView extends StatefulWidget {
  const MoleculeListView({Key? key}) : super(key: key);

  @override
  State<MoleculeListView> createState() => _MoleculeListViewState();
}

class _MoleculeListViewState extends State<MoleculeListView> {
  // this is the list of items that will be displayed in the ListView
  final List<MoleculeListItem> _items = [

    //Generate Examples
    MoleculeListItem(
      moleculeName: 'Water',
      atomAmount: 3,
      bondAmount: 2,
      isSelected: false,
      svgUrl: '', onPressed: () {  },),
    // Generate Example for Isopentanol
    MoleculeListItem(
      moleculeName: 'Isopentanol',
      atomAmount: 8,
      bondAmount: 7,
      isSelected: false,
      svgUrl: '', onPressed: () {  },
    ),

    


  ];

  void _selectItem(int index) {
    setState(() {
      // deselect previously selected item
      for (int i = 0; i < _items.length; i++) {
        if (_items[i].isSelected && i != index) {
          _items[i].isSelected = false;
        }
      }

      // select the new item
      _items[index].isSelected = true;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: _items
            .asMap()
            .entries
            .map((entry) => GestureDetector(
                  onTap: () {
                    _selectItem(entry.key);
                  },
                  child: MoleculeListItem(
                    moleculeName: entry.value.moleculeName,
                    atomAmount: entry.value.atomAmount,
                    bondAmount: entry.value.bondAmount,
                    isSelected: entry.value.isSelected,
                    svgUrl: entry.value.svgUrl,
                    onPressed: () {
                      _selectItem(entry.key);
                    },
                  ),
                ))
            .toList(),
      ),
    );
  }
}


class MoleculeListItem extends StatelessWidget {
  final String moleculeName;
  final int atomAmount;
  final int bondAmount;
  bool isSelected;
  final String svgUrl; 
  final VoidCallback onPressed;

  MoleculeListItem({
    Key? key,
    required this.moleculeName,
    required this.atomAmount,
    required this.bondAmount,
    required this.svgUrl,
    required this.isSelected,
    required this.onPressed,
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
                    const Padding(
                      padding: EdgeInsets.only(bottom: 25.0, right: 20),
                      child: Icon(Icons.trip_origin_rounded, size: 40, color: primaryYellow,),
                    ), 
                     Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          moleculeName,
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w700),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Amount of Atoms: $atomAmount  |',
                              style: const TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            Text(
                              '  Amount of Bonds: $bondAmount ',
                              style: const TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        )
                      ],
                ),
                   ],
                 ),
                // Selected Button
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: SelectButton(
                    isSelected: isSelected,
                    onPressed: onPressed,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class SelectButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback? onPressed;

  const SelectButton({
    Key? key,
    required this.isSelected,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: OutlinedButton(
        onPressed: onPressed,
        style: isSelected
            ? OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: primaryBlue,
              )
            : null,
        child: isSelected
            ? const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check,
                    size: 20,
                  ),
                  SizedBox(width: 25),
                  Text(
                    'Selected',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ],
              )
            : const SizedBox(
                height: 40,
                child: Center(
                  child: Text(
                    'Select',
                    style: TextStyle(color: primaryBlue, fontSize: 25),
                  ),
                ),
              ),
      ),
    );
  }
}






