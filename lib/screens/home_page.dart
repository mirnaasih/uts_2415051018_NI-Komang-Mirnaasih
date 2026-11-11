import 'package:flutter/material.dart';
import 'plant_catalog_page.dart';
import 'plant_detail_page.dart';
import '../models/plant.dart';
import '../repositories/plant_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PlantRepository _plantRepository = PlantRepository();
  List<Plant> _plants = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final plants = await _plantRepository.getPlants();
      if (!mounted) return;
      setState(() {
        _plants = plants;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstPlantImage = _plants.isNotEmpty ? _plants.first.imageUrl : '';

    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      // Menggunakan LayoutBuilder untuk mendeteksi apakah sedang di Web/Desktop atau HP
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 800; // Batas layar web

          return SingleChildScrollView(
            // Padding lebih luas di web agar tidak terlalu menepi, pas di HP
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 40.0 : 16.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Sapaan
                const Text(
                  "Selamat Pagi",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Text(
                      "Mirna Asih",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: 6),
                    Text("🌱", style: TextStyle(fontSize: 20)),
                  ],
                ),
                const Text(
                  "NIM: 2415051018 • Mari rawat tanamanmu!",
                  style: TextStyle(color: Color(0xFF2E7D32), fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 24),

                // Bagian Atas: Di Web bisa dibuat berdampingan, di HP bertumpuk
                isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Card Utama Total Tanaman (Lebar fleksibel di web)
                          Expanded(
                            flex: 2,
                            child: _buildMainCard(firstPlantImage),
                          ),
                          const SizedBox(width: 24),
                          // Tugas Hari Ini di sebelah kanan card utama khusus web
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Tugas Hari Ini",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(child: _buildTaskCard("Siram Tanaman", Icons.water_drop_outlined, "09:00 WITA")),
                                    const SizedBox(width: 12),
                                    Expanded(child: _buildTaskCard("Beri Pupuk", Icons.spa_outlined, "11:00 WITA")),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMainCard(firstPlantImage),
                          const SizedBox(height: 24),
                          const Text(
                            "Tugas Hari Ini",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: _buildTaskCard("Siram Tanaman", Icons.water_drop_outlined, "09:00 WITA")),
                              const SizedBox(width: 12),
                              Expanded(child: _buildTaskCard("Beri Pupuk", Icons.spa_outlined, "11:00 WITA")),
                            ],
                          ),
                        ],
                      ),
                const SizedBox(height: 32),

                // Daftar Koleksi Tanaman
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Koleksi Tanaman",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    TextButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PlantCatalogPage()),
                        );
                        _fetchData();
                      },
                      child: const Text("Lihat Semua", style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)))
                    : _plants.isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(30),
                            alignment: Alignment.center,
                            child: const Text("Belum ada data tanaman.", style: TextStyle(color: Colors.grey)),
                          )
                        : isDesktop
                            // Di Web tampil sebagai Grid 3 kolom agar memenuhi layar lebar
                            ? GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _plants.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 2.8,
                                ),
                                itemBuilder: (context, index) {
                                  return _buildPlantCard(_plants[index]);
                                },
                              )
                            // Di HP tampil sebagai List ke bawah biasa
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _plants.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _buildPlantCard(_plants[index]),
                                  );
                                },
                              ),
                const SizedBox(height: 32),

                // Tips Perawatan
                const Text(
                  "Tips Perawatan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.lightbulb_outline, color: Color(0xFF2E7D32)),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          "Bersihkan daun tanaman secara rutin agar dapat bernapas dan menyerap cahaya lebih baik.",
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget Pendukung Card Utama
  Widget _buildMainCard(String firstPlantImage) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tanaman Anda",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 8),
              _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(
                      "${_plants.length}",
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
              const SizedBox(height: 4),
              const Text(
                "Total Tanaman",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF2E7D32),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PlantCatalogPage(),
                    ),
                  );
                  _fetchData();
                },
                child: const Text("Lihat Semua", style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: 100,
              height: 100,
              color: Colors.white24,
              child: firstPlantImage.isNotEmpty
                  ? Image.network(
                      firstPlantImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.eco, color: Colors.white, size: 40),
                    )
                  : const Icon(Icons.eco, color: Colors.white, size: 40),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Pendukung Task Card
  Widget _buildTaskCard(String title, IconData icon, String time) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF2E7D32)),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Text("⏱️ $time", style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  // Widget Pendukung Plant Card
  Widget _buildPlantCard(Plant plant) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            plant.imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(width: 50, height: 50, color: Colors.grey.shade200, child: const Icon(Icons.eco, color: Color(0xFF2E7D32))),
          ),
        ),
        title: Text(plant.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text("${plant.category} • ${plant.wateringSchedule}", style: const TextStyle(fontSize: 11, color: Colors.grey)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlantDetailPage(plant: plant),
            ),
          );
          _fetchData();
        },
      ),
    );
  }
}