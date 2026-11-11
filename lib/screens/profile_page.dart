import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../repositories/plant_repository.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final PlantRepository _plantRepository = PlantRepository();
  
  // State data profil
  String _name = "Ni Komang Mirna Asih";
  String _nim = "2415051018";
  String _class = "PTI 4B";
  
  int _favoriteCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfileStats();
  }

  Future<void> _fetchProfileStats() async {
    try {
      final plants = await _plantRepository.getPlants();
      final favorites = plants.where((p) => p.isFavorite).length;
      
      if (!mounted) return;
      setState(() {
        _favoriteCount = favorites;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _name);
    final nimController = TextEditingController(text: _nim);
    final classController = TextEditingController(text: _class);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Edit Profil Pengembang", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Nama Lengkap", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nimController,
                  decoration: const InputDecoration(labelText: "NIM", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: classController,
                  decoration: const InputDecoration(labelText: "Kelas", border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32)),
              onPressed: () {
                setState(() {
                  _name = nameController.text;
                  _nim = nimController.text;
                  _class = classController.text;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profil berhasil diperbarui!")),
                );
              },
              child: const Text("Simpan", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Profil Pengembang", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF2E7D32)),
            tooltip: "Edit Profil",
            onPressed: _showEditProfileDialog,
          ),
        ],
      ),
      // LayoutBuilder mendeteksi lebar layar secara dinamis (Web vs HP)
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 800; // Lebar standar untuk mode web/desktop

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 60.0 : 16.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Bagian Header Profil (Foto, Nama, NIM)
                Center(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF2E7D32), width: 3),
                            ),
                            child: const CircleAvatar(
                              radius: 55,
                              backgroundImage: AssetImage('assets/images/profil.jpeg'),
                            ),
                          ),
                          InkWell(
                            onTap: _showEditProfileDialog,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0xFF2E7D32),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _name,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "NIM: $_nim | Kelas: $_class",
                          style: const TextStyle(color: Color(0xFF2E7D32), fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Universitas Pendidikan Ganesha (Undiksha)",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Bagian Konten Bawah (Responsif: Berdampingan di Web, Bertumpuk di HP)
                isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Kolom Kiri: Statistik Card (Favorit & Status)
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                _buildStatCard(
                                  icon: Icons.favorite,
                                  iconColor: Colors.redAccent,
                                  title: "Tanaman Disukai",
                                  value: _isLoading ? "..." : "$_favoriteCount",
                                ),
                                const SizedBox(height: 16),
                                _buildStatCard(
                                  icon: Icons.eco,
                                  iconColor: const Color(0xFF2E7D32),
                                  title: "Status Akun",
                                  value: "Active",
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          // Kolom Kanan: Informasi Detail Aplikasi
                          Expanded(
                            flex: 2,
                            child: _buildInfoCard(),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  icon: Icons.favorite,
                                  iconColor: Colors.redAccent,
                                  title: "Tanaman Disukai",
                                  value: _isLoading ? "..." : "$_favoriteCount",
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildStatCard(
                                  icon: Icons.eco,
                                  iconColor: const Color(0xFF2E7D32),
                                  title: "Status Akun",
                                  value: "Active",
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildInfoCard(),
                        ],
                      ),
                const SizedBox(height: 60),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget Kartu Statistik
  Widget _buildStatCard({required IconData icon, required Color iconColor, required String title, required String value}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 30),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: iconColor == Colors.redAccent ? Colors.black87 : const Color(0xFF2E7D32)),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  // Widget Kartu Informasi Aplikasi
  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.info_outline, color: Color(0xFF2E7D32), size: 20),
              SizedBox(width: 8),
              Text("Informasi Aplikasi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const Divider(height: 24),
          _buildInfoRow("Nama Aplikasi", "Plant Catalog (Katalog Tanaman)"),
          const SizedBox(height: 12),
          _buildInfoRow("Mata Kuliah", "Pemrograman Mobile (UTS)"),
          const SizedBox(height: 12),
          _buildInfoRow("Backend", "Supabase & REST API"),
          const SizedBox(height: 12),
          _buildInfoRow("Framework", "Flutter & Dart"),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87)),
      ],
    );
  }
}