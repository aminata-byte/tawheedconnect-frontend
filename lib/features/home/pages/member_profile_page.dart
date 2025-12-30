import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
// ✅ Importations nécessaires pour les redirections
import '../../auth/auth_screen.dart';
import 'notifications_page.dart';
import 'edit_profile_page.dart';
import 'change_password_page.dart';
class MemberProfilePage extends StatelessWidget {
  const MemberProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 👉 Données dynamiques
    const String nomPersonne = "Aminata Diane";
    const String numeroTelephone = "+221 77 123 45 67";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        // ✅ Titre et bouton retour en blanc
        title: const Text("Mon profil", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar avec couleur Orange comme sur ton design
            const CircleAvatar(
              radius: 45,
              backgroundColor: Colors.orange,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              nomPersonne,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            Text(
              numeroTelephone,
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            // ================= OPTIONS DU PROFIL =================

            _buildProfileItem(
              icon: Icons.edit,
              title: "Modifier le profil",
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // ✅ Retire 'const' ici
                    builder: (context) => EditProfilePage(),
                  ),
                );
              },
            ),



// 2. Modifie l'item dans ton Column :
      _buildProfileItem(
      icon: Icons.lock,
        title: "Changer le mot de passe",
        color: Colors.green,
        onTap: () {
          // ✅ Navigation vers la page de changement de mot de passe
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
          );
        },
      ),

            _buildProfileItem(
              icon: Icons.notifications,
              title: "Notifications",
              color: Colors.green,
              onTap: () {
                // ✅ Redirection vers ta page de notifications
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationsPage()),
                );
              },
            ),

            const Spacer(),

            // ================= BOUTON DÉCONNEXION =================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // ✅ Navigator.pushAndRemoveUntil vide l'historique de navigation
                  // pour empêcher le retour en arrière après déconnexion.
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthScreen()),
                        (route) => false,
                  );
                },
                child: const Text(
                  "Se déconnecter",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Widget réutilisable pour les lignes du menu
  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontSize: 15)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}