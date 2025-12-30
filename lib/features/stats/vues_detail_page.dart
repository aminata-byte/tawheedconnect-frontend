import 'package:flutter/material.dart';

class VuesDetailPage extends StatelessWidget {
  final String titre;

  const VuesDetailPage({super.key, required this.titre});

  // 👇 Liste avec nom + date
  final List<Map<String, String>> viewers = const [
    {"nom": "Ahmed Diallo", "date": "12/09/2025"},
    {"nom": "Mariam Ndiaye", "date": "12/09/2025"},
    {"nom": "Ousmane Fall", "date": "11/09/2025"},
    {"nom": "Fatou Sow", "date": "10/09/2025"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails des vues"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre du contenu
            Text(
              titre,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Personnes ayant vu ce contenu :",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: viewers.length,
                itemBuilder: (context, index) {
                  final viewer = viewers[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(viewer["nom"]!),
                      subtitle: Text("Vu le ${viewer["date"]}"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
