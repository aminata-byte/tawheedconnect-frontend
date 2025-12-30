import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/data/app_data.dart';
import '../audio/audio_list_page.dart';
import '../audio/audio_dars_page.dart';
import '../video/video_upload_page.dart';
import '../video/video_list_page.dart';
import '../settings/settings_page.dart';
import '../events/event_add_page.dart';
import '../events/event_list_page.dart';
import '../oustaze/oustaze_add_page.dart';
import '../oustaze/oustaze_list_page.dart';
import '../auth/auth_screen.dart';
import '../stats/abonnes_page.dart';
import '../stats/vues_page.dart';
import '../home/pages/manage_admins_page.dart';
import '../home/pages/admin_urgent_requests_page.dart';
import '../home/pages/publish_quest_page.dart';
import 'pages/admin_quest_list_page.dart';
import '../../../core/services/api_service.dart';

class AssociationDashboard extends StatefulWidget {
  const AssociationDashboard({Key? key}) : super(key: key);

  @override
  State<AssociationDashboard> createState() => _AssociationDashboardState();
}

class _AssociationDashboardState extends State<AssociationDashboard> {
  Map<String, dynamic>? userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final api = ApiService();
      final response = await api.me();

      if (response['success'] == true) {
        setState(() {
          userData = response['data']['user'];
          _isLoading = false;
        });

        // Debug: afficher les données récupérées
        print('✅ Données utilisateur: $userData');
        print('📝 Nom association: ${userData?['first_name']}');
      }
    } catch (e) {
      print('❌ Erreur: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur chargement profil : $e'), backgroundColor: Colors.red),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // CORRECTION: Récupération correcte du nom de l'association
    final String associationName = userData?['first_name']?.toString() ?? "Association";
    final String? logoUrl = userData?['photo'];

    // Debug dans la console
    print('🏢 Nom affiché: $associationName');

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text("Gestion Markaz", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          _buildUrgentBadge(),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == "settings") {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
              } else if (value == "logout") {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const AuthScreen()),
                      (route) => false,
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: "settings", child: Text("Paramètres")),
              PopupMenuItem(value: "logout", child: Text("Déconnexion")),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMarkazHeader(associationName, logoUrl),
            const SizedBox(height: 25),
            const Text("Aperçu de la communauté", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildStatsSection(),
            const SizedBox(height: 30),
            const Text("Contenus & Gestion", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildActionGrid(),
            const SizedBox(height: 40),
            const Center(child: Text("Aucun contenu publié", style: TextStyle(color: Colors.grey))),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () => _showAddOptions(context, associationName),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildMarkazHeader(String name, String? logoUrl) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            backgroundImage: logoUrl != null && logoUrl.isNotEmpty
                ? NetworkImage('http://127.0.0.1:8000/storage/$logoUrl')
                : null,
            child: logoUrl == null || logoUrl.isEmpty
                ? Icon(Icons.mosque, color: AppColors.primary)
                : null,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Affichage du vrai nom avec style
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      userData?['city']?.toString() ?? "Localisation active",
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.verified, color: Colors.blue),
        ],
      ),
    );
  }

  Widget _buildUrgentBadge() {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminUrgentRequestsPage())).then((_) => setState(() {}));
          },
        ),
        if (getPendingRequestsCount() > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                '${getPendingRequestsCount()}',
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Wrap(
      spacing: 15,
      runSpacing: 10,
      children: [
        _statCard("Abonnés", "0", Icons.people, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AbonnesPage()))),
        _statCard("Vues", "0", Icons.remove_red_eye, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VuesPage()))),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.42,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
            Text(label, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        _actionItem("Audios", Icons.mic, Colors.orange, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AudioListPage()))),
        _actionItem("Vidéos", Icons.play_circle_fill, Colors.red, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VideoListPage()))),
        _actionItem("Events", Icons.event, Colors.blue, () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventListPage()))),
        _actionItem("Oustazes", Icons.school, Colors.teal, () => Navigator.push(context, MaterialPageRoute(builder: (_) => OustazeListPage()))),
        _actionItem("Quêtes", Icons.volunteer_activism, Colors.green, () => Navigator.push(context, MaterialPageRoute(builder: (_) => AdminQuestListPage()))),
      ],
    );
  }

  Widget _actionItem(String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 6),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _showAddOptions(BuildContext context, String associationName) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          _modalTile(Icons.mic, Colors.orange, "Ajouter un Cours Audio", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AudioDarsPage()))),
          _modalTile(Icons.play_circle_fill, Colors.red, "Ajouter une Vidéo", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VideoUploadPage()))),
          _modalTile(Icons.school, Colors.teal, "Ajouter un Oustaze", () => Navigator.push(context, MaterialPageRoute(builder: (_) => OustazeAddPage()))),
          _modalTile(Icons.event, Colors.blue, "Ajouter un Événement", () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventAddPage()))),
          _modalTile(Icons.admin_panel_settings, Colors.deepPurple, "Ajouter un Admin", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageAdminsPage()))),
          _modalTile(Icons.volunteer_activism, Colors.green, "Publier une Quête", () => Navigator.push(context, MaterialPageRoute(builder: (_) => PublishQuestPage(associationName: associationName)))),
        ]),
      ),
    );
  }

  Widget _modalTile(IconData icon, Color color, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}