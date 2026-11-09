import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/plant_provider.dart';
import 'screens/main_navigation.dart';

void main() async {
  // Wajib ada untuk memastikanbinding Flutter siap sebelum inisialisasi async
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase (DI DALAM fungsi main dan di dalam blok async)
  await Supabase.initialize(
    url: 'https://xmkjwykvrdwhfaigyxvu.supabase.co',
    anonKey: 'sb_publishable_DS5v6ZJhq65Zk65oj6uSHQ_flL9G-V4',
  );

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
        title: 'Plant Catalog UTS',
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