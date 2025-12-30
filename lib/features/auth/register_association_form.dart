import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/colors.dart';
import '../home/association_dashboard.dart';
import '../../../core/services/api_service.dart';

class RegisterAssociationForm extends StatefulWidget {
  const RegisterAssociationForm({Key? key}) : super(key: key);

  @override
  State<RegisterAssociationForm> createState() => _RegisterAssociationFormState();
}

class _RegisterAssociationFormState extends State<RegisterAssociationForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  File? _logoFile;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      setState(() {
        _logoFile = File(pickedFile.path);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Logo sélectionné avec succès !")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Inscription Association"),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Finalisez votre inscription",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Ajoutez les informations officielles de votre association.",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // === LOGO (OPTIONNEL) ===
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _logoFile == null ? AppColors.primary : Colors.green,
                              width: 3,
                            ),
                            image: _logoFile != null
                                ? DecorationImage(
                              image: FileImage(_logoFile!),
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),
                          child: _logoFile == null
                              ? Icon(
                            Icons.mosque,
                            size: 50,
                            color: AppColors.primary,
                          )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: _pickLogo,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _logoFile == null ? "Ajouter le logo (optionnel)" : "Logo ajouté ✓",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _logoFile == null ? Colors.grey : Colors.green,
                      ),
                    ),
                    const Text(
                      "Vous pourrez l'ajouter plus tard",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // === NOM ASSOCIATION ===
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Nom de l'association",
                  prefixIcon: const Icon(Icons.account_balance),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value!.trim().isEmpty ? "Champ obligatoire" : null,
              ),
              const SizedBox(height: 20),

              // === VILLE ===
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: "Ville / Quartier",
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value!.trim().isEmpty ? "Champ obligatoire" : null,
              ),
              const SizedBox(height: 20),

              // === NUMÉRO ===
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Numéro de l'association",
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value!.trim().isEmpty) return "Numéro obligatoire";
                  if (value.length < 9) return "Numéro invalide";
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // === MOT DE PASSE ===
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Mot de passe",
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value!.isEmpty) return "Mot de passe obligatoire";
                  if (value.length < 6) return "Minimum 6 caractères";
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // === CONFIRMER MOT DE PASSE ===
              TextFormField(
                controller: _passwordConfirmController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Confirmer le mot de passe",
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value!.isEmpty) return "Confirmation obligatoire";
                  if (value != _passwordController.text) return "Les mots de passe ne correspondent pas";
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // === PAIEMENT ===
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline, color: Colors.orange),
                    SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        "Frais d'activation Association",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text("5000F", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange)),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // === BOUTON ===
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  onPressed: _isLoading ? null : _processRegistration,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "ACTIVER ET PAYER →",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // === INSCRIPTION AVEC LES BONS CHAMPS ===
  Future<void> _processRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final api = ApiService();

    try {
      // Préparer le numéro au format international
      String formattedPhone = '221${_phoneController.text.trim().replaceAll(' ', '')}';

      print('📤 Inscription en cours...');
      print('📝 Nom association: ${_nameController.text.trim()}');
      print('📞 Téléphone: $formattedPhone');
      print('📍 Ville: ${_cityController.text.trim()}');

      // IMPORTANT : Envoyer les bons champs selon le backend
      final response = await api.registerAssociation(
        associationName: _nameController.text.trim(),
        phone: formattedPhone,
        password: _passwordController.text,
        city: _cityController.text.trim(),
      );

      if (!mounted) return;

      print('✅ Réponse reçue: $response');

      // IMPORTANT : Sauvegarder le token reçu
      if (response['data'] != null && response['data']['token'] != null) {
        final token = response['data']['token'];
        api.setToken(token);
        print('🔐 Token sauvegardé: ${token.substring(0, 20)}...');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? 'Inscription réussie !'),
          backgroundColor: Colors.green,
        ),
      );

      // Redirection vers le dashboard
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AssociationDashboard()),
            (route) => false,
      );
    } catch (e) {
      print('❌ Erreur inscription: $e');

      if (!mounted) return;

      // Extraire le message d'erreur
      String errorMessage = 'Erreur lors de l\'inscription';

      if (e.toString().contains('Exception:')) {
        errorMessage = e.toString().replaceAll('Exception:', '').trim();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}