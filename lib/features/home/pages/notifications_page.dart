import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import 'events_list_page.dart';
import 'oustaze_questions_page.dart';
import 'map_page.dart';
import 'association_details_page.dart';
import 'view_answer_page.dart'; // ✅ Assure-toi d'importer la nouvelle page

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Notifications", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        // ✅ On a enlevé le bloc 'actions' ici pour épurer la page
        elevation: 0,
      ),
      backgroundColor: Colors.grey[50],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "AUJOURD'HUI",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[600]),
          ),
          const SizedBox(height: 10),

          _buildNotificationCard(
            context: context,
            icon: Icons.event_available,
            color: Colors.blue,
            title: "NOUVEL ÉVÉNEMENT",
            description: "Association Al-Iman a publié \"Conférence sur le Tawhid\"",
            time: "Il y a 30 minutes",
            actionText: "Voir l'événement",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EventsListPage()),
              );
            },
          ),

          _buildNotificationCard(
            context: context,
            icon: Icons.check_circle,
            color: Colors.green,
            title: "RÉPONSE À VOTRE QUESTION",
            description: "Oustaze Cheikh Omar a répondu à \"Comment faire le wudu...\"",
            time: "Il y a 2 heures",
            actionText: "Lire la réponse",
            onTap: () {
              // ✅ CORRECTION ICI : Le mot 'const' a été retiré
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewAnswerPage(
                    question: "Comment faire le wudu correctement ?",
                    answer: "Pour faire le wudu, commencez par l'intention, lavez vos mains trois fois, puis la bouche...",
                    oustazeName: "Oustaze Cheikh Omar",
                  ),
                ),
              );
            },
          ),

          _buildNotificationCard(
            context: context,
            icon: Icons.access_time,
            color: Colors.orange,
            title: "RAPPEL ÉVÉNEMENT",
            description: "\"Cours de Coran\" commence dans 1 heure à la Mosquée Al-Azhar",
            time: "Il y a 5 minutes",
            actionText: "Comment y aller",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MapPage()),
              );
            },
          ),

          const SizedBox(height: 20),

          Text(
            "HIER",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[600]),
          ),
          const SizedBox(height: 10),

          _buildNotificationCard(
            context: context,
            icon: Icons.edit_calendar,
            color: Colors.purple,
            title: "MODIFICATION ÉVÉNEMENT",
            description: "\"Atelier sur les piliers\" a été reporté au 22/12",
            time: "Hier à 18:00",
            actionText: "Voir les détails",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EventsListPage()),
              );
            },
          ),

          _buildNotificationCard(
            context: context,
            icon: Icons.group_add,
            color: Colors.teal,
            title: "NOUVELLE ASSOCIATION",
            description: "\"Centre Al-Azhar\" a rejoint Tawheed Connect",
            time: "Hier à 12:30",
            actionText: "Découvrir",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AssociationDetailsPage(name: "Centre Al-Azhar"),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required String time,
    required String actionText,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    time,
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: onTap,
              child: Text(
                actionText,
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}