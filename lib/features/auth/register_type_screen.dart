import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import 'register_member_form.dart';
import 'register_association_form.dart'; // Ajout de l'import Association

class RegisterTypeScreen extends StatelessWidget {
  const RegisterTypeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Type de compte"),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Rejoignez Tawheed Connect",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Choisissez le profil qui vous correspond pour continuer l'inscription.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // --- CARTE MEMBRE (1000F) ---
            _buildSelectionCard(
              context,
              title: "Membre",
              price: "1 000 F CFA",
              description: "Accès aux événements, Q&A et carte interactive.",
              icon: Icons.person_add_alt_1,
              color: Colors.orange,
              onTap: () {
                // LIAISON VERS LE FORMULAIRE MEMBRE
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterMemberForm(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // --- CARTE ASSOCIATION (5000F) ---
            _buildSelectionCard(
              context,
              title: "Association",
              price: "5 000 F CFA",
              description: "Publiez des événements et gérez votre communauté.",
              icon: Icons.mosque,
              color: AppColors.primary,
              onTap: () {
                // LIAISON VERS LE FORMULAIRE ASSOCIATION
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterAssociationForm(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget réutilisable pour les cartes de sélection
  Widget _buildSelectionCard(
      BuildContext context, {
        required String title,
        required String price,
        required String description,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Frais : $price",
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}