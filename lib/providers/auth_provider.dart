import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../data/user_data.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading  => _isLoading;
  bool get isLoggedIn => _currentUser != null;
  String? get error   => _error;

  Future<bool> login(String email, String password) async {
    _isLoading = true; _error = null; notifyListeners();
    await Future.delayed(const Duration(milliseconds: 700));
    final user = UserData.login(email, password);
    if (user != null) {
      _currentUser = user; _isLoading = false; notifyListeners(); return true;
    }
    _error = 'Correo o contraseña incorrectos';
    _isLoading = false; notifyListeners(); return false;
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true; _error = null; notifyListeners();
    await Future.delayed(const Duration(milliseconds: 700));
    if (UserData.emailExists(email)) {
      _error = 'Este correo ya está registrado';
      _isLoading = false; notifyListeners(); return false;
    }
    _currentUser = UserData.register(name: name, email: email, password: password);
    _isLoading = false; notifyListeners(); return true;
  }

  void logout() { _currentUser = null; _error = null; notifyListeners(); }
  void clearError() { _error = null; notifyListeners(); }

  void updateProfile({String? name}) {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(name: name);
    UserData.update(_currentUser!);
    notifyListeners();
  }
}
