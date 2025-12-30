import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import 'oustaze_add_page.dart';

class OustazeListPage extends StatefulWidget {
  const OustazeListPage({Key? key}) : super(key: key);

  @override
  State<OustazeListPage> createState() => _OustazeListPageState();
}

class _OustazeListPageState extends State<OustazeListPage> {
  // TODO: Remplacer par des vraies données depuis la base de données
  // Structure basée sur OustazeAddPage : nom, spécialité, téléphone
  final List<Map<String, dynamic>> _oustazes = [
    {
      'name': 'Cheikh Omar Diallo',
      'speciality': 'Tafsir, Fiqh, Hadith',
      'phone': '+221 77 123 45 67',
      'questionsAnswered': 45,
      'isActive': true,
    },
    {
      'name': 'Imam Abdoulaye Diop',
      'speciality': 'Coran, Tajwid',
      'phone': '+221 76 234 56 78',
      'questionsAnswered': 38,
      'isActive': true,
    },
    {
      'name': 'Oustaze Mamadou Seck',
      'speciality': 'Fiqh, Zakat, Ramadan',
      'phone': '+221 77 345 67 89',
      'questionsAnswered': 29,
      'isActive': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Gestion des Oustazes"),
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
      body: _oustazes.isEmpty ? _buildEmptyState() : _buildOustazesList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OustazeAddPage()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            "Aucun oustaze enregistré",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            "Ajoutez votre premier oustaze",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildOustazesList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Statistiques générales
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem("👨‍🏫", "${_oustazes.length}", "Oustazes"),
              _buildStatItem("✅", "${_oustazes.where((o) => o['isActive'] == true).length}", "Actifs"),
              _buildStatItem("❓", "${_oustazes.fold(0, (sum, o) => sum + (o['questionsAnswered'] as int))}", "Questions"),
            ],
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          "OUSTAZES ACTIFS",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 12),

        // Liste des oustazes
        ..._oustazes.map((oustaze) => _buildOustazeCard(oustaze)).toList(),
      ],
    );
  }

  Widget _buildStatItem(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildOustazeCard(Map<String, dynamic> oustaze) {
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
          // Header avec nom et statut
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  oustaze['name'].toString().substring(0, 1),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            oustaze['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: oustaze['isActive'] ? Colors.green : Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            oustaze['isActive'] ? "🟢 Actif" : "⚫ Inactif",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
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
          const Divider(),
          const SizedBox(height: 12),

          // Spécialité (avec chips)
          const Text(
            "🏷️ Spécialités",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: oustaze['speciality']
                .toString()
                .split(',')
                .map((spec) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Text(
                spec.trim(),
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ))
                .toList(),
          ),

          const SizedBox(height: 12),

          // Téléphone
          Row(
            children: [
              Icon(Icons.phone, size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                oustaze['phone'],
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),

          // Statistiques simplifiées
          Row(
            children: [
              const Icon(Icons.question_answer, size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                "${oustaze['questionsAnswered']} questions répondues",
                style: const TextStyle(color: Colors.grey, fontSize: 13),
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
                    // TODO: Modifier l'oustaze
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OustazeAddPage()),
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
                    // TODO: Voir les statistiques détaillées
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("📊 Stats de ${oustaze['name']}")),
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
                  _showDeleteDialog(oustaze['name']);
                },
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(String oustazeName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Retirer l'oustaze"),
        content: Text("Voulez-vous vraiment retirer '$oustazeName' ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("❌ Oustaze retiré")),
              );
            },
            child: const Text("Retirer", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}