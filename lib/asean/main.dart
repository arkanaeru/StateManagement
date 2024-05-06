import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

class University {
  String name;
  String website;
  University({required this.name, required this.website});
}

void main() {
  runApp(
    ChangeNotifierProvider<UniversityModel>(
      create: (context) => UniversityModel(),
      child: const MyApp(),
    ),
  );
}

class UniversityModel extends ChangeNotifier {
  List<University> universities = [];
  String selectedCountry = "Indonesia";

  Future<void> fetchData(String country) async {
    String url = "http://universities.hipolabs.com/search?country=$country";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      universities.clear();
      data.forEach((university) {
        universities.add(University(
          name: university['name'],
          website: university['web_pages'][0],
        ));
      });
      notifyListeners();
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  void setCountry(String country) {
    selectedCountry = country;
    fetchData(selectedCountry);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List Universitas Indonesia',
      home: Scaffold(
        appBar: AppBar(
          title: Text('List Universitas di ASEAN'),
        ),
        body: Center(
          child: Consumer<UniversityModel>(
            builder: (context, universityModel, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                    value: universityModel.selectedCountry,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        universityModel.setCountry(newValue);
                      }
                    },
                    items: <String>['Indonesia', 'Malaysia', 'Singapura', 'Thailand']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: universityModel.universities.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                universityModel.universities[index].name,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                universityModel.universities[index].website,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: 1,
                              indent: 16,
                              endIndent: 16,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
