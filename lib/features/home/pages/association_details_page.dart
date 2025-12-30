import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import 'event_detail_page.dart';
import '../../../core/data/app_data.dart';

class AssociationDetailsPage extends StatefulWidget {
  final String name;

  const AssociationDetailsPage({super.key, required this.name});

  @override
  State<AssociationDetailsPage> createState() => _AssociationDetailsPageState();
}

class _AssociationDetailsPageState extends State<AssociationDetailsPage>
    with SingleTickerProviderStateMixin {
  bool isSubscribed = false;
  late TabController _tabController;
  String _eventFilter = "À venir";

  // Controllers de recherche
  final TextEditingController _videoSearchController = TextEditingController();
  final TextEditingController _audioSearchController = TextEditingController();
  final TextEditingController _questionSearchController = TextEditingController();

  String _videoSearchQuery = "";
  String _audioSearchQuery = "";
  String _questionSearchQuery = "";

  // Date actuelle (26 décembre 2025)
  final DateTime currentDate = DateTime(2025, 12, 26);

  // Liste d'événements avec dates réelles
  final List<Map<String, dynamic>> events = [
    {
      "title": "Cours de Tafsir - Sourate 1",
      "date": DateTime(2025, 12, 10),
      "startTime": "15h00",
      "endTime": "17h00",
      "location": "Mosquée Al Falah, Grand Yoff",
      "theme": "Tafsir Coranique",
    },
    {
      "title": "Cours de Tafsir - Sourate 2",
      "date": DateTime(2025, 12, 25),
      "startTime": "15h00",
      "endTime": "17h00",
      "location": "Mosquée Al Falah, Grand Yoff",
      "theme": "Tafsir Coranique",
    },
    {
      "title": "Cours de Tafsir - Sourate 3",
      "date": DateTime(2025, 12, 27),
      "startTime": "15h00",
      "endTime": "17h00",
      "location": "Mosquée Al Falah, Grand Yoff",
      "theme": "Tafsir Coranique",
    },
    {
      "title": "Cours de Tafsir - Sourate 4",
      "date": DateTime(2025, 12, 28),
      "startTime": "15h00",
      "endTime": "17h00",
      "location": "Mosquée Al Falah, Grand Yoff",
      "theme": "Tafsir Coranique",
    },
    {
      "title": "Cours de Tafsir - Sourate 5",
      "date": DateTime(2026, 1, 5),
      "startTime": "15h00",
      "endTime": "17h00",
      "location": "Mosquée Al Falah, Grand Yoff",
      "theme": "Tafsir Coranique",
    },
  ];

  // Données pour les vidéos
  final List<Map<String, String>> videos = [
    {"title": "Tafsir Sourate Al-Fatiha - Partie 1", "speaker": "Cheikh Omar Diallo", "duration": "45 min", "views": "120"},
    {"title": "Tafsir Sourate Al-Baqara - Partie 1", "speaker": "Cheikh Omar Diallo", "duration": "50 min", "views": "130"},
    {"title": "Les piliers de l'Islam", "speaker": "Cheikh Ahmadou Bamba", "duration": "38 min", "views": "140"},
    {"title": "Tafsir Sourate Al-Imran", "speaker": "Cheikh Omar Diallo", "duration": "42 min", "views": "150"},
    {"title": "La purification en Islam", "speaker": "Cheikh Moustapha Sy", "duration": "35 min", "views": "160"},
    {"title": "Tafsir Sourate An-Nisa", "speaker": "Cheikh Omar Diallo", "duration": "48 min", "views": "170"},
  ];

  // Données pour les audios
  final List<Map<String, String>> audios = [
    {"title": "Rappel - La patience en Islam", "speaker": "Cheikh Ahmadou Bamba", "duration": "32 min", "listens": "85"},
    {"title": "L'importance de la prière", "speaker": "Cheikh Omar Diallo", "duration": "28 min", "listens": "90"},
    {"title": "Le jeûne du Ramadan", "speaker": "Cheikh Moustapha Sy", "duration": "35 min", "listens": "95"},
    {"title": "La Zakat et la solidarité", "speaker": "Cheikh Ahmadou Bamba", "duration": "30 min", "listens": "100"},
    {"title": "Les bienfaits du dhikr", "speaker": "Cheikh Omar Diallo", "duration": "25 min", "listens": "105"},
  ];

  // Données pour les questions
  final List<Map<String, dynamic>> questions = [
    {
      "question": "Comment effectuer correctement le Woudou ?",
      "author": "Abdoulaye D.",
      "time": "Il y a 1h",
      "hasAnswer": true,
      "oustazeAnswer": "Cheikh Omar Diallo",
      "answer": "Assalamou aleykoum, le Woudou commence par l'intention, puis vous lavez vos mains trois fois..."
    },
    {
      "question": "Quelle est la différence entre Fard et Sunnah ?",
      "author": "Fatima S.",
      "time": "Il y a 2h",
      "hasAnswer": true,
      "oustazeAnswer": "Cheikh Ahmadou Bamba",
      "answer": "Les Fard sont les obligations religieuses tandis que les Sunnah sont recommandées..."
    },
    {
      "question": "Peut-on prier en étant en retard ?",
      "author": "Moussa K.",
      "time": "Il y a 3h",
      "hasAnswer": false,
    },
    {
      "question": "Comment calculer la Zakat ?",
      "author": "Aissatou B.",
      "time": "Il y a 4h",
      "hasAnswer": true,
      "oustazeAnswer": "Cheikh Moustapha Sy",
      "answer": "La Zakat est calculée à 2.5% de vos économies annuelles..."
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Vérifier si le membre est déjà abonné
    String memberId = "member_001"; // TODO: Remplacer par le vrai ID
    isSubscribed = isSubscribedToAssociation(memberId, widget.name);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _videoSearchController.dispose();
    _audioSearchController.dispose();
    _questionSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              backgroundColor: AppColors.primary,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(widget.name, style: const TextStyle(fontSize: 16)),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.mosque, size: 80, color: Colors.white),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() => isSubscribed = !isSubscribed);

                          String memberId = "member_001"; // TODO: Remplacer par le vrai ID
                          if (isSubscribed) {
                            subscribeToAssociation(memberId, widget.name);
                          } else {
                            unsubscribeFromAssociation(memberId, widget.name);
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isSubscribed
                                  ? "✅ Vous recevrez les notifications de cette association"
                                  : "Vous êtes désabonné"),
                              backgroundColor: isSubscribed ? Colors.green : Colors.orange,
                            ),
                          );
                        },
                        icon: Icon(isSubscribed ? Icons.notifications_active : Icons.notifications_none),
                        label: Text(isSubscribed ? "ABONNÉ" : "S'ABONNER"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSubscribed ? Colors.grey[300] : AppColors.primary,
                          foregroundColor: isSubscribed ? Colors.grey[700] : Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(child: _buildInfoCard("120", "Membres", Icons.people)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildInfoCard("18", "Contenus", Icons.library_books)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppColors.primary,
                  tabs: const [
                    Tab(text: "Événements"),
                    Tab(text: "Vidéos"),
                    Tab(text: "Audio"),
                    Tab(text: "Questions"),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildEventsTab(),
            _buildVideosTab(),
            _buildAudiosTab(),
            _buildQuestionsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsTab() {
    final filteredEvents = events.where((event) {
      if (_eventFilter == "À venir") {
        return event["date"].isAfter(currentDate);
      } else {
        return event["date"].isBefore(currentDate) || event["date"].isAtSameMomentAs(currentDate);
      }
    }).toList();

    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(child: _buildFilterButton("À venir", "À venir")),
              const SizedBox(width: 8),
              Expanded(child: _buildFilterButton("Passés", "Passé")),
            ],
          ),
        ),
        Expanded(
          child: filteredEvents.isEmpty
              ? Center(
            child: Text(
              _eventFilter == "À venir"
                  ? "Aucun événement à venir pour le moment"
                  : "Aucun événement passé",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredEvents.length,
            itemBuilder: (context, index) {
              final event = filteredEvents[index];
              bool isPast = event["date"].isBefore(currentDate) || event["date"].isAtSameMomentAs(currentDate);
              return _buildEventItem(
                title: event["title"],
                date: "${event["date"].day} Déc ${event["date"].year}",
                startTime: event["startTime"],
                endTime: event["endTime"],
                location: event["location"],
                theme: event["theme"],
                type: isPast ? "Passé" : "À venir",
                isPast: isPast,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVideosTab() {
    final filteredVideos = videos.where((video) {
      return video["title"]!.toLowerCase().contains(_videoSearchQuery.toLowerCase()) ||
          video["speaker"]!.toLowerCase().contains(_videoSearchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        _buildSearchBar(
          controller: _videoSearchController,
          hintText: "Rechercher une vidéo...",
          searchQuery: _videoSearchQuery,
          onChanged: (value) => setState(() => _videoSearchQuery = value),
          onClear: () => setState(() {
            _videoSearchController.clear();
            _videoSearchQuery = "";
          }),
        ),
        Expanded(
          child: filteredVideos.isEmpty
              ? _buildEmptyState("Aucune vidéo trouvée")
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredVideos.length,
            itemBuilder: (context, index) {
              final video = filteredVideos[index];
              return _buildVideoItem(
                title: video["title"]!,
                speaker: video["speaker"]!,
                duration: video["duration"]!,
                views: video["views"]!,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAudiosTab() {
    final filteredAudios = audios.where((audio) {
      return audio["title"]!.toLowerCase().contains(_audioSearchQuery.toLowerCase()) ||
          audio["speaker"]!.toLowerCase().contains(_audioSearchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        _buildSearchBar(
          controller: _audioSearchController,
          hintText: "Rechercher un audio...",
          searchQuery: _audioSearchQuery,
          onChanged: (value) => setState(() => _audioSearchQuery = value),
          onClear: () => setState(() {
            _audioSearchController.clear();
            _audioSearchQuery = "";
          }),
        ),
        Expanded(
          child: filteredAudios.isEmpty
              ? _buildEmptyState("Aucun audio trouvé")
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredAudios.length,
            itemBuilder: (context, index) {
              final audio = filteredAudios[index];
              return _buildAudioItem(
                title: audio["title"]!,
                speaker: audio["speaker"]!,
                duration: audio["duration"]!,
                listens: audio["listens"]!,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionsTab() {
    final filteredQuestions = questions.where((question) {
      return question["question"].toLowerCase().contains(_questionSearchQuery.toLowerCase()) ||
          question["author"].toLowerCase().contains(_questionSearchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        _buildSearchBar(
          controller: _questionSearchController,
          hintText: "Rechercher une question...",
          searchQuery: _questionSearchQuery,
          onChanged: (value) => setState(() => _questionSearchQuery = value),
          onClear: () => setState(() {
            _questionSearchController.clear();
            _questionSearchQuery = "";
          }),
        ),
        Expanded(
          child: filteredQuestions.isEmpty
              ? _buildEmptyState("Aucune question trouvée")
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredQuestions.length,
            itemBuilder: (context, index) {
              final question = filteredQuestions[index];
              return _buildQuestionItemForAssociation(
                question: question["question"],
                author: question["author"],
                time: question["time"],
                hasAnswer: question["hasAnswer"],
                oustazeAnswer: question["oustazeAnswer"],
                answer: question["answer"],
              );
            },
          ),
        ),
      ],
    );
  }

// PARTIE 2 - À ajouter après la partie 1

  // ======================== WIDGETS PRIVÉS ========================

  Widget _buildSearchBar({
    required TextEditingController controller,
    required String hintText,
    required String searchQuery,
    required Function(String) onChanged,
    required VoidCallback onClear,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: onClear,
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(message, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, String value) {
    final isSelected = _eventFilter == value;
    return InkWell(
      onTap: () => setState(() => _eventFilter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[700],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 30),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildEventItem({
    required String title,
    required String date,
    required String startTime,
    required String endTime,
    required String location,
    required String theme,
    required String type,
    required bool isPast,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isPast ? Colors.grey.shade200 : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.event, color: isPast ? Colors.grey : Colors.green, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 12, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(date, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                        const SizedBox(width: 10),
                        Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text("$startTime - $endTime", style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 12, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(child: Text(location, style: TextStyle(fontSize: 11, color: Colors.grey[600]), maxLines: 1, overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPast ? Colors.grey.shade200 : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(type, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isPast ? Colors.grey : Colors.green)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailPage(
                      title: title,
                      description: "Détails complets de l'événement $title.",
                      date: date,
                      time: "$startTime - $endTime",
                      location: location,
                      association: widget.name,
                      isPast: isPast,
                    ),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Voir détails", style: TextStyle(color: AppColors.primary)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoItem({required String title, required String speaker, required String duration, required String views}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.red.shade300, Colors.red.shade600]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.play_circle_filled, color: Colors.white, size: 35),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.person, size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(speaker, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(duration, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                    const SizedBox(width: 10),
                    Icon(Icons.visibility, size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text("$views vues", style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioItem({required String title, required String speaker, required String duration, required String listens}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.orange.shade300, Colors.orange.shade600]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.headphones, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.person, size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(speaker, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(duration, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                    const SizedBox(width: 10),
                    Icon(Icons.headset, size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text("$listens écoutes", style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionItemForAssociation({
    required String question,
    required String author,
    required String time,
    required bool hasAnswer,
    String? oustazeAnswer,
    String? answer,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 16, color: Colors.grey[600]),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(author, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: hasAnswer ? Colors.green.shade50 : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  hasAnswer ? "Répondu" : "En attente",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: hasAnswer ? Colors.green : Colors.orange),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(question, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          if (hasAnswer && answer != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: const Icon(Icons.person, size: 14, color: AppColors.primary),
                      ),
                      const SizedBox(width: 8),
                      Text(oustazeAnswer!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text("Oustaze", style: TextStyle(fontSize: 9, color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(answer, style: const TextStyle(fontSize: 13, height: 1.4)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar child;
  _StickyTabBarDelegate(this.child);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.white, child: child);
  }

  @override
  double get maxExtent => child.preferredSize.height;
  @override
  double get minExtent => child.preferredSize.height;
  @override
  bool shouldRebuild(covariant _StickyTabBarDelegate oldDelegate) => child != oldDelegate.child;
}