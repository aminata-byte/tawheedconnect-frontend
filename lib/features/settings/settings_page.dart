import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _eventReminders = true;
  bool _newMemberNotif = true;
  String _selectedLanguage = "Français";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Paramètres"),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection("👤 COMPTE", [
            _buildListTile(
              icon: Icons.mosque,
              title: "Informations du Markaz",
              subtitle: "Nom, adresse, contact",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Modifier les informations du Markaz")),
                );
              },
            ),
            _buildListTile(
              icon: Icons.lock,
              title: "Mot de passe",
              subtitle: "Changer votre mot de passe",
              onTap: () {
                _showChangePasswordDialog();
              },
            ),
            _buildListTile(
              icon: Icons.payment,
              title: "Abonnement",
              subtitle: "Gérer votre abonnement",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("💳 Gestion de l'abonnement")),
                );
              },
            ),
          ]),

          const SizedBox(height: 24),

          _buildSection("🔔 NOTIFICATIONS", [
            _buildSwitchTile(
              icon: Icons.notifications,
              title: "Activer les notifications",
              subtitle: "Recevoir toutes les notifications",
              value: _notificationsEnabled,
              onChanged: (val) => setState(() => _notificationsEnabled = val),
            ),
            _buildSwitchTile(
              icon: Icons.event,
              title: "Rappels d'événements",
              subtitle: "Notifications avant les événements",
              value: _eventReminders,
              onChanged: (val) => setState(() => _eventReminders = val),
            ),
            _buildSwitchTile(
              icon: Icons.person_add,
              title: "Nouveaux membres",
              subtitle: "Notification quand quelqu'un s'abonne",
              value: _newMemberNotif,
              onChanged: (val) => setState(() => _newMemberNotif = val),
            ),
          ]),

          const SizedBox(height: 24),

          _buildSection("⚙️ PRÉFÉRENCES", [
            _buildDropdownTile(
              icon: Icons.language,
              title: "Langue",
              subtitle: _selectedLanguage,
              value: _selectedLanguage,
              items: const ["Français", "Arabe", "Wolof", "English"],
              onChanged: (val) => setState(() => _selectedLanguage = val!),
            ),
            _buildListTile(
              icon: Icons.location_on,
              title: "Localisation",
              subtitle: "Dakar, Sénégal",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("📍 Modifier la localisation")),
                );
              },
            ),
          ]),

          const SizedBox(height: 24),

          _buildSection("📚 CONTENU", [
            _buildListTile(
              icon: Icons.visibility,
              title: "Visibilité des contenus",
              subtitle: "Qui peut voir vos publications",
              onTap: () {
                _showVisibilityDialog();
              },
            ),
            _buildListTile(
              icon: Icons.block,
              title: "Contenus bloqués",
              subtitle: "Gérer les contenus signalés",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("🚫 Contenus bloqués")),
                );
              },
            ),
          ]),

          const SizedBox(height: 24),

          _buildSection("❓ ASSISTANCE", [
            _buildListTile(
              icon: Icons.help,
              title: "Guide d'utilisation",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("📖 Guide d'utilisation")),
                );
              },
            ),
            _buildListTile(
              icon: Icons.question_answer,
              title: "FAQ",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("❓ Questions fréquentes")),
                );
              },
            ),
            _buildListTile(
              icon: Icons.email,
              title: "Nous contacter",
              subtitle: "support@tawheedconnect.sn",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("📧 Contact support")),
                );
              },
            ),
            _buildListTile(
              icon: Icons.star,
              title: "Évaluer l'application",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("⭐ Merci pour votre avis !")),
                );
              },
            ),
          ]),

          const SizedBox(height: 24),

          _buildSection("⚖️ JURIDIQUE", [
            _buildListTile(
              icon: Icons.privacy_tip,
              title: "Politique de confidentialité",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("🔒 Politique de confidentialité")),
                );
              },
            ),
            _buildListTile(
              icon: Icons.description,
              title: "Conditions d'utilisation",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("📄 Conditions d'utilisation")),
                );
              },
            ),
          ]),

          const SizedBox(height: 24),

          _buildLogoutButton(),

          const SizedBox(height: 16),
          Center(
            child: Text(
              "Version 1.0.0 • Tawheed Connect",
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            _showLogoutDialog();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: const Icon(Icons.logout, color: Colors.white),
          label: const Text(
            "SE DÉCONNECTER",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Changer le mot de passe"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Ancien mot de passe",
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Nouveau mot de passe",
                prefixIcon: const Icon(Icons.lock_open),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("✅ Mot de passe modifié")),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text("Confirmer", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showVisibilityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Visibilité des contenus"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioListTile(
              title: const Text("Public"),
              subtitle: const Text("Tout le monde peut voir", style: TextStyle(fontSize: 12)),
              value: "public",
              groupValue: "public",
              onChanged: (val) {},
            ),
            RadioListTile(
              title: const Text("Membres uniquement"),
              subtitle: const Text("Seulement vos abonnés", style: TextStyle(fontSize: 12)),
              value: "members",
              groupValue: "public",
              onChanged: (val) {},
            ),
            RadioListTile(
              title: const Text("Privé"),
              subtitle: const Text("Personne ne peut voir", style: TextStyle(fontSize: 12)),
              value: "private",
              groupValue: "public",
              onChanged: (val) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("✅ Visibilité mise à jour")),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text("Enregistrer", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Déconnexion"),
        content: const Text("Voulez-vous vraiment vous déconnecter ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text("Déconnexion", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}