import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/plant_provider.dart';
import 'screens/main_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlantProvider()),
      ],
      child: MaterialApp(
        title: 'Plant Catalog ',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          scaffoldBackgroundColor: const Color(0xFFF9F6F0),
        ),
        home: const MainNavigation(),
      ),
    );
  }
}