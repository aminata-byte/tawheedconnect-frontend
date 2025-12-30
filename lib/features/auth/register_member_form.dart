import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../home/member_dashboard.dart';
import '../../../core/services/api_service.dart'; // ← Déjà présent

class RegisterMemberForm extends StatefulWidget {
  const RegisterMemberForm({Key? key}) : super(key: key);

  @override
  State<RegisterMemberForm> createState() => _RegisterMemberFormState();
}

class _RegisterMemberFormState extends State<RegisterMemberForm> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Inscription Membre"),
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
                "Finalisez votre profil",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Ces informations apparaîtront sur votre espace membre.",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // --- CHAMP NOM COMPLET ---
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Prénom et Nom",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value!.trim().isEmpty ? "Champ obligatoire" : null,
              ),
              const SizedBox(height: 20),

              // --- CHAMP VILLE ---
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: "Ville / Quartier",
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  hintText: "Ex: Dakar, Grand Yoff",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value!.trim().isEmpty ? "Champ obligatoire" : null,
              ),
              const SizedBox(height: 20),

              // --- CHAMP NUMÉRO ---
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Numéro de téléphone",
                  prefixIcon: const Icon(Icons.phone),
                  hintText: "Ex: 77 123 45 67",
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

              // --- CHAMP MOT DE PASSE (bien visible maintenant) ---
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
              const SizedBox(height: 30),

              // --- RÉSUMÉ DU PAIEMENT ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.orange),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Frais d'activation",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Paiement unique de 1 000 F CFA pour accéder à tous les services.",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      "1000F",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // --- BOUTON DE VALIDATION (appelle maintenant l'API) ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  onPressed: _isLoading ? null : _submitRegistration,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "S'INSCRIRE ET PAYER →",
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

  // === INSCRIPTION VERS L'API LARAVEL ===
  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final api = ApiService();

    // Séparer prénom et nom
    final fullName = _nameController.text.trim();
    final parts = fullName.split(' ');
    final firstName = parts.isNotEmpty ? parts.first : '';
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    try {
      final response = await api.register(
        firstName: firstName,
        lastName: lastName,
        phone: '221${_phoneController.text.trim().replaceAll(' ', '')}',
        password: _passwordController.text,
        role: 'member',
        city: _cityController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? 'Inscription réussie ! 🎉'),
          backgroundColor: Colors.green,
        ),
      );

      // Redirection vers le dashboard après succès
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MemberDashboard()),
            (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur : $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}