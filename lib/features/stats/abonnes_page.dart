import 'package:flutter/material.dart';

class AbonnesPage extends StatelessWidget {
  const AbonnesPage({super.key});

  final List<Map<String, String>> abonnes = const [
    {"name": "Abdoulaye Diop", "date": "12/09/2025"},
    {"name": "Awa Ndiaye", "date": "10/09/2025"},
    {"name": "Mamadou Fall", "date": "08/09/2025"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Abonnés")),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: abonnes.length,
        itemBuilder: (context, index) {
          final abonne = abonnes[index];
          return Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(abonne["name"]!),
              subtitle: Text("Abonné le ${abonne["date"]}"),
            ),
          );
        },
      ),
    );
  }
}
