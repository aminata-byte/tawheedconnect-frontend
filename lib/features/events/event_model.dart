class Event {
  final int id;
  final String title;
  final String description;
  final String date;
  final String startTime;
  final String? endTime;
  final String location;
  final String speakers;
  final String status;
  final String? image;
  final DateTime? originalStartDate; // Date de début originale
  final DateTime? originalEndDate;   // Date de fin originale

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    this.endTime,
    required this.location,
    required this.speakers,
    required this.status,
    this.image,
    this.originalStartDate,
    this.originalEndDate,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    print('📥 Parsing événement: ${json['title']}');

    DateTime? startDate;
    DateTime? endDate;

    try {
      if (json['start_date'] != null) {
        startDate = DateTime.parse(json['start_date']);
      }
    } catch (e) {
      print('❌ Erreur parsing start_date: $e');
    }

    try {
      if (json['end_date'] != null) {
        endDate = DateTime.parse(json['end_date']);
      }
    } catch (e) {
      print('⚠️ end_date non parsable ou null');
    }

    String formattedDate = "Date non définie";
    if (startDate != null) {
      final months = [
        '', 'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin',
        'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'
      ];
      formattedDate = "${startDate.day} ${months[startDate.month]} ${startDate.year}";
    }

    String startTime = "Non défini";
    if (startDate != null) {
      startTime = "${startDate.hour.toString().padLeft(2, '0')}:${startDate.minute.toString().padLeft(2, '0')}";
    }

    String? endTime;
    if (endDate != null) {
      endTime = "${endDate.hour.toString().padLeft(2, '0')}:${endDate.minute.toString().padLeft(2, '0')}";
    }

    String speakers = "Non spécifié";
    if (json['organizers'] != null) {
      if (json['organizers'] is List) {
        final List<dynamic> organizersList = json['organizers'] as List;
        if (organizersList.isNotEmpty) {
          speakers = organizersList.join(", ");
        }
      } else if (json['organizers'] is String) {
        speakers = json['organizers'];
      }
    }

    return Event(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Sans titre',
      description: json['description'] ?? 'Aucune description',
      date: formattedDate,
      startTime: startTime,
      endTime: endTime,
      location: json['location'] ?? 'Lieu non spécifié',
      speakers: speakers,
      status: json['status']?.toLowerCase() ?? 'upcoming',
      image: json['image'],
      originalStartDate: startDate,
      originalEndDate: endDate, // ✅ Stocker aussi la date de fin
    );
  }

  // ✅ Méthode pour vérifier si l'événement est passé
  // Un événement est passé si son heure de FIN est avant maintenant
  bool get isPast {
    // Si on a une date de fin, on l'utilise
    if (originalEndDate != null) {
      return originalEndDate!.isBefore(DateTime.now());
    }

    // Sinon, on utilise la date de début
    if (originalStartDate != null) {
      return originalStartDate!.isBefore(DateTime.now());
    }

    return false;
  }

  // ✅ Méthode pour vérifier si l'événement est en cours
  bool get isOngoing {
    if (originalStartDate == null) return false;

    final now = DateTime.now();

    // Si on a une date de fin
    if (originalEndDate != null) {
      return now.isAfter(originalStartDate!) && now.isBefore(originalEndDate!);
    }

    // Sinon, l'événement est en cours s'il a commencé aujourd'hui
    return now.isAfter(originalStartDate!) &&
        now.difference(originalStartDate!).inHours < 24;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      'location': location,
      'speakers': speakers,
      'status': status,
      'image': image,
    };
  }
}