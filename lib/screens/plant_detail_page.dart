import 'package:flutter/material.dart';
import '../models/plant.dart';

class PlantDetailPage extends StatelessWidget {
  final Plant? plant;

  const PlantDetailPage({super.key, this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Tanaman',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Tanaman
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 220,
                width: double.infinity,
                color: Colors.grey.shade200,
                child: plant?.imageUrl != null && plant!.imageUrl.isNotEmpty
                    ? Image.network(
                        plant!.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.eco, size: 80, color: Color(0xFF2E7D32)),
                      )
                    : const Icon(Icons.eco, size: 80, color: Color(0xFF2E7D32)),
              ),
            ),
            const SizedBox(height: 16),

            // Baris Nama Tanaman & Tombol Edit/Hapus
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plant?.name ?? 'Anggrek',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      plant?.category ?? 'outdoor',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        // Aksi hapus tanaman
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.grey),
                      onPressed: () {
                        // Aksi edit tanaman (Milestone 11)
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 4 Kotak Info (Penyiraman, Cahaya, Suhu, Kelembapan)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoCard(Icons.water_drop_outlined, "Penyiraman", plant?.wateringSchedule ?? "Hari Ini"),
                _buildInfoCard(Icons.wb_sunny_outlined, "Cahaya", plant?.light ?? "Terang"),
                _buildInfoCard(Icons.thermostat, "Suhu", plant?.temperature ?? "18-25°C"),
                _buildInfoCard(Icons.air, "Kelembapan", plant?.humidity ?? "60-70%"),
              ],
            ),
            const SizedBox(height: 24),

            // Bagian Pengingat Perawatan
            const Text(
              "Pengingat Perawatan",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _buildReminderCard(Icons.check_circle, "Siram Tanaman", "Setiap 3 Hari"),
            const SizedBox(height: 8),
            _buildReminderCard(Icons.eco, "Beri Pupuk", "Setiap 2 Minggu"),
            const SizedBox(height: 8),
            _buildReminderCard(Icons.check_circle, "Bersihkan Daun", "Setiap Bulan"),
          ],
        ),
      ),
    );
  }

  // Widget pembantu untuk 4 kotak informasi kecil
  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Container(
      width: 75,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF2E7D32), size: 22),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Widget pembantu untuk card pengingat perawatan
  Widget _buildReminderCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2E7D32)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
