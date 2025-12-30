import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class VideoUploadPage extends StatefulWidget {
  const VideoUploadPage({Key? key}) : super(key: key);

  @override
  State<VideoUploadPage> createState() => _VideoUploadPageState();
}

class _VideoUploadPageState extends State<VideoUploadPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _youtubeLinkController = TextEditingController();

  String _videoSource = "local"; // "local" ou "youtube"
  String? _localVideoPath;
  String? _selectedCategory;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _youtubeLinkController.dispose();
    super.dispose();
  }

  void _pickLocalVideo() {
    // TODO: Implémenter avec image_picker ou file_picker
    setState(() => _localVideoPath = "video_placeholder.mp4");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("📹 Vidéo sélectionnée depuis le téléphone")),
    );
  }

  void _uploadVideo() {
    if (_formKey.currentState!.validate()) {
      if (_videoSource == "local" && _localVideoPath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Veuillez sélectionner une vidéo")),
        );
        return;
      }

      // TODO: Upload vers le serveur
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Vidéo publiée avec succès")),
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
        title: const Text("Publier une Vidéo"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("📹 SOURCE DE LA VIDÉO"),
              const SizedBox(height: 12),
              _buildVideoSourceSelector(),

              const SizedBox(height: 24),

              // Zone selon le type sélectionné
              if (_videoSource == "local") ...[
                _buildLocalVideoUpload(),
              ] else ...[
                _buildYouTubeLinkInput(),
              ],

              const SizedBox(height: 24),
              _buildSectionTitle("📝 INFORMATIONS"),
              const SizedBox(height: 12),

              _buildTextField(
                controller: _titleController,
                label: "Titre de la vidéo",
                hint: "Ex: Cours sur le Tawhid",
                icon: Icons.title,
                validator: (v) => v!.isEmpty ? "Titre requis" : null,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _descriptionController,
                label: "Description",
                hint: "Décrivez le contenu de la vidéo...",
                icon: Icons.description,
                maxLines: 4,
                validator: (v) => v!.isEmpty ? "Description requise" : null,
              ),
              const SizedBox(height: 16),

              _buildCategoryDropdown(),

              const SizedBox(height: 30),

              // Bouton de publication
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _uploadVideo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "📤 PUBLIER LA VIDÉO",
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

  Widget _buildVideoSourceSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => setState(() {
                _videoSource = "local";
                _youtubeLinkController.clear();
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _videoSource == "local" ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _videoSource == "local"
                      ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.phone_android,
                      color: _videoSource == "local" ? AppColors.primary : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Depuis le téléphone",
                      style: TextStyle(
                        fontWeight: _videoSource == "local" ? FontWeight.bold : FontWeight.normal,
                        color: _videoSource == "local" ? AppColors.primary : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: () => setState(() {
                _videoSource = "youtube";
                _localVideoPath = null;
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _videoSource == "youtube" ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _videoSource == "youtube"
                      ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_circle_fill,
                      color: _videoSource == "youtube" ? Colors.red : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Lien YouTube",
                      style: TextStyle(
                        fontWeight: _videoSource == "youtube" ? FontWeight.bold : FontWeight.normal,
                        color: _videoSource == "youtube" ? Colors.red : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocalVideoUpload() {
    return InkWell(
      onTap: _pickLocalVideo,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: _localVideoPath == null ? Colors.grey[200] : Colors.green[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _localVideoPath == null ? Colors.grey[400]! : Colors.green,
            width: 2,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _localVideoPath == null ? Icons.video_library : Icons.check_circle,
                size: 60,
                color: _localVideoPath == null ? Colors.grey[600] : Colors.green,
              ),
              const SizedBox(height: 12),
              Text(
                _localVideoPath == null ? "📹 Sélectionner une vidéo" : "✅ Vidéo sélectionnée",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _localVideoPath == null ? Colors.grey[700] : Colors.green,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _localVideoPath == null ? "MP4, MOV, AVI" : "Toucher pour changer",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYouTubeLinkInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          controller: _youtubeLinkController,
          label: "Lien YouTube",
          hint: "https://www.youtube.com/watch?v=...",
          icon: Icons.link,
          validator: (v) {
            if (v!.isEmpty) return "Lien YouTube requis";
            if (!v.contains("youtube.com") && !v.contains("youtu.be")) {
              return "Lien YouTube invalide";
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.info, size: 16, color: Colors.blue[700]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Collez le lien complet de votre vidéo YouTube",
                  style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                ),
              ),
            ],
          ),
        ),
      ],
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
        DropdownMenuItem(value: "coran", child: Text("📖 Coran & Tafsir")),
        DropdownMenuItem(value: "hadith", child: Text("📚 Hadith")),
        DropdownMenuItem(value: "fiqh", child: Text("🤲 Fiqh")),
        DropdownMenuItem(value: "conference", child: Text("🎤 Conférence")),
        DropdownMenuItem(value: "rappel", child: Text("💡 Rappel")),
        DropdownMenuItem(value: "autre", child: Text("📁 Autre")),
      ],
      onChanged: (value) => setState(() => _selectedCategory = value),
      validator: (v) => v == null ? "Catégorie requise" : null,
    );
  }
}