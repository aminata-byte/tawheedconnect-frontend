import 'package:flutter/material.dart';
import 'vues_detail_page.dart';

class VuesPage extends StatelessWidget {
  const VuesPage({super.key});

  final int totalVues = 128;

  final List<Map<String, String>> historique = const [
    {"titre": "Cours Tajwid", "vues": "45"},
    {"titre": "Khoutba du vendredi", "vues": "60"},
    {"titre": "Dars Aqida", "vues": "23"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vues")),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            // TOTAL VUES
            Card(
              color: Colors.orange.withOpacity(0.1),
              child: ListTile(
                leading: const Icon(Icons.remove_red_eye, color: Colors.orange),
                title: const Text("Total des vues"),
                trailing: Text(
                  totalVues.toString(),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Par contenu",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: historique.length,
                itemBuilder: (context, index) {
                  final item = historique[index];

                  return Card(
                    child: ListTile(
                      title: Text(item['titre']!),
                      subtitle: Text("${item['vues']} vues"),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        child: const Text("Voir détails"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VuesDetailPage(
                                titre: item['titre']!,
                              ),
                            ),
                          );
                        },
                      ),
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
