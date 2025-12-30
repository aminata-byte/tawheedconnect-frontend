import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import 'ask_question_page.dart';
import 'answer_question_page.dart';
import 'notifications_page.dart';

class QuestionModel {
  String question;
  String author;
  String time;
  String? answer;
  String? oustaze;

  QuestionModel({
    required this.question,
    required this.author,
    required this.time,
    this.answer,
    this.oustaze,
  });
}

class OustazeQuestionsPage extends StatefulWidget {
  const OustazeQuestionsPage({Key? key}) : super(key: key);

  @override
  State<OustazeQuestionsPage> createState() => _OustazeQuestionsPageState();
}

class _OustazeQuestionsPageState extends State<OustazeQuestionsPage> {
  // 🔐 ROLE : true = Oustaze (3 onglets), false = Membre (2 onglets)
  bool isOustaze = true;
  int notificationCount = 2;

  List<QuestionModel> allQuestions = [
    QuestionModel(
      question: "Comment faire la prière du Fajr ?",
      author: "Abdoulaye Diop",
      time: "2h",
      answer: "Le Fajr comporte 2 rakaats fard.",
      oustaze: "Cheikh Omar Diallo",
    ),
    QuestionModel(
      question: "Quelles sont les conditions du jeûne ?",
      author: "Mariama Sarr",
      time: "5h",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: isOustaze ? 3 : 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text("Espace Questions", style: TextStyle(color: Colors.white)),
          elevation: 0,
          actions: [_buildNotificationIcon()],
          bottom: TabBar(
            indicatorColor: Colors.orange,
            indicatorWeight: 3,
            labelColor: Colors.white, // ✅ Texte sélectionné en blanc
            unselectedLabelColor: Colors.white70, // ✅ Texte non sélectionné en blanc cassé
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: isOustaze
                ? const [Tab(text: "Tous"), Tab(text: "En attente"), Tab(text: "Répondues")]
                : const [Tab(text: "Tous"), Tab(text: "Répondues")],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.orange,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text("Poser une question", style: TextStyle(color: Colors.white)), // ✅ Texte mis à jour
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AskQuestionPage())
          ),
        ),
        body: TabBarView(
          children: isOustaze
              ? [
            _buildList(filter: "all"),
            _buildList(filter: "pending"),
            _buildList(filter: "answered"),
          ]
              : [
            _buildList(filter: "all"),
            _buildList(filter: "answered"),
          ],
        ),
      ),
    );
  }

  Widget _buildList({required String filter}) {
    List<QuestionModel> filteredList;
    if (filter == "pending") {
      filteredList = allQuestions.where((q) => q.answer == null).toList();
    } else if (filter == "answered") {
      filteredList = allQuestions.where((q) => q.answer != null).toList();
    } else {
      filteredList = allQuestions;
    }

    if (filteredList.isEmpty) {
      return Center(
        child: Text("Aucune question ici", style: TextStyle(color: Colors.grey[600])),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredList.length,
      itemBuilder: (context, index) => _buildQuestionItem(filteredList[index]),
    );
  }

  Widget _buildQuestionItem(QuestionModel item) {
    bool hasAnswer = item.answer != null && item.answer!.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey[100],
                  child: const Icon(Icons.person, size: 18, color: Colors.grey)
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.author, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text(item.time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ),
              _statusBadge(hasAnswer),
            ],
          ),
          const SizedBox(height: 12),
          Text(item.question, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),

          if (!hasAnswer && isOustaze) _buildReplyButton(item),

          if (hasAnswer) _buildAnswerBox(item.answer!, item.oustaze ?? "Oustaze"),
        ],
      ),
    );
  }

  Widget _statusBadge(bool isAnswered) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isAnswered ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isAnswered ? "Répondu" : "En attente",
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isAnswered ? Colors.green : Colors.orange),
      ),
    );
  }

  Widget _buildReplyButton(QuestionModel item) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.reply, size: 18),
          label: const Text("Répondre"),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          onPressed: () async {
            final res = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AnswerQuestionPage(question: item.question, author: item.author))
            );
            if (res != null) {
              setState(() {
                item.answer = res;
                item.oustaze = "Cheikh Omar Diallo";
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildAnswerBox(String ans, String name) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.green)),
          const SizedBox(height: 4),
          Text(ans, style: const TextStyle(fontSize: 13, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationsPage()),
            );
          },
          child: Badge(
            label: Text('$notificationCount', style: const TextStyle(color: Colors.white)),
            isLabelVisible: notificationCount > 0,
            backgroundColor: Colors.red,
            child: const Icon(
              Icons.notifications_none,
              size: 28,
              color: Colors.white, // ✅ Cloche désormais en blanc
            ),
          ),
        ),
      ),
    );
  }
}