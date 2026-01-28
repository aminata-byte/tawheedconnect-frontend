import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/services/api_service.dart';
import 'event_model.dart';
import 'event_add_page.dart';

class EventListPage extends StatefulWidget {
  const EventListPage({Key? key}) : super(key: key);

  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  String _selectedFilter = "all"; // all | active | past

  final ApiService _apiService = ApiService();

  List<Event> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final data = await _apiService.getEvents();
      setState(() {
        _events = data.map((e) => Event.fromJson(e)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  // ✅ Détermine si un événement est passé
  bool _isEventPast(Event event) {
    try {
      // On parse la date de l'événement (format: "28 Jan 2026")
      final parts = event.date.split(' ');
      if (parts.length != 3) return false;

      final day = int.parse(parts[0]);
      final months = {
        'Jan': 1, 'Fév': 2, 'Mar': 3, 'Avr': 4, 'Mai': 5, 'Juin': 6,
        'Juil': 7, 'Août': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Déc': 12
      };
      final month = months[parts[1]] ?? 1;
      final year = int.parse(parts[2]);

      // Parse l'heure de début
      final timeParts = event.startTime.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      final eventDateTime = DateTime(year, month, day, hour, minute);
      final now = DateTime.now();

      // L'événement est passé si sa date est avant maintenant
      return eventDateTime.isBefore(now);
    } catch (e) {
      print('❌ Erreur lors de la vérification de la date: $e');
      return false;
    }
  }

  List<Event> get _filteredEvents {
    if (_selectedFilter == "active") {
      return _events.where((e) => !_isEventPast(e)).toList();
    }
    if (_selectedFilter == "past") {
      return _events.where((e) => _isEventPast(e)).toList();
    }
    return _events;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Mes Événements"),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredEvents.isEmpty
                ? _buildEmptyState()
                : _buildEventsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EventAddPage()),
          );
          if (result == true) {
            _loadEvents();
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // ================= UI =================

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
      onSelected: (_) => setState(() => _selectedFilter = value),
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text("Aucun événement", style: TextStyle(fontSize: 18, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildEventsList() {
    return RefreshIndicator(
      onRefresh: _loadEvents,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredEvents.length,
        itemBuilder: (context, index) {
          final Event event = _filteredEvents[index];
          final bool isPast = _isEventPast(event); // ✅ Vérification dynamique

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
                if (event.image != null && event.image!.isNotEmpty)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      event.image!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 150,
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 150,
                          color: Colors.grey[200],
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _statusBadge(isPast), // ✅ Badge dynamique
                      const SizedBox(height: 12),

                      Text(event.title,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),

                      Text(
                        event.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[700], fontSize: 13),
                      ),
                      const SizedBox(height: 12),

                      _infoRow(Icons.calendar_today, event.date),
                      _infoRow(Icons.access_time,
                          "${event.startTime}${event.endTime != null ? ' - ${event.endTime}' : ''}"),
                      _infoRow(Icons.location_on, event.location),
                      if (event.speakers.isNotEmpty && event.speakers != "Non spécifié")
                        _infoRow(Icons.person, event.speakers),

                      const SizedBox(height: 12),
                      const Divider(),

                      Row(
                        children: [
                          if (!isPast) // ✅ Bouton Modifier uniquement si non passé
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Modification à venir")),
                                  );
                                },
                                icon: const Icon(Icons.edit, size: 16),
                                label: const Text("Modifier"),
                              ),
                            ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statusBadge(bool isPast) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPast ? Colors.grey : Colors.green,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isPast ? "⚫ TERMINÉ" : "🟢 EN COURS",
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}