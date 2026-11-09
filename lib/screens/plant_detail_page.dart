import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/plant.dart';
import 'edit_plant_page.dart';
import '../repositories/plant_repository.dart';

class PlantDetailPage extends StatefulWidget {
  final Plant? plant;

  const PlantDetailPage({super.key, this.plant});

  @override
  State<PlantDetailPage> createState() => _PlantDetailPageState();
}

class _PlantDetailPageState extends State<PlantDetailPage> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.plant?.isFavorite ?? false;
  }

  Future<void> _toggleFavorite() async {
    if (widget.plant != null) {
      try {
        final supabase = Supabase.instance.client;
        setState(() {
          _isFavorite = !_isFavorite;
          widget.plant!.isFavorite = _isFavorite;
        });

        // Update status is_favorite di Supabase
        await supabase
            .from('saved_plants')
            .update({'is_favorite': _isFavorite})
            .eq('id', widget.plant!.id);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isFavorite ? 'Ditambahkan ke Favorit' : 'Dihapus dari Favorit'),
            duration: const Duration(seconds: 1),
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui favorit: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context, true),
        ),
        title: const Text(
          'Detail Tanaman',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          // Tombol Ikon Hati (Favorit) yang bisa berubah merah
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.black87,
            ),
            onPressed: _toggleFavorite,
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
                child: widget.plant?.imageUrl != null && widget.plant!.imageUrl.isNotEmpty
                    ? Image.network(
                        widget.plant!.imageUrl,
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
                      widget.plant?.name ?? 'Anggrek',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.plant?.category ?? 'outdoor',
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
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Hapus Tanaman'),
                            content: Text('Apakah Anda yakin ingin menghapus ${widget.plant?.name ?? 'tanaman ini'}?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true && widget.plant != null) {
                          try {
                            final repository = PlantRepository();
                            await repository.deletePlant(widget.plant!.id);

                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Tanaman berhasil dihapus dari database!')),
                            );

                            Navigator.pop(context, true);
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Gagal menghapus: $e'), backgroundColor: Colors.red),
                            );
                          }
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.grey),
                      onPressed: () async {
                        if (widget.plant != null) {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPlantPage(plant: widget.plant!),
                            ),
                          );
                          if (result == true) {
                            Navigator.pop(context, true);
                          }
                        }
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
                _buildInfoCard(Icons.water_drop_outlined, "Penyiraman", widget.plant?.wateringSchedule ?? "Hari Ini"),
                _buildInfoCard(Icons.wb_sunny_outlined, "Cahaya", widget.plant?.light ?? "Terang"),
                _buildInfoCard(Icons.thermostat, "Suhu", widget.plant?.temperature ?? "18-25°C"),
                _buildInfoCard(Icons.air, "Kelembapan", widget.plant?.humidity ?? "60-70%"),
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