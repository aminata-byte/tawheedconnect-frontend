import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/colors.dart';
import '../../core/services/api_service.dart';

class EventAddPage extends StatefulWidget {
  const EventAddPage({Key? key}) : super(key: key);

  @override
  State<EventAddPage> createState() => _EventAddPageState();
}

class _EventAddPageState extends State<EventAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _speakersController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  TimeOfDay? _selectedEndTime;
  String? _imagePath;
  bool _isPublishing = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _speakersController.dispose();
    super.dispose();
  }

  // --- LOGIQUE ---

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _imagePath = image.path);
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _selectTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) _selectedTime = picked;
        else _selectedEndTime = picked;
      });
    }
  }

  void _saveEvent() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez sélectionner la date et l'heure de début")),
      );
      return;
    }

    setState(() => _isPublishing = true);

    try {
      // Formatage pour Laravel (YYYY-MM-DD et HH:mm)
      String formattedDate = "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
      String startTime = "${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}";
      String? endTime = _selectedEndTime != null
          ? "${_selectedEndTime!.hour.toString().padLeft(2, '0')}:${_selectedEndTime!.minute.toString().padLeft(2, '0')}"
          : null;

      final result = await ApiService().addEvent(
        title: _titleController.text,
        description: _descriptionController.text,
        location: _locationController.text,
        date: formattedDate,
        startTime: startTime,
        endTime: endTime,
        speakers: _speakersController.text,
        imagePath: _imagePath,
      );

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Événement publié avec succès")),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Erreur: ${e.toString()}")),
      );
    } finally {
      setState(() => _isPublishing = false);
    }
  }

  // --- INTERFACE ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Créer un Événement"),
        elevation: 0,
      ),
      body: _isPublishing
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("📸 IMAGE DE COUVERTURE"),
              const SizedBox(height: 12),
              _buildImagePicker(),

              const SizedBox(height: 24),
              _buildSectionTitle("📝 DÉTAILS"),
              _buildTextField(
                controller: _titleController,
                label: "Titre de l'événement",
                icon: Icons.title,
                validator: (v) => v!.isEmpty ? "Titre requis" : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: "Description",
                icon: Icons.description,
                maxLines: 3,
                validator: (v) => v!.isEmpty ? "Description requise" : null,
              ),

              const SizedBox(height: 24),
              _buildSectionTitle("📅 DATE & HORAIRES"),
              _buildDateTimeSelectors(),

              const SizedBox(height: 24),
              _buildSectionTitle("📍 LIEU"),
              _buildTextField(
                controller: _locationController,
                label: "Adresse (ex: Grande Mosquée Dakar)",
                icon: Icons.location_on,
                validator: (v) => v!.isEmpty ? "Lieu requis" : null,
              ),

              const SizedBox(height: 24),
              _buildSectionTitle("👨‍🏫 INTERVENANTS"),
              _buildTextField(
                controller: _speakersController,
                label: "Noms (séparés par des virgules)",
                icon: Icons.person,
                validator: (v) => v!.isEmpty ? "Intervenant requis" : null,
              ),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _saveEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("✅ PUBLIER L'ÉVÉNEMENT",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }

  Widget _buildImagePicker() {
    return InkWell(
      onTap: _pickImage,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: _imagePath == null
            ? const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, size: 50, color: Colors.grey),
            Text("Cliquez pour ajouter une affiche", style: TextStyle(color: Colors.grey)),
          ],
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(File(_imagePath!), fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildDateTimeSelectors() {
    return Column(
      children: [
        ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          leading: Icon(Icons.calendar_month, color: AppColors.primary),
          title: Text(_selectedDate == null ? "Choisir une date" : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"),
          onTap: _selectDate,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                title: Text(_selectedTime == null ? "Début" : _selectedTime!.format(context)),
                onTap: () => _selectTime(true),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                title: Text(_selectedEndTime == null ? "Fin" : _selectedEndTime!.format(context)),
                onTap: () => _selectTime(false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, int maxLines = 1, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.primary),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}