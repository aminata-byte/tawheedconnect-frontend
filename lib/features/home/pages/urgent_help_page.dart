import 'package:flutter/material.dart';
import 'dart:io';
import '../../../core/constants/colors.dart';
import '../../../core/data/app_data.dart';

class UrgentHelpPage extends StatefulWidget {
  const UrgentHelpPage({Key? key}) : super(key: key);

  @override
  State<UrgentHelpPage> createState() => _UrgentHelpPageState();
}

class _UrgentHelpPageState extends State<UrgentHelpPage> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs
  final TextEditingController _needController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  File? _selectedImage;

  @override
  void dispose() {
    _needController.dispose();
    _messageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white), // ✅ Retour flèche en blanc
        title: const Text(
          "Demande d'aide urgente",
          style: TextStyle(color: Colors.white), // ✅ Titre en blanc
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "ℹ️ Expliquez votre besoin. Vous pouvez ajouter une photo justificative si vous en avez une (facultatif).",
                  style: TextStyle(fontSize: 13, color: Colors.blueAccent),
                ),
              ),
              const SizedBox(height: 24),

              // Champ Besoin
              const Text("Quel est votre besoin ?", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildTextField(
                  _needController,
                  "Ex: Nom du malade, Construction de puits, etc."
              ),
              const SizedBox(height: 20),

              // Photo (Marquée comme facultative)
              const Row(
                children: [
                  Text("Photo justificative", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Text("(Facultatif)", style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic)),
                ],
              ),
              const SizedBox(height: 8),
              _buildPhotoPicker(),
              const SizedBox(height: 20),

              // Message détaillé
              const Text("Détails ou explications", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              _buildTextField(_messageController, "Décrivez la situation ici...", maxLines: 3),
              const SizedBox(height: 20),

              // Téléphone
              const Text("Numéro de téléphone de contact", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              _buildTextField(_phoneController, "7X XXX XX XX", isPhone: true),
              const SizedBox(height: 30),

              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPicker() {
    return InkWell(
      onTap: () {
        // Logique pour ouvrir la galerie/caméra
      },
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: _selectedImage == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined, color: Colors.grey[400], size: 45),
            const SizedBox(height: 8),
            const Text("Ajouter une photo", style: TextStyle(color: Colors.grey)),
          ],
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(_selectedImage!, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool isPhone = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      validator: (val) => val!.isEmpty ? "Ce champ est requis" : null,
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            addUrgentRequest(
              memberName: _needController.text,
              phone: _phoneController.text,
              message: _messageController.text,
            );

            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Demande transmise aux administrateurs", style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.green,
                )
            );
            Navigator.pop(context);
          }
        },
        child: const Text(
            "ENVOYER LA DEMANDE",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold) // ✅ Texte bouton en blanc
        ),
      ),
    );
  }
}