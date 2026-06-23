import '../models/user_model.dart';

// Credenciales demo hardcodeadas (README taller)
const String kDemoEmail = 'usuario@demo.com';
//const String kDemoEmail = 'deach@demo.com';
const String kDemoPassword = '123456';

class UserData {
  static final List<UserModel> _users = [
    UserModel(
      id: 'u001',
      name: 'Demo User',
      email: kDemoEmail,
      password: kDemoPassword,
      createdAt: DateTime(2024, 1, 15),
    ),
    UserModel(
      id: 'u002',
      name: 'Gamer Pro',
      email: 'gamer@gamezone.com',
      password: 'gamer123',
      createdAt: DateTime(2024, 3, 20),
    ),
  ];

  static UserModel? login(String email, String password) {
    try {
      return _users.firstWhere(
        (u) =>
            u.email.toLowerCase() == email.toLowerCase() &&
            u.password == password,
      );
    } catch (_) {
      return null;
    }
  }

  static bool emailExists(String email) =>
      _users.any((u) => u.email.toLowerCase() == email.toLowerCase());

  static UserModel register(
      {required String name, required String email, required String password}) {
    final u = UserModel(
      id: 'u${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      password: password,
      createdAt: DateTime.now(),
    );
    _users.add(u);
    return u;
  }

  static void update(UserModel updated) {
    final idx = _users.indexWhere((u) => u.id == updated.id);
    if (idx != -1) _users[idx] = updated;
  }
}
