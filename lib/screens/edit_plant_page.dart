import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/plant.dart';

class EditPlantPage extends StatefulWidget {
  final Plant plant;

  const EditPlantPage({super.key, required this.plant});

  @override
  State<EditPlantPage> createState() => _EditPlantPageState();
}

class _EditPlantPageState extends State<EditPlantPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _wateringController;
  late TextEditingController _lightController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.plant.name);
    _categoryController = TextEditingController(text: widget.plant.category);
    _wateringController = TextEditingController(text: widget.plant.wateringSchedule);
    _lightController = TextEditingController(text: widget.plant.light);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _wateringController.dispose();
    _lightController.dispose();
    super.dispose();
  }

  Future<void> _updatePlantInDatabase() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final supabase = Supabase.instance.client;

        await supabase.from('saved_plants').update({
          'name': _nameController.text,
          'category': _categoryController.text,
          'watering_schedule': _wateringController.text,
          'light': _lightController.text,
        }).eq('id', widget.plant.id);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil memperbarui data tanaman!')),
        );

        Navigator.pop(context, true); 
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui: $e'), backgroundColor: Colors.red),
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
        title: const Text('Edit Tanaman', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
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
                decoration: const InputDecoration(labelText: 'Jadwal Penyiraman', filled: true, fillColor: Colors.white),
                validator: (value) => value == null || value.isEmpty ? 'Jadwal wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lightController,
                decoration: const InputDecoration(labelText: 'Kebutuhan Cahaya', filled: true, fillColor: Colors.white),
                validator: (value) => value == null || value.isEmpty ? 'Cahaya wajib diisi' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32)),
                  onPressed: _isLoading ? null : _updatePlantInDatabase,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Simpan Perubahan', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}