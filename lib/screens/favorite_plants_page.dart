import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/plant.dart';
import 'plant_detail_page.dart';

class FavoritePlantsPage extends StatefulWidget {
  const FavoritePlantsPage({super.key});

  @override
  State<FavoritePlantsPage> createState() => _FavoritePlantsPageState();
}

class _FavoritePlantsPageState extends State<FavoritePlantsPage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<Plant> _favoritePlants = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFavoritePlants();
  }

  // Mengambil data tanaman yang berstatus is_favorite = true dari Supabase
  Future<void> _fetchFavoritePlants() async {
    try {
      final response = await _supabase
          .from('saved_plants')
          .select()
          .eq('is_favorite', true);

      final loadedPlants = (response as List)
          .map((item) => Plant.fromJson(item))
          .toList();

      setState(() {
        _favoritePlants = loadedPlants;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat favorit: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Tanaman Favorit',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black87),
            onPressed: () {
              setState(() => _isLoading = true);
              _fetchFavoritePlants();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)))
          : _favoritePlants.isEmpty
              ? const Center(
                  child: Text(
                    "Belum ada tanaman favorit.",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _favoritePlants.length,
                  itemBuilder: (context, index) {
                    final plant = _favoritePlants[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.favorite, color: Colors.red),
                        ),
                        title: Text(
                          plant.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text(
                          "${plant.category} • ${plant.wateringSchedule}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlantDetailPage(plant: plant),
                            ),
                          );
                          // Refresh halaman favorit saat kembali dari detail
                          _fetchFavoritePlants();
                        },
                      ),
                    );
                  },
                ),
    );
  }
}