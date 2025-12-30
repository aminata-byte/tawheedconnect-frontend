import 'package:flutter/material.dart';
import '../../../core/data/app_data.dart';
import '../../../core/constants/colors.dart';
import 'publish_quest_page.dart';

class AdminUrgentRequestsPage extends StatefulWidget {
  const AdminUrgentRequestsPage({Key? key}) : super(key: key);

  @override
  State<AdminUrgentRequestsPage> createState() => _AdminUrgentRequestsPageState();
}

class _AdminUrgentRequestsPageState extends State<AdminUrgentRequestsPage> {

  void _updateRequestStatus(int index, String status) {
    setState(() {
      urgentRequests[index]['status'] = status;
    });

    String message = status == 'approved'
        ? "Demande approuvée - Quête lancée !"
        : "Demande rejetée";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: status == 'approved' ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filtrer les demandes en attente
    final pendingRequests = urgentRequests
        .asMap()
        .entries
        .where((entry) => entry.value['status'] == 'pending')
        .toList();

    // Filtrer les demandes traitées
    final processedRequests = urgentRequests
        .asMap()
        .entries
        .where((entry) => entry.value['status'] != 'pending')
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Demandes d'aide urgente"),
        elevation: 0,
      ),
      body: urgentRequests.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              "Aucune demande pour le moment",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      )
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ==================== DEMANDES EN ATTENTE ====================
          if (pendingRequests.isNotEmpty) ...[
            Row(
              children: [
                Text(
                  "EN ATTENTE (${pendingRequests.length})",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "URGENT",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[900],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...pendingRequests.map((entry) {
              final index = entry.key;
              final request = entry.value;
              return _buildRequestCard(
                request: request,
                index: index,
                isPending: true,
              );
            }).toList(),
            const SizedBox(height: 24),
          ],

          // ==================== DEMANDES TRAITÉES ====================
          if (processedRequests.isNotEmpty) ...[
            Text(
              "TRAITÉES (${processedRequests.length})",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            ...processedRequests.map((entry) {
              final index = entry.key;
              final request = entry.value;
              return _buildRequestCard(
                request: request,
                index: index,
                isPending: false,
              );
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildRequestCard({
    required Map<String, dynamic> request,
    required int index,
    required bool isPending,
  }) {
    final DateTime date = request['date'];
    final String status = request['status'];

    Color statusColor = status == 'approved'
        ? Colors.green
        : status == 'rejected'
        ? Colors.red
        : Colors.orange;

    String statusText = status == 'approved'
        ? "Approuvée"
        : status == 'rejected'
        ? "Rejetée"
        : "En attente";

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isPending ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isPending
            ? BorderSide(color: Colors.orange.withOpacity(0.5), width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header avec statut
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Icon(
                        Icons.person,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request['memberName'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          "${date.day}/${date.month}/${date.year} à ${date.hour}:${date.minute.toString().padLeft(2, '0')}",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Téléphone
            Row(
              children: [
                Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Text(
                  request['phone'],
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Message
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                request['message'],
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ),

            // Boutons d'action (seulement pour les demandes en attente)
            if (isPending) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  // ↓↓↓ BOUTON MODIFIÉ : Navigation vers PublishQuestPage ↓↓↓
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PublishQuestPage(
                              associationName: "Al-Iman", // TODO: Remplacer par le vrai nom de l'association
                              urgentRequest: request,
                            ),
                          ),
                        ).then((_) => setState(() {}));
                      },
                      icon: const Icon(Icons.volunteer_activism, size: 18),
                      label: const Text("Publier quête"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Rejeter la demande"),
                            content: const Text(
                              "Voulez-vous rejeter cette demande ?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Annuler"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _updateRequestStatus(index, 'rejected');
                                },
                                child: const Text(
                                  "Rejeter",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.cancel, size: 18),
                      label: const Text("Rejeter"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}