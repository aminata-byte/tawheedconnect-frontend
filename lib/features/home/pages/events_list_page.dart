import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import 'map_page.dart';

class EventsListPage extends StatefulWidget {
  const EventsListPage({Key? key}) : super(key: key);

  @override
  State<EventsListPage> createState() => _EventsListPageState();
}

class _EventsListPageState extends State<EventsListPage> {
  String activeFilter = "Cette semaine"; // Par défaut

  void _setFilter(String filter) {
    setState(() {
      activeFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool showAllEvents = activeFilter == "Tous";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Événements"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Recherche en développement")),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Autres filtres en développement")),
              );
            },
          ),
        ],
        elevation: 0,
      ),
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // ==================== BOUTONS FILTRES ====================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _setFilter("Cette semaine"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: activeFilter == "Cette semaine" ? Colors.orange : Colors.grey[300],
                      foregroundColor: activeFilter == "Cette semaine" ? Colors.white : Colors.black87,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text("Cette semaine", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _setFilter("Tous"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: activeFilter == "Tous" ? Colors.orange : Colors.grey[300],
                      foregroundColor: activeFilter == "Tous" ? Colors.white : Colors.black87,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text("Tous", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),

          // ==================== LISTE DES ÉVÉNEMENTS ====================
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (showAllEvents) ...[
                  const Text("NOVEMBRE 2025", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 10),
                  _buildEventCard(
                    title: "Séminaire sur la prière",
                    description: "Importance de la prière en congrégation",
                    time: "18:00 - 20:00",
                    location: "Mosquée de la Divinité",
                    association: "Association Nur",
                    participants: "120 inscrits",
                  ),
                  const SizedBox(height: 20),
                ],

                const Text("VENDREDI 20 DÉCEMBRE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _buildEventCard(
                  title: "Conférence sur le Tawhid",
                  description: "Le Tawhid dans l'Islam",
                  time: "15:00 - 17:00",
                  location: "Grande Mosquée, Dakar",
                  association: "Association Al-Iman",
                  participants: "150 inscrits",
                ),

                const SizedBox(height: 20),
                const Text("SAMEDI 21 DÉCEMBRE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _buildEventCard(
                  title: "Cours de Coran",
                  description: "Tajwid pour débutants",
                  time: "10:00 - 12:00",
                  location: "Mosquée Al-Azhar",
                  association: "Communauté Ansar",
                  participants: "85 inscrits",
                ),

                if (showAllEvents) ...[
                  const SizedBox(height: 20),
                  const Text("JANVIER 2026 (À VENIR)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 10),
                  _buildEventCard(
                    title: "Atelier Zakat",
                    description: "Calcul et distribution de la Zakat",
                    time: "14:00 - 16:00",
                    location: "Centre Islamique",
                    association: "Association Hikma",
                    participants: "Pré-inscriptions ouvertes",
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard({
    required String title,
    required String description,
    required String time,
    required String location,
    required String association,
    required String participants,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 12),
            Row(children: [const Icon(Icons.access_time, size: 16), const SizedBox(width: 8), Text(time)]),
            const SizedBox(height: 4),
            Row(children: [const Icon(Icons.location_on, size: 16), const SizedBox(width: 8), Text(location)]),
            const SizedBox(height: 4),
            Row(children: [const Icon(Icons.mosque, size: 16), const SizedBox(width: 8), Text(association)]),
            const SizedBox(height: 4),
            Row(children: [const Icon(Icons.people, size: 16), const SizedBox(width: 8), Text(participants)]),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MapPage()),
                    );
                  },
                  icon: const Icon(Icons.map),
                  label: const Text("Comment y aller"), // ← Final : clair et naturel
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Vous recevrez désormais les alertes pour cet événement ! 🔔"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  icon: const Icon(Icons.notifications_active),
                  label: const Text("Recevoir les alertes"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}