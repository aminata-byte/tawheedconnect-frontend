import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class OustazeAddPage extends StatefulWidget {
  const OustazeAddPage({Key? key}) : super(key: key);

  @override
  State<OustazeAddPage> createState() => _OustazeAddPageState();
}

class _OustazeAddPageState extends State<OustazeAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _specialityController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _specialityController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveOustaze() {
    if (_formKey.currentState!.validate()) {
      // TODO: Sauvegarder l'oustaze dans la base de données
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Oustaze ajouté avec succès")),
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
        title: const Text("Ajouter un Oustaze"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              _buildTextField(
                controller: _nameController,
                label: "Nom complet",
                icon: Icons.person,
                hint: "Ex: Cheikh Omar Diallo",
                validator: (v) => v!.isEmpty ? "Nom requis" : null,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _specialityController,
                label: "Spécialité",
                icon: Icons.book,
                hint: "Ex: Tafsir, Fiqh, Hadith",
                validator: (v) => v!.isEmpty ? "Spécialité requise" : null,
              ),
              const SizedBox(height: 8),
              const Text(
                "💡 Séparez les spécialités par des virgules",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),

              const SizedBox(height: 16),

              _buildTextField(
                controller: _phoneController,
                label: "Téléphone",
                icon: Icons.phone,
                hint: "+221 77 123 45 67",
                keyboardType: TextInputType.phone,
                validator: (v) => v!.isEmpty ? "Téléphone requis" : null,
              ),

              const SizedBox(height: 30),

              // Bouton d'enregistrement
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveOustaze,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "ENREGISTRER L'OUSTAZE",
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
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
}