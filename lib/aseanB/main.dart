import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'univBloC.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List Universitas ASEAN',
      home: BlocProvider(
        create: (context) => UniversityBloc(),
        child: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final universityBloc = BlocProvider.of<UniversityBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('List Universitas di ASEAN'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<UniversityBloc, UniversityState>(
              builder: (context, state) {
                return DropdownButton<String>(
                  value: "Indonesia",
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      universityBloc.add(FetchUniversities(newValue));
                    }
                  },
                  items: <String>['Indonesia', 'Malaysia', 'Singapore', 'Thailand']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                );
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<UniversityBloc, UniversityState>(
                builder: (context, state) {
                  if (state.universities.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: state.universities.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            state.universities[index].name,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            state.universities[index].website,
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
