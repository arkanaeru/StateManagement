import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UniversityCubit extends Cubit<List<University>> {
  UniversityCubit() : super([]);

  Future<void> fetchData(String country) async {
    String url = "http://universities.hipolabs.com/search?country=$country";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<University> universities = [];
      data.forEach((university) {
        universities.add(University(
          name: university['name'],
          website: university['web_pages'][0],
        ));
      });
      emit(universities);
    } else {
      throw Exception('Gagal memuat data');
    }
  }
}

class University {
  String name;
  String website;
  University({required this.name, required this.website});
}
