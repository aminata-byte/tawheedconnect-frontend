import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/services/api_service.dart';

class OustazeAddPage extends StatefulWidget {
  final Map<String, dynamic>? oustaze;

  const OustazeAddPage({Key? key, this.oustaze}) : super(key: key);

  @override
  State<OustazeAddPage> createState() => _OustazeAddPageState();
}

class _OustazeAddPageState extends State<OustazeAddPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _specialityController;
  late TextEditingController _phoneController;

  bool get isEditing => widget.oustaze != null;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      final oustaze = widget.oustaze!;
      // Gère les deux formats : français (nom_complet) et anglais (name)
      _nameController = TextEditingController(
          text: oustaze['nom_complet'] ?? oustaze['name'] ?? ''
      );
      _specialityController = TextEditingController(
          text: oustaze['specialites'] ?? oustaze['speciality'] ?? ''
      );
      _phoneController = TextEditingController(
          text: oustaze['telephone'] ?? oustaze['phone'] ?? ''
      );
    } else {
      _nameController = TextEditingController();
      _specialityController = TextEditingController();
      _phoneController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specialityController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveOustaze() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Afficher le loader
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
              child: CircularProgressIndicator(color: Colors.orange)
          ),
        );

        Map<String, dynamic> result;

        if (isEditing) {
          // APPEL API MODIFICATION
          result = await ApiService().updateOustaze(
            id: widget.oustaze!['id'],
            name: _nameController.text,
            speciality: _specialityController.text,
            phone: _phoneController.text,
          );
        } else {
          // APPEL API AJOUT
          result = await ApiService().addOustaze(
            name: _nameController.text,
            speciality: _specialityController.text,
            phone: _phoneController.text,
          );
        }

        if (!mounted) return;
        Navigator.pop(context); // Fermer le loader

        if (result['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isEditing ? "✅ Oustaze mis à jour" : "✅ Oustaze ajouté"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true); // Retour avec succès
        }
      } catch (e) {
        if (!mounted) return;
        Navigator.pop(context); // Fermer le loader
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Erreur : ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(isEditing ? "Modifier l'Oustaze" : "Ajouter un Oustaze"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: _nameController,
                label: "Nom complet",
                icon: Icons.person,
                validator: (v) => v!.isEmpty ? "Nom requis" : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _specialityController,
                label: "Spécialité(s)",
                icon: Icons.book,
                hint: "Ex: Fiqh, Tafsir",
                validator: (v) => v!.isEmpty ? "Spécialité requise" : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _phoneController,
                label: "Téléphone",
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (v) => v!.isEmpty ? "Téléphone requis" : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveOustaze,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                    ),
                  ),
                  child: Text(
                    isEditing ? "METTRE À JOUR" : "ENREGISTRER",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                ),
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
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
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
            borderSide: BorderSide.none
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!)
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary, width: 2)
        ),
      ),
    );
  }
}