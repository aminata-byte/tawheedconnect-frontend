import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import 'audio_dars_page.dart';

class AudioListPage extends StatefulWidget {
  const AudioListPage({Key? key}) : super(key: key);

  @override
  State<AudioListPage> createState() => _AudioListPageState();
}

class _AudioListPageState extends State<AudioListPage> {
  String _selectedFilter = "all"; // all, tafsir, hadith, fiqh, etc.

  // TODO: Remplacer par des vraies données depuis la base de données
  // Structure basée sur AudioDarsPage : titre, description, catégorie, intervenant
  final List<Map<String, dynamic>> _audios = [
    {
      'title': 'Tafsir Sourate Al-Fatiha',
      'description': 'Explication complète de la sourate Al-Fatiha avec ses leçons spirituelles et ses implications dans la vie quotidienne...',
      'category': 'Tafsir',
      'speaker': 'Cheikh Omar Diallo',
      'duration': '45:30',
      'plays': 1234,
      'uploadDate': '15 Déc 2024',
    },
    {
      'title': 'Les 40 Hadiths de Nawawi - Hadith 1',
      'description': 'Premier hadith sur les intentions et leur importance dans nos actions quotidiennes...',
      'category': 'Hadith',
      'speaker': 'Imam Abdoulaye Diop',
      'duration': '32:15',
      'plays': 892,
      'uploadDate': '12 Déc 2024',
    },
    {
      'title': 'Les règles du Wudu en détail',
      'description': 'Explication détaillée des ablutions selon les 4 écoles juridiques...',
      'category': 'Fiqh',
      'speaker': 'Oustaze Mamadou Seck',
      'duration': '28:45',
      'plays': 756,
      'uploadDate': '10 Déc 2024',
    },
  ];

  List<Map<String, dynamic>> get _filteredAudios {
    if (_selectedFilter == "all") return _audios;
    return _audios.where((a) => a['category'].toLowerCase() == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Cours Audio / Dars"),
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
            child: _filteredAudios.isEmpty
                ? _buildEmptyState()
                : _buildAudiosList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AudioDarsPage()),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "CATÉGORIES:",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              Text(
                "${_filteredAudios.length} audios",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFilterChip("📚 Tous", "all"),
              _buildFilterChip("📖 Tafsir", "tafsir"),
              _buildFilterChip("📚 Hadith", "hadith"),
              _buildFilterChip("🤲 Fiqh", "fiqh"),
              _buildFilterChip("🎙️ Rappel", "rappel"),
            ],
          ),
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
          Icon(Icons.mic, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            "Aucun cours audio",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            "Ajoutez votre premier cours",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAudiosList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredAudios.length,
      itemBuilder: (context, index) {
        final audio = _filteredAudios[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
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
              Row(
                children: [
                  // Icône audio
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.mic, color: Colors.orange, size: 30),
                  ),
                  const SizedBox(width: 12),

                  // Infos principales
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Catégorie
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                          ),
                          child: Text(
                            audio['category'],
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Durée
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              audio['duration'],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Titre
              Text(
                audio['title'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                audio['description'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),

              // Intervenant
              Row(
                children: [
                  Icon(Icons.person, size: 14, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    audio['speaker'],
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Stats
              Row(
                children: [
                  Icon(Icons.play_circle_outline, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    "${audio['plays']} écoutes",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    audio['uploadDate'],
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Lire l'audio
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("🎧 Lecture de '${audio['title']}'")),
                        );
                      },
                      icon: const Icon(Icons.play_arrow, size: 16),
                      label: const Text("Écouter"),
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
                        // TODO: Modifier l'audio
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AudioDarsPage()),
                        );
                      },
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text("Modifier"),
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
                      _showDeleteDialog(audio['title']);
                    },
                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog(String audioTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Supprimer l'audio"),
        content: Text("Voulez-vous vraiment supprimer '$audioTitle' ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("🗑️ Audio supprimé")),
              );
            },
            child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}