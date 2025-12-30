import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class AudioDarsPage extends StatefulWidget {
  const AudioDarsPage({Key? key}) : super(key: key);

  @override
  State<AudioDarsPage> createState() => _AudioDarsPageState();
}

class _AudioDarsPageState extends State<AudioDarsPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _speakerController = TextEditingController();

  String? _audioPath;
  String? _selectedCategory;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _speakerController.dispose();
    super.dispose();
  }

  void _pickAudio() {
    // TODO: Implémenter avec file_picker
    setState(() => _audioPath = "audio_placeholder.mp3");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("🎵 Fichier audio sélectionné")),
    );
  }

  void _saveAudio() {
    if (_formKey.currentState!.validate()) {
      if (_audioPath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Veuillez sélectionner un fichier audio")),
        );
        return;
      }

      // TODO: Sauvegarder dans la base de données
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Cours audio ajouté avec succès")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Ajouter un Cours Audio"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("🎵 FICHIER AUDIO"),
              const SizedBox(height: 12),
              _buildAudioPicker(),

              const SizedBox(height: 24),
              _buildSectionTitle("📝 INFORMATIONS"),
              const SizedBox(height: 12),

              _buildTextField(
                controller: _titleController,
                label: "Titre du cours",
                hint: "Ex: Tafsir Sourate Al-Fatiha",
                icon: Icons.title,
                validator: (v) => v!.isEmpty ? "Titre requis" : null,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _descriptionController,
                label: "Description",
                hint: "Décrivez le contenu du cours...",
                icon: Icons.description,
                maxLines: 4,
                validator: (v) => v!.isEmpty ? "Description requise" : null,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _speakerController,
                label: "Intervenant / Oustaze",
                hint: "Ex: Cheikh Omar Diallo",
                icon: Icons.person,
                validator: (v) => v!.isEmpty ? "Intervenant requis" : null,
              ),
              const SizedBox(height: 16),

              _buildCategoryDropdown(),

              const SizedBox(height: 30),

              // Bouton de publication
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveAudio,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "📤 PUBLIER LE COURS",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildAudioPicker() {
    return InkWell(
      onTap: _pickAudio,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: _audioPath == null ? Colors.orange.withOpacity(0.1) : Colors.green[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _audioPath == null ? Colors.orange.withOpacity(0.3) : Colors.green,
            width: 2,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _audioPath == null ? Icons.mic : Icons.check_circle,
                size: 60,
                color: _audioPath == null ? Colors.orange : Colors.green,
              ),
              const SizedBox(height: 12),
              Text(
                _audioPath == null ? "🎤 Sélectionner un fichier audio" : "✅ Audio sélectionné",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _audioPath == null ? Colors.orange : Colors.green,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _audioPath == null ? "MP3, WAV, M4A" : "Toucher pour changer",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: InputDecoration(
        labelText: "Catégorie",
        prefixIcon: Icon(Icons.category, color: AppColors.primary),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      items: const [
        DropdownMenuItem(value: "tafsir", child: Text("📖 Tafsir")),
        DropdownMenuItem(value: "hadith", child: Text("📚 Hadith")),
        DropdownMenuItem(value: "fiqh", child: Text("🤲 Fiqh")),
        DropdownMenuItem(value: "rappel", child: Text("🎙️ Rappel")),
        DropdownMenuItem(value: "autre", child: Text("📁 Autre")),
      ],
      onChanged: (value) => setState(() => _selectedCategory = value),
      validator: (v) => v == null ? "Catégorie requise" : null,
    );
  }
}