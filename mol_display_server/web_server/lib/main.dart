import 'package:flutter/material.dart';
import 'package:web_server/add_remove_elements.dart';
import 'package:web_server/constants.dart';
import 'package:web_server/display_molecule.dart';
import 'package:web_server/select_list.dart';
import 'package:web_server/upload_sdf.dart';

void main() {
  runApp(const MolWebServer());
}

class MolWebServer extends StatelessWidget {
  const MolWebServer({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Display Molecule and SDF Files',
      // the following contains the main page of the app
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _pages = [
    'Upload SDF File',
    'Select Molecule',
    'Display Molecule',
    'Edit Elements'
  ];
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryBlue),
        backgroundColor: Colors.white,
        title: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Text(
              _pages[_selectedPageIndex],
              style: const TextStyle(
                  color: primaryBlue, fontWeight: FontWeight.w700),
            )),
      ),
      drawer: Drawer(
        backgroundColor: primaryBlue,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Colors.white,
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Text(
                      "MOLDISPLAYER 5000  ",
                      style: TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Icon(
                      Icons.bubble_chart,
                      color: primaryYellow,
                      size: 40,
                    )
                  ],
                ),
              ),
            ),
            ListView(
              shrinkWrap: true,
              children: _pages
                  .asMap()
                  .entries
                  .map(
                    (entry) => ListTile(
                      title: Text(
                        entry.value,
                        style: TextStyle(
                          color: entry.key == _selectedPageIndex
                              ? primaryYellow
                              : Colors.white,
                        ),
                      ),
                      onTap: () {
                        _selectPage(entry.key);
                        Navigator.pop(context);
                      },
                      selected: entry.key == _selectedPageIndex,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedPageIndex,
        children:  [
          const MainPageUploadSDF(),
          const MoleculeListView(),
          const RotateImage(),
          AddRemoveElements(
            onSubmit: (String name, String symbol, String colorVal1,
                String colorVal2, String colorVal3, double radius) {},
          ),
        ],
      ),
    );
  }
}
