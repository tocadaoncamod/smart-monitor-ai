import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _initAuth();
  }

  /// Inicializa autenticação
  Future<void> _initAuth() async {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });

    // Verificar se há usuário logado
    _user = _auth.currentUser;
    notifyListeners();
  }

  /// Login com email e senha
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = credential.user;
      _isLoading = false;
      notifyListeners();
      
      // Salvar credenciais localmente (opcional)
      await _saveCredentials(email);
      
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      
      switch (e.code) {
        case 'user-not-found':
          _error = 'Usuário não encontrado';
          break;
        case 'wrong-password':
          _error = 'Senha incorreta';
          break;
        case 'invalid-email':
          _error = 'Email inválido';
          break;
        case 'user-disabled':
          _error = 'Usuário desabilitado';
          break;
        default:
          _error = 'Erro ao fazer login: ${e.message}';
      }
      
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _error = 'Erro inesperado: $e';
      notifyListeners();
      return false;
    }
  }

  /// Registrar novo usuário
  Future<bool> signUp(String email, String password, String name) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Atualizar nome do usuário
      await credential.user?.updateDisplayName(name);
      
      _user = credential.user;
      _isLoading = false;
      notifyListeners();
      
      await _saveCredentials(email);
      
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      
      switch (e.code) {
        case 'weak-password':
          _error = 'Senha muito fraca (mínimo 6 caracteres)';
          break;
        case 'email-already-in-use':
          _error = 'Email já está em uso';
          break;
        case 'invalid-email':
          _error = 'Email inválido';
          break;
        default:
          _error = 'Erro ao criar conta: ${e.message}';
      }
      
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _error = 'Erro inesperado: $e';
      notifyListeners();
      return false;
    }
  }

  /// Logout
  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  /// Resetar senha
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _auth.sendPasswordResetEmail(email: email);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      
      switch (e.code) {
        case 'user-not-found':
          _error = 'Usuário não encontrado';
          break;
        case 'invalid-email':
          _error = 'Email inválido';
          break;
        default:
          _error = 'Erro ao resetar senha: ${e.message}';
      }
      
      notifyListeners();
      return false;
    }
  }

  /// Salvar credenciais localmente
  Future<void> _saveCredentials(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_email', email);
  }

  /// Carregar último email usado
  Future<String?> getLastEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('last_email');
  }

  /// Limpar erro
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
