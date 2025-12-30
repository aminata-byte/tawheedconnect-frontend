import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class AskQuestionPage extends StatefulWidget {
  const AskQuestionPage({Key? key}) : super(key: key);

  @override
  State<AskQuestionPage> createState() => _AskQuestionPageState();
}

class _AskQuestionPageState extends State<AskQuestionPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  bool checkSimilar = false;

  // Questions déjà répondues (exemple)
  final List<String> answeredQuestions = [
    "Comment créer une association ?",
    "Comment modifier mon profil ?",
    "Comment publier un événement ?",
  ];

  List<String> similarQuestions = [];

  void checkSimilarQuestions(String text) {
    if (!checkSimilar || text.isEmpty) {
      similarQuestions = [];
      return;
    }

    similarQuestions = answeredQuestions
        .where((q) => q.toLowerCase().contains(text.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Poser une question"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Titre
            TextField(
              controller: titleController,
              onChanged: (value) {
                setState(() {
                  checkSimilarQuestions(value);
                });
              },
              decoration: const InputDecoration(
                labelText: "Titre de la question",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            /// Activer / Désactiver vérification
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Vérifier si déjà répondu",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Switch(
                  value: checkSimilar,
                  activeColor: Colors.orange,
                  onChanged: (value) {
                    setState(() {
                      checkSimilar = value;
                      checkSimilarQuestions(titleController.text);
                    });
                  },
                ),
              ],
            ),

            /// Questions similaires
            if (checkSimilar && similarQuestions.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Questions déjà répondues :",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...similarQuestions.map(
                          (q) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text("• $q"),
                      ),
                    ),
                  ],
                ),
              ),

            /// Description
            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Détails de la question",
                border: OutlineInputBorder(),
              ),
            ),

            const Spacer(),

            /// Bouton envoyer
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Question envoyée avec succès"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text(
                  "Envoyer la question",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
