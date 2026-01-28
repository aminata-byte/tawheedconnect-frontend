import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/services/api_service.dart';
import 'oustaze_add_page.dart';

class OustazeListPage extends StatefulWidget {
  const OustazeListPage({Key? key}) : super(key: key);

  @override
  State<OustazeListPage> createState() => _OustazeListPageState();
}

class _OustazeListPageState extends State<OustazeListPage> {
  List<dynamic> _oustazes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOustazes();
  }

  Future<void> _fetchOustazes() async {
    try {
      setState(() => _isLoading = true);
      final data = await ApiService().getOustazes();
      setState(() {
        _oustazes = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: ${e.toString()}")),
      );
    }
  }

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
            icon: const Icon(Icons.refresh),
            onPressed: _fetchOustazes,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeaderStats(),
          const SizedBox(height: 20),
          const Text(
            "MES OUSTAZES",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          ..._oustazes.map((o) => _buildOustazeCard(o)).toList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OustazeAddPage()),
          );
          if (result == true) _fetchOustazes();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Section Statistiques du haut (conforme à ton image)
  Widget _buildHeaderStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem("👨‍🏫", "${_oustazes.length}", "Oustazes"),
          _buildStatItem("❓", "0", "Questions"), // Fixé à 0 pour le moment
        ],
      ),
    );
  }

  Widget _buildStatItem(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  // Carte Oustaze (conforme à ton image sans Statut et bouton Stats)
  Widget _buildOustazeCard(Map<String, dynamic> oustaze) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  oustaze['name'][0].toUpperCase(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  oustaze['name'],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const Text("🏷️ Spécialités", style: TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: oustaze['speciality'].toString().split(',').map((s) => Chip(
              label: Text(s.trim(), style: const TextStyle(fontSize: 10)),
              backgroundColor: Colors.green.withOpacity(0.1),
            )).toList(),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.phone_android, size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Text(oustaze['phone'], style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
          const Divider(height: 24),
          const Text("💬 0 questions répondues", style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => OustazeAddPage(oustaze: oustaze)),
                    );
                    if (result == true) _fetchOustazes();
                  },
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text("Modifier"),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.green, side: const BorderSide(color: Colors.green)),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () => _showDeleteDialog(oustaze),
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> oustaze) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Supprimer"),
        content: Text("Supprimer ${oustaze['name']} ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final success = await ApiService().deleteOustaze(oustaze['id']);
                if (success) _fetchOustazes();
              },
              child: const Text("Supprimer", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
  }
}