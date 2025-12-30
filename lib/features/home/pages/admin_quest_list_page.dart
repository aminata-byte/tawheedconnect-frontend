import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/data/app_data.dart';

class AdminQuestListPage extends StatefulWidget {
  const AdminQuestListPage({Key? key}) : super(key: key);

  @override
  State<AdminQuestListPage> createState() => _AdminQuestListPageState();
}

class _AdminQuestListPageState extends State<AdminQuestListPage> {
  @override
  Widget build(BuildContext context) {
    // --- EXEMPLE POUR TESTER L'AFFICHAGE ---
    // Si la liste est vide, on ajoute des données fictives juste pour la prévisualisation
    if (publishedQuests.isEmpty) {
      publishedQuests = [
        {
          'id': '1',
          'title': 'Aide pour l\'opération de Moussa',
          'type': 'Santé / Malade',
          'targetAmount': '500000',
          'currentAmount': '350000',
          'status': 'active',
        },
        {
          'id': '2',
          'title': 'Puits pour le village de Ndoulo',
          'type': 'Construction de Puits',
          'targetAmount': '1200000',
          'currentAmount': '1200000',
          'status': 'completed',
        },
      ];
    }
    // ---------------------------------------

    final quests = publishedQuests;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Gestion des Quêtes",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: quests.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: quests.length,
        itemBuilder: (context, index) {
          final quest = quests[index];
          return _buildQuestCard(quest);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.volunteer_activism_outlined,
              size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "Aucune quête publiée",
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestCard(Map<String, dynamic> quest) {
    bool isClosed =
        quest['status'] == 'completed' || quest['status'] == 'cancelled';

    // Calcul de la progression
    double target = double.tryParse(quest['targetAmount'].toString()) ?? 1.0;
    double current = double.tryParse(quest['currentAmount'].toString()) ?? 0.0;
    double progress = (current / target).clamp(0.0, 1.0);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icone de type + Titre
                Expanded(
                  child: Row(
                    children: [
                      _getTypeIcon(quest['type'] ?? ''),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          quest['title'] ?? "Sans titre",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                // Bouton de suppression
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: Colors.redAccent, size: 22),
                  onPressed: () => _confirmDeletion(quest),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Section Montants
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${current.toInt()} F récoltés",
                  style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                Text(
                  "Objectif: ${target.toInt()} F",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Barre de progression visuelle
            Stack(
              children: [
                Container(
                  height: 10,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: isClosed ? Colors.grey : AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 30),

            // Actions (Badge + Switch)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusBadge(quest['status'] ?? 'active'),
                Row(
                  children: [
                    const Text("Clôturer",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500)),
                    const SizedBox(width: 8),
                    Switch.adaptive(
                      value: isClosed,
                      activeColor: Colors.red,
                      onChanged: (bool value) {
                        setState(() {
                          if (value) {
                            completeQuest(quest['id']);
                          } else {
                            quest['status'] = 'active';
                          }
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Petit utilitaire pour les icônes de type
  Widget _getTypeIcon(String type) {
    IconData icon;
    Color color;
    switch (type) {
      case "Santé / Malade":
        icon = Icons.medical_services_outlined;
        color = Colors.red;
        break;
      case "Construction de Puits":
        icon = Icons.water_drop_outlined;
        color = Colors.blue;
        break;
      case "Soutien aux Daaras":
        icon = Icons.menu_book_outlined;
        color = Colors.orange;
        break;
      default:
        icon = Icons.volunteer_activism_outlined;
        color = Colors.grey;
    }
    return Icon(icon, color: color, size: 20);
  }

  void _confirmDeletion(Map<String, dynamic> quest) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Supprimer cette quête ?"),
        content: const Text(
            "Cette action est irréversible. Toutes les données de cette quête seront perdues."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("ANNULER")),
          TextButton(
            onPressed: () {
              setState(() {
                publishedQuests.removeWhere((q) => q['id'] == quest['id']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Quête supprimée avec succès")),
              );
            },
            child: const Text("SUPPRIMER", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    bool isActive = status == 'active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color:
        isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? "EN COURS" : "TERMINÉE",
        style: TextStyle(
          color: isActive ? Colors.green : Colors.red,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}