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

  /// Inscription spécifique pour les associations
  Future<Map<String, dynamic>> registerAssociation({
    required String associationName,
    required String phone,
    required String password,
    required String city,
  }) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'first_name': associationName,  // Utilisé pour afficher le nom dans le dashboard
        'last_name': 'Association',
        'phone': phone,
        'password': password,
        'password_confirmation': password, // Laravel attend la confirmation
        'role': 'association',
        'city': city,
        'association_name': associationName, // Champ requis par la validation Laravel
      });

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response?.data;

        // Gérer les erreurs de validation Laravel
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

      return response.data; // Contient success, message, user, token
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
}