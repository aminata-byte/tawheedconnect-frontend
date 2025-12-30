import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart'; // ← Chemin correct vers colors.dart

// Les pages sont dans le sous-dossier pages/ au même niveau que member_dashboard.dart
import 'pages/member_home_page.dart';
import 'pages/associations_page.dart';
import 'pages/oustaze_questions_page.dart';
import 'pages/member_profile_page.dart';

class MemberDashboard extends StatefulWidget {
  const MemberDashboard({Key? key}) : super(key: key);

  @override
  State<MemberDashboard> createState() => _MemberDashboardState();
}

class _MemberDashboardState extends State<MemberDashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const MemberHomePage(),
    const AssociationsPage(),
    const OustazeQuestionsPage(),
    const MemberProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mosque),
            label: "Associations",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: "Questions",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}