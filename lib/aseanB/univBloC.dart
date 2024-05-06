import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UniversityEvent {}

class FetchUniversities extends UniversityEvent {
  final String country;

  FetchUniversities(this.country);
}

class UniversityState {
  final List<University> universities;

  UniversityState(this.universities);
}

class UniversityBloc extends Bloc<UniversityEvent, UniversityState> {
  UniversityBloc() : super(UniversityState([]));

  Stream<UniversityState> mapEventToState(UniversityEvent event) async* {
    if (event is FetchUniversities) {
      yield* _mapFetchUniversitiesToState(event.country);
    }
  }

  Stream<UniversityState> _mapFetchUniversitiesToState(String country) async* {
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
      yield UniversityState(universities);
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
