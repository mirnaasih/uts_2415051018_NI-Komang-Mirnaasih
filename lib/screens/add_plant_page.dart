import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddPlantPage extends StatefulWidget {
  const AddPlantPage({super.key});

  @override
  State<AddPlantPage> createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _wateringController = TextEditingController();
  final _lightController = TextEditingController();

  bool _isLoading = false;

  Future<void> _savePlantToDatabase() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final supabase = Supabase.instance.client;

        // Insert data ke tabel Supabase
        await supabase.from('saved_plants').insert({
          'name': _nameController.text,
          'category': _categoryController.text,
          'watering_schedule': _wateringController.text,
          'light': _lightController.text,
          'temperature': '20-25°C',
          'humidity': '70%',
          'image_url': '',
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil menambahkan tanaman ke database!')),
        );

        Navigator.pop(context, true); // Kembali dan beri sinyal sukses
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e'), backgroundColor: Colors.red),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
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
        title: const Text('Tambah Tanaman Baru', style: TextStyle(color: Colors.black87)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Tanaman', filled: true, fillColor: Colors.white),
                validator: (value) => value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Kategori (cth: Indoor/Outdoor)', filled: true, fillColor: Colors.white),
                validator: (value) => value == null || value.isEmpty ? 'Kategori wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _wateringController,
                decoration: const InputDecoration(labelText: 'Jadwal Penyiraman (cth: Setiap Hari)', filled: true, fillColor: Colors.white),
                validator: (value) => value == null || value.isEmpty ? 'Jadwal wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lightController,
                decoration: const InputDecoration(labelText: 'Kebutuhan Cahaya (cth: Terang)', filled: true, fillColor: Colors.white),
                validator: (value) => value == null || value.isEmpty ? 'Cahaya wajib diisi' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32)),
                  onPressed: _isLoading ? null : _savePlantToDatabase,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Simpan Tanaman', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}