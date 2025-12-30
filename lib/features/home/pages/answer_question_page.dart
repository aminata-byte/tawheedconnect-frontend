import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class AnswerQuestionPage extends StatefulWidget {
  final String question;
  final String author;

  const AnswerQuestionPage({
    Key? key,
    required this.question,
    required this.author,
  }) : super(key: key);

  @override
  State<AnswerQuestionPage> createState() => _AnswerQuestionPageState();
}

class _AnswerQuestionPageState extends State<AnswerQuestionPage> {
  final TextEditingController _answerController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _sendAnswer() {
    if (_answerController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez écrire une réponse"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSending = true);

    // ⏳ Simulation envoi API
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(
        context,
        _answerController.text.trim(), // ⬅️ on renvoie la réponse
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Répondre à la question"),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ❓ QUESTION
            const Text(
              "Question",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              widget.question,
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 6),
            Text(
              "Posée par : ${widget.author}",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // ✍️ RÉPONSE
            const Text(
              "Votre réponse",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _answerController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: "Écrivez votre réponse ici...",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const Spacer(),

            // 📤 BOUTON ENVOYER
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSending ? null : _sendAnswer,
                icon: const Icon(Icons.send),
                label: Text(
                  _isSending ? "Envoi en cours..." : "Envoyer la réponse",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
