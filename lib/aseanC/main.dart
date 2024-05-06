import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'univCubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List Universitas ASEAN',
      home: BlocProvider(
        create: (context) => UniversityCubit(),
        child: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final universityCubit = BlocProvider.of<UniversityCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('List Universitas di ASEAN'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<UniversityCubit, List<University>>(
              builder: (context, universities) {
                return DropdownButton<String>(
                  value: "Indonesia",
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      universityCubit.fetchData(newValue);
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
              child: BlocBuilder<UniversityCubit, List<University>>(
                builder: (context, universities) {
                  return ListView.builder(
                    itemCount: universities.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          universities[index].name,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          universities[index].website,
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
