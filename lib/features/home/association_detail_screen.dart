import 'package:flutter/material.dart';
import 'pages/manage_admins_page.dart'; // ← Import ajouté

class AssociationDetailScreen extends StatelessWidget {
  final String name;
  const AssociationDetailScreen({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header avec image et bouton retour
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFF004D40),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              background: Image.network(
                "https://images.unsplash.com/photo-1590076175574-4b95329307bc?q=80&w=800",
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.3),
                colorBlendMode: BlendMode.darken,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildActionButtons(context), // ← context ajouté ici
                  const SizedBox(height: 25),
                  const Text("Actualités & Événements", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  _buildNewsList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Boutons S'abonner / Faire un don + Gérer les admins
  Widget _buildActionButtons(BuildContext context) { // ← context ajouté en paramètre
    return Column( // ← Row changé en Column pour ajouter le nouveau bouton
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_alert_rounded),
                label: const Text("S'abonner"),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF004D40), foregroundColor: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.favorite, color: Colors.red),
                label: const Text("Soutenir"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10), // ← Espacement
        // ↓↓↓ NOUVEAU BOUTON AJOUTÉ ICI ↓↓↓
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManageAdminsPage()),
              );
            },
            icon: const Icon(Icons.admin_panel_settings),
            label: const Text("Gérer les admins"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  // Liste des actualités (Dourous, Conférences)
  Widget _buildNewsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ListTile(
                leading: CircleAvatar(backgroundColor: Colors.orange, child: Icon(Icons.mic, color: Colors.white)),
                title: Text("Conférence sur le Tawheed", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Par Cheikh Moussa - Dimanche prochain"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "Rendez-vous après la prière de Asr au Markaz pour un dars exceptionnel sur les piliers de la foi.",
                  style: TextStyle(color: Colors.grey[700], fontSize: 13),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey),
                    SizedBox(width: 5),
                    Text("📍 Dakar, Point E", style: TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}