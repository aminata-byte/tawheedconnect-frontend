import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import 'event_add_page.dart';

class EventListPage extends StatefulWidget {
  const EventListPage({Key? key}) : super(key: key);

  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  String _selectedFilter = "all"; // all, active, past

  // TODO: Remplacer par des vraies données depuis la base de données
  // Structure basée sur EventAddPage : titre, description, date, heureDebut, heureFin, lieu, intervenants
  final List<Map<String, dynamic>> _activeEvents = [
    {
      'title': 'Conférence: Le Tawhid dans l\'Islam',
      'description': 'Une conférence approfondie sur l\'unicité d\'Allah et ses implications dans la vie quotidienne...',
      'date': 'Vendredi 20 Décembre 2024',
      'startTime': '15:00',
      'endTime': '17:00',
      'location': 'Grande Mosquée, Dakar',
      'speakers': 'Oustaze Cheikh Omar, Imam Diop',
      'registered': 150,
      'views': 345,
      'hasImage': true,
      'notifyMembers': true,
      'reminder24h': true,
      'reminder1h': true,
      'status': 'active',
    },
    {
      'title': 'Cours de Coran - Tajwid pour débutants',
      'description': 'Apprentissage des règles de base du Tajwid pour améliorer votre récitation du Coran...',
      'date': 'Samedi 21 Décembre 2024',
      'startTime': '10:00',
      'endTime': '12:00',
      'location': 'Mosquée Al-Azhar, Médina',
      'speakers': 'Oustaze Abdoulaye Fall',
      'registered': 85,
      'views': 212,
      'hasImage': false,
      'notifyMembers': true,
      'reminder24h': true,
      'reminder1h': false,
      'status': 'active',
    },
  ];

  final List<Map<String, dynamic>> _pastEvents = [
    {
      'title': 'Atelier: Les piliers de l\'Islam',
      'description': 'Session interactive sur les 5 piliers de l\'Islam avec questions-réponses...',
      'date': 'Lundi 16 Décembre 2024',
      'startTime': '14:00',
      'endTime': '16:30',
      'location': 'Centre Islamique, Ouakam',
      'speakers': 'Oustaze Mamadou Seck, Imam Ndiaye',
      'registered': 92,
      'rating': 4.8,
      'hasImage': true,
      'status': 'past',
    },
  ];

  List<Map<String, dynamic>> get _filteredEvents {
    if (_selectedFilter == "active") return _activeEvents;
    if (_selectedFilter == "past") return _pastEvents;
    return [..._activeEvents, ..._pastEvents];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Mes Événements"),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implémenter la recherche
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: _filteredEvents.isEmpty
                ? _buildEmptyState()
                : _buildEventsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EventAddPage()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          const Text(
            "FILTRES:",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          _buildFilterChip("📅 Tous", "all"),
          const SizedBox(width: 8),
          _buildFilterChip("🟢 Actifs", "active"),
          const SizedBox(width: 8),
          _buildFilterChip("⏸️ Passés", "past"),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedFilter = value);
      },
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
      backgroundColor: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: isSelected ? AppColors.primary : Colors.transparent),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            "Aucun événement",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            "Ajoutez votre premier événement",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredEvents.length,
      itemBuilder: (context, index) {
        final event = _filteredEvents[index];
        final isActive = event['status'] == 'active';

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image si disponible
              if (event['hasImage'] == true)
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: Icon(Icons.image, size: 60, color: Colors.grey[500]),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status badge
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isActive ? Colors.green : Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isActive ? "🟢 EN COURS" : "⚫ TERMINÉ",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Title
                    Text(
                      event['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Description (tronquée)
                    Text(
                      event['description'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Date
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          event['date'],
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Time
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          "${event['startTime']} - ${event['endTime']}",
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Location
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            event['location'],
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Speakers / Intervenants
                    Row(
                      children: [
                        Icon(Icons.person, size: 14, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            event['speakers'],
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Stats
                    if (isActive) ...[
                      Row(
                        children: [
                          const Icon(Icons.people_outline, size: 14, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            "${event['registered']} inscrits",
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.visibility, size: 14, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            "${event['views']} vues",
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        children: [
                          const Icon(Icons.people_outline, size: 14, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            "${event['registered']} participants",
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.star, size: 14, color: Colors.orange),
                          const SizedBox(width: 6),
                          Text(
                            "Note: ${event['rating']}/5",
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),

                    // Action buttons
                    Row(
                      children: [
                        if (isActive) ...[
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // TODO: Modifier l'événement
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const EventAddPage()),
                                );
                              },
                              icon: const Icon(Icons.edit, size: 16),
                              label: const Text("Modifier"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: BorderSide(color: AppColors.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // TODO: Voir les statistiques
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("📊 Statistiques de l'événement")),
                                );
                              },
                              icon: const Icon(Icons.bar_chart, size: 16),
                              label: const Text("Stats"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.blue,
                                side: const BorderSide(color: Colors.blue),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () {
                              _showDeleteDialog(event['title']);
                            },
                            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                          ),
                        ] else ...[
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // TODO: Voir le rapport
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("📊 Rapport de l'événement")),
                                );
                              },
                              icon: const Icon(Icons.assessment, size: 16),
                              label: const Text("Voir rapport"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: BorderSide(color: AppColors.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog(String eventTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Annuler l'événement"),
        content: Text("Voulez-vous vraiment annuler '$eventTitle' ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Non"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("❌ Événement annulé")),
              );
            },
            child: const Text("Oui, annuler", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}