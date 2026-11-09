import 'package:flutter/material.dart';
import 'home_page.dart';
import 'plant_detail_page.dart';
import 'add_plant_page.dart'; // <-- Tambahkan import ini di bagian atas

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Daftar screen utama aplikasi
  final List<Widget> _screens = [
    const HomePage(),
    const Center(child: Text("Halaman Daftar Tanaman")),
    const Center(child: Text("Halaman Favorit")),
    const Center(child: Text("Halaman Profil")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2E7D32),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.eco), label: 'Tanaman'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2E7D32),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          // Navigasi ke Halaman Form Tambah Tanaman
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPlantPage()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}