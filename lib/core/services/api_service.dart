import 'package:dio/dio.dart';

class ApiService {
  // URL de ton serveur Laravel local
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // ========== SINGLETON PATTERN ==========
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();
  // ========================================

  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  ));

  // ==========================================
  // AUTHENTIFICATION
  // ==========================================

  /// Inscription membre ou association
  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
    required String role, // 'member' ou 'association'
    String? city,
    String? email,
  }) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'password': password,
        'password_confirmation': password,
        'role': role,
        'city': city,
        'email': email,
      });

      if (response.data['token'] != null) {
        setToken(response.data['token']);
      }

      return response.data;
    } on DioException catch (e) {
      String error = 'Erreur inconnue';
      if (e.response != null) {
        error = e.response?.data['message'] ?? 'Erreur serveur';
      } else {
        error = 'Impossible de joindre le serveur. Laravel est lancé ?';
      }
      throw Exception(error);
    }
  }

  /// Inscription spécifique pour les associations (SANS logo)
  Future<Map<String, dynamic>> registerAssociation({
    required String associationName,
    required String phone,
    required String password,
    required String city,
  }) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'first_name': associationName,
        'last_name': 'Association',
        'phone': phone,
        'password': password,
        'password_confirmation': password,
        'role': 'association',
        'city': city,
        'association_name': associationName,
      });

      if (response.data['token'] != null) {
        setToken(response.data['token']);
      }

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response?.data;
        if (errorData['errors'] != null) {
          final errors = errorData['errors'] as Map<String, dynamic>;
          final firstError = errors.values.first[0].toString();
          throw Exception(firstError);
        }
        throw Exception(errorData['message'] ?? 'Erreur d\'inscription');
      }
      throw Exception('Impossible de joindre le serveur. Laravel est lancé ?');
    }
  }

  /// Inscription avec logo (MultipartRequest)
  Future<Map<String, dynamic>> registerAssociationWithLogo({
    required String associationName,
    required String phone,
    required String password,
    required String city,
    required String logoPath,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'first_name': associationName,
        'last_name': 'Association',
        'phone': phone,
        'password': password,
        'password_confirmation': password,
        'role': 'association',
        'city': city,
        'association_name': associationName,
        'logo': await MultipartFile.fromFile(logoPath, filename: 'logo.jpg'),
      });

      final response = await _dio.post(
        '/auth/register',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.data['token'] != null) {
        setToken(response.data['token']);
      }

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response?.data;
        if (errorData['errors'] != null) {
          final errors = errorData['errors'] as Map<String, dynamic>;
          final firstError = errors.values.first[0].toString();
          throw Exception(firstError);
        }
        throw Exception(errorData['message'] ?? 'Erreur d\'inscription');
      }
      throw Exception('Impossible de joindre le serveur. Laravel est lancé ?');
    }
  }

  /// Connexion (login)
  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'phone': phone,
        'password': password,
      });

      if (response.data['token'] != null) {
        setToken(response.data['token']);
      }

      return response.data;
    } on DioException catch (e) {
      String error = e.response?.data['message'] ?? 'Numéro ou mot de passe incorrect';
      throw Exception(error);
    }
  }

  /// Vérifier le code SMS reçu
  Future<Map<String, dynamic>> verifyPhone({
    required String phone,
    required String code,
  }) async {
    try {
      final response = await _dio.post('/auth/verify-phone', data: {
        'phone': phone,
        'code': code,
      });

      return response.data;
    } on DioException catch (e) {
      String error = e.response?.data['message'] ?? 'Code invalide ou expiré';
      throw Exception(error);
    }
  }

  /// Obtenir l'utilisateur connecté (protégé par Sanctum)
  Future<Map<String, dynamic>> me() async {
    try {
      print('🔍 Appel API /auth/me avec headers: ${_dio.options.headers}');
      final response = await _dio.get('/auth/me');
      return response.data;
    } on DioException catch (e) {
      print('❌ Erreur API /auth/me: ${e.response?.statusCode} - ${e.response?.data}');
      String error = e.response?.data['message'] ?? 'Erreur de connexion';
      throw Exception(error);
    }
  }

  /// Renvoyer un nouveau code de vérification
  Future<Map<String, dynamic>> resendCode({
    required String phone,
  }) async {
    try {
      final response = await _dio.post('/auth/resend-code', data: {
        'phone': phone,
      });
      return response.data;
    } on DioException catch (e) {
      String error = e.response?.data['message'] ?? 'Erreur lors de l\'envoi du code';
      throw Exception(error);
    }
  }

  /// Demande de réinitialisation du code PIN
  Future<Map<String, dynamic>> forgotPassword(String phone) async {
    try {
      final response = await _dio.post(
        '/auth/forgot-password',
        data: {'phone': phone},
      );
      print('✅ Réponse forgot-password: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      print('❌ Erreur forgot-password: ${e.response?.data}');
      if (e.response?.data != null) return e.response!.data;
      return {'success': false, 'message': 'Erreur de connexion au serveur'};
    } catch (e) {
      return {'success': false, 'message': 'Une erreur est survenue'};
    }
  }

  /// Réinitialisation du mot de passe avec le code reçu
  Future<Map<String, dynamic>> resetPassword({
    required String phone,
    required String code,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/reset-password',
        data: {
          'phone': phone,
          'code': code,
          'password': password,
          'password_confirmation': password,
        },
      );
      print('✅ Réponse reset-password: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      if (e.response?.data != null) return e.response!.data;
      return {'success': false, 'message': 'Erreur de connexion au serveur'};
    }
  }

  // ==========================================
  // GESTION DU TOKEN
  // ==========================================

  /// Définir le token d'authentification
  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
    print('✅ Token défini dans l\'instance singleton: Bearer ${token.substring(0, 20)}...');
  }

  /// Supprimer le token d'authentification
  void clearToken() {
    _dio.options.headers.remove('Authorization');
    print('🗑️ Token supprimé');
  }

  /// Vérifier si un token existe
  bool hasToken() {
    return _dio.options.headers['Authorization'] != null;
  }

  // ==========================================
  // GESTION DES OUSTAZES
  // ==========================================

  /// Ajouter un Oustaze (Dashboard Association)
  Future<Map<String, dynamic>> addOustaze({
    required String name,
    required String speciality,
    required String phone,
  }) async {
    try {
      final response = await _dio.post('/oustazes', data: {
        'nom_complet': name,
        'specialites': speciality,
        'telephone': phone,
      });
      return response.data;
    } on DioException catch (e) {
      String error = e.response?.data['message'] ?? 'Erreur lors de l\'ajout';
      throw Exception(error);
    }
  }

  /// Récupérer la liste des Oustazes de l'association connectée
  Future<List<dynamic>> getOustazes({int? associationId}) async {
    try {
      String endpoint = '/oustazes';
      if (associationId != null) {
        endpoint += '?association_id=$associationId';
      }

      final response = await _dio.get(endpoint);
      if (response.data['success'] == true) return response.data['data'];
      return [];
    } on DioException catch (e) {
      throw Exception('Erreur lors de la récupération des oustazes');
    }
  }

  /// Voir les détails d'un oustaze
  Future<Map<String, dynamic>> getOustazeById(int id) async {
    try {
      final response = await _dio.get('/oustazes/$id');
      return response.data;
    } on DioException catch (e) {
      String error = e.response?.data['message'] ?? 'Oustaze introuvable';
      throw Exception(error);
    }
  }

  /// Modifier un Oustaze existant
  Future<Map<String, dynamic>> updateOustaze({
    required int id,
    required String name,
    required String speciality,
    required String phone,
  }) async {
    try {
      final response = await _dio.put('/oustazes/$id', data: {
        'nom_complet': name,
        'specialites': speciality,
        'telephone': phone,
      });
      return response.data;
    } on DioException catch (e) {
      String error = e.response?.data['message'] ?? 'Erreur lors de la modification';
      throw Exception(error);
    }
  }

  /// Supprimer un Oustaze
  Future<bool> deleteOustaze(int id) async {
    try {
      final response = await _dio.delete('/oustazes/$id');
      return response.data['success'] == true;
    } on DioException catch (e) {
      return false;
    }
  }

  // ==========================================
  // GESTION DES ÉVÉNEMENTS
  // ==========================================

  /// Ajouter un événement (Dashboard Association)
  Future<Map<String, dynamic>> addEvent({
    required String title,
    required String description,
    required String location,
    required String date,
    required String startTime,
    String? endTime,
    required String speakers,
    String? imagePath,
  }) async {
    try {
      FormData formData = FormData();

      // ✅ CORRECTION : 'date' au lieu de 'event_date'
      formData.fields.add(MapEntry('title', title));
      formData.fields.add(MapEntry('description', description));
      formData.fields.add(MapEntry('location', location));
      formData.fields.add(MapEntry('date', date)); // ✅ Changé
      formData.fields.add(MapEntry('start_time', startTime));
      formData.fields.add(MapEntry('speakers', speakers));

      if (endTime != null && endTime.isNotEmpty) {
        formData.fields.add(MapEntry('end_time', endTime));
      }

      if (imagePath != null && imagePath.isNotEmpty) {
        formData.files.add(MapEntry(
          'image',
          await MultipartFile.fromFile(
            imagePath,
            filename: imagePath.split('/').last,
          ),
        ));
      }

      // 🔍 LOG de débogage
      print('📤 Envoi des données événement:');
      for (var field in formData.fields) {
        print('  ${field.key}: ${field.value}');
      }
      if (formData.files.isNotEmpty) {
        print('  Image: ${formData.files.first.value.filename}');
      }

      final response = await _dio.post(
        '/events',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      print('✅ Réponse API événement: ${response.data}');
      return response.data;

    } on DioException catch (e) {
      print("❌ Erreur complète événement: ${e.response?.data}");

      if (e.response?.data != null) {
        // Gestion des erreurs de validation
        if (e.response?.data['errors'] != null) {
          final errors = e.response?.data['errors'] as Map<String, dynamic>;
          final firstError = errors.values.first[0].toString();
          throw Exception(firstError);
        }
        throw Exception(e.response?.data['message'] ?? "Erreur serveur");
      }

      throw Exception("Erreur de connexion au serveur");
    }
  }

  /// Récupérer la liste des événements
  Future<List<dynamic>> getEvents() async {
    try {
      final response = await _dio.get('/events');
      print('🔍 getEvents API response: ${response.data}'); // DEBUG

      if (response.data['success'] == true) {
        // Vérifier la structure exacte renvoyée par Laravel
        if (response.data['data'] is Map && response.data['data']['events'] != null) {
          return response.data['data']['events']; // Si les events sont dans data.events
        } else if (response.data['data'] is List) {
          return response.data['data']; // Si data est déjà une liste
        }
      }

      return [];
    } on DioException catch (e) {
      print('❌ Erreur getEvents: ${e.response?.data}');
      throw Exception('Erreur lors de la récupération des événements');
    }
  }


} // Fin de la classe ApiService