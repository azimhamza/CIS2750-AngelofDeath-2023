import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

// declaring the molSQLApi class
final MolSQLApi molSQLApi = MolSQLApi(baseUrl: 'http://localhost:8080');

class MolSQLApi {
  final String baseUrl;

  MolSQLApi({required this.baseUrl});

  Future<String> getMoleculeList() async {
    final response = await http.get(Uri.parse('$baseUrl/molecule_list'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load molecule list');
    }
  }

  Future<String> getElementList() async {
    final response = await http.get(Uri.parse('$baseUrl/element_list'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load element list');
    }
  }

  Future<String> addMolecule(String moleculeName, String fileContent) async {
    final response = await http.post(
      Uri.parse('$baseUrl/molecule'),
      body: jsonEncode({'molecule_name': moleculeName, 'file_content': fileContent}),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to add molecule');
    }
  }

Future<String> addElement(
    String name, String symbol, String colorVal1, String colorVal2, String colorVal3, double radius) async {
  // Generate a random integer for the element number
  int elementNo = Random().nextInt(1 << 32); // Generates a random integer between 0 and 2^32 - 1

  late  http.Response response = http.Response('', 200);// declare the response variable
  
  try {
    response = await http.post(
      Uri.parse('$baseUrl/add_element'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'element_no': elementNo,
        'name': name,
        'symbol': symbol,
        'colorVal1': colorVal1,
        'colorVal2': colorVal2,
        'colorVal3': colorVal3,
        'radius': radius,
      }),
    ).timeout(Duration(seconds: 30)); 

  } catch (e) {
    print('Error: $e'); // handle the error
  }

  if (response.statusCode == 200) {

    return response.body;
  } else {
    
    throw Exception('Failed to add element');
  }
}

//This code generates a random integer for the ELEMENT_NO using Random().nextInt(1 << 32), which generates a random integer between 0 and 2^32 - 1. This random number is then included in the request body as the 'element_no' key-value pair.







  Future<String> removeElement(String symbol) async {
    final response = await http.post(
      Uri.parse('$baseUrl/remove_element'),
      body: jsonEncode({'symbol': symbol}),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to remove element');
    }
  }

  Future<String> loadMolecule(String moleculeName) async {
    final response = await http.post(
      Uri.parse('$baseUrl/load_molecule'),
      body: jsonEncode({'molecule_name': moleculeName}),
    ).timeout(Duration(seconds: 30)); 

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load molecule');
    }
  }

  Future<String> countAtomBonds(String moleculeName) async {
    final response = await http.post(
      Uri.parse('$baseUrl/count_atom-bonds'),
      body: jsonEncode({'molecule_name': moleculeName}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to count atom bonds');
    }
  }

  Future<String> countElements(String moleculeName) async {
    final response = await http.post(
      Uri.parse('$baseUrl/count_elements'),
      body: jsonEncode({'molecule_name': moleculeName}),
    ).timeout(Duration(seconds: 30)); 

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to count elements');
    }
  }
}
