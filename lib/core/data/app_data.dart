import 'package:flutter/material.dart';

// ==================== ADMINS ====================
List<Map<String, String>> globalAdmins = [];

// ==================== DEMANDES URGENTES ====================
List<Map<String, dynamic>> urgentRequests = [];

void addUrgentRequest({
  required String memberName,
  required String phone,
  required String message,
}) {
  urgentRequests.add({
    'id': DateTime.now().millisecondsSinceEpoch.toString(),
    'memberName': memberName,
    'phone': phone,
    'message': message,
    'date': DateTime.now(),
    'status': 'pending',
  });
}

int getPendingRequestsCount() {
  return urgentRequests.where((req) => req['status'] == 'pending').length;
}

// ==================== QUÊTES ====================
List<Map<String, dynamic>> publishedQuests = [];

// ==================== ABONNEMENTS ====================
Map<String, List<String>> memberSubscriptions = {};

// ==================== FONCTION UNIQUE POUR PUBLIER UNE QUÊTE ====================
void publishQuest({
  required String associationName,
  required String title,
  required String description,
  required String targetAmount,
  String currentAmount = "0",
  bool isClosed = false,
  required String beneficiaryName,
  required String beneficiaryPhone,
  String maintenanceFee = "0",
  bool isRecurring = false, // ✅ Gère l'automatisme (ex: maintenance)
  String? urgentRequestId,
}) {
  double target = double.tryParse(targetAmount) ?? 0.0;
  double current = double.tryParse(currentAmount) ?? 0.0;

  publishedQuests.add({
    'id': DateTime.now().millisecondsSinceEpoch.toString(),
    'associationName': associationName,
    'title': title,
    'description': description,
    'targetAmount': targetAmount,
    'currentAmount': currentAmount,
    'beneficiaryName': beneficiaryName,
    'beneficiaryPhone': beneficiaryPhone,
    'maintenanceFee': maintenanceFee,
    'isRecurring': isRecurring,
    'recurrenceDay': 5, // ✅ Planifié pour chaque 5 du mois
    'datePublished': DateTime.now(),
    'status': (isClosed || (target > 0 && current >= target)) ? 'completed' : 'active',
    'donations': [],
    'totalCollected': current,
    'urgentRequestId': urgentRequestId,
  });
}

// ==================== GESTION DES ABONNEMENTS ====================
void subscribeToAssociation(String memberId, String associationName) {
  if (!memberSubscriptions.containsKey(memberId)) {
    memberSubscriptions[memberId] = [];
  }
  if (!memberSubscriptions[memberId]!.contains(associationName)) {
    memberSubscriptions[memberId]!.add(associationName);
  }
}

void unsubscribeFromAssociation(String memberId, String associationName) {
  if (memberSubscriptions.containsKey(memberId)) {
    memberSubscriptions[memberId]!.remove(associationName);
  }
}

bool isSubscribedToAssociation(String memberId, String associationName) {
  return memberSubscriptions[memberId]?.contains(associationName) ?? false;
}

// ==================== RÉCUPÉRATION DES DONNÉES ====================
List<Map<String, dynamic>> getQuestsForMember(String memberId) {
  if (!memberSubscriptions.containsKey(memberId)) return [];
  List<String> subscriptions = memberSubscriptions[memberId]!;
  return publishedQuests.where((quest) {
    return subscriptions.contains(quest['associationName']) &&
        quest['status'] == 'active';
  }).toList();
}

List<Map<String, dynamic>> getQuestsForAssociation(String associationName) {
  return publishedQuests.where((quest) => quest['associationName'] == associationName).toList();
}

int getActiveQuestsCount(String associationName) {
  return publishedQuests.where((q) => q['associationName'] == associationName && q['status'] == 'active').length;
}

int getSubscribersCount(String associationName) {
  int count = 0;
  memberSubscriptions.forEach((id, list) {
    if (list.contains(associationName)) count++;
  });
  return count;
}

// ==================== ACTIONS ET DONS ====================
void cancelQuest(String questId) {
  for (var q in publishedQuests) {
    if (q['id'] == questId) {
      q['status'] = 'cancelled';
      break;
    }
  }
}

void completeQuest(String questId) {
  for (var q in publishedQuests) {
    if (q['id'] == questId) {
      q['status'] = 'completed';
      break;
    }
  }
}

void addDonation({
  required String questId,
  required String donorName,
  required double amount,
}) {
  for (var q in publishedQuests) {
    if (q['id'] == questId) {
      q['donations'].add({
        'donorName': donorName,
        'amount': amount,
        'date': DateTime.now(),
      });
      // Gestion de la mise à jour du total
      double currentTotal = double.tryParse(q['currentAmount'].toString()) ?? 0.0;
      q['currentAmount'] = (currentTotal + amount).toString();

      // Vérification auto de clôture
      double target = double.tryParse(q['targetAmount'].toString()) ?? 0.0;
      if (target > 0 && (currentTotal + amount) >= target) {
        q['status'] = 'completed';
      }
      break;
    }
  }
}