import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';

// ══════════════════════════════════════════════════════════════════════
// LOGIN SCREEN
// ══════════════════════════════════════════════════════════════════════
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey  = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() { _emailCtrl.dispose(); _passCtrl.dispose(); super.dispose(); }

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(_emailCtrl.text.trim(), _passCtrl.text);
    if (!mounted) return;
    if (ok) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 56),

                // ── Logo ──────────────────────────────────────────
                Center(
                  child: Column(children: [
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                            colors: [AppTheme.neonPurple, AppTheme.neonBlue]),
                        boxShadow: [BoxShadow(
                            color: AppTheme.neonPurple.withValues(alpha: 0.5),
                            blurRadius: 20)],
                      ),
                      child: const Icon(Icons.gamepad, color: Colors.white, size: 40),
                    ),
                    const SizedBox(height: 16),
                    ShaderMask(
                      shaderCallback: (b) => const LinearGradient(
                          colors: [AppTheme.neonPurple, AppTheme.neonBlue]).createShader(b),
                      child: const Text('GAMEZONE',
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900,
                            color: Colors.white, letterSpacing: 3)),
                    ),
                    const Text('Tu tienda de videojuegos',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                  ]),
                ),

                const SizedBox(height: 48),
                const Text('Iniciar Sesión',
                  style: TextStyle(color: AppTheme.textPrimary, fontSize: 24, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                const Text('Bienvenido de vuelta, gamer',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                const SizedBox(height: 28),

                // ── Email ─────────────────────────────────────────
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    prefixIcon: Icon(Icons.email_outlined, color: AppTheme.textMuted),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Ingresa tu correo';
                    if (!v.contains('@')) return 'Correo no válido';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // ── Password ──────────────────────────────────────
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.textMuted),
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: AppTheme.textMuted),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Ingresa tu contraseña';
                    if (v.length < 6) return 'Mínimo 6 caracteres';
                    return null;
                  },
                ),

                // ── Error ─────────────────────────────────────────
                if (auth.error != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.neonPink.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.neonPink.withValues(alpha: 0.3)),
                    ),
                    child: Row(children: [
                      const Icon(Icons.error_outline, color: AppTheme.neonPink, size: 16),
                      const SizedBox(width: 8),
                      Text(auth.error!, style: const TextStyle(color: AppTheme.neonPink, fontSize: 13)),
                    ]),
                  ),
                ],

                const SizedBox(height: 26),

                // ── Botón ─────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: auth.isLoading
                      ? const Center(child: CircularProgressIndicator(color: AppTheme.neonPurple))
                      : ElevatedButton(
                          onPressed: _onLogin,
                          child: const Text('INICIAR SESIÓN'),
                        ),
                ),

                const SizedBox(height: 14),

                // ── Demo hint ─────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.bgCard, borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.borderColor),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('💡 Cuenta demo:', style: TextStyle(color: AppTheme.neonBlue, fontSize: 12, fontWeight: FontWeight.w700)),
                      SizedBox(height: 4),
                      Text('Email: usuario@demo.com', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                      Text('Contraseña: 123456', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),

                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿No tienes cuenta? ', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                    GestureDetector(
                      onTap: () { auth.clearError(); context.push('/register'); },
                      child: const Text('Regístrate',
                        style: TextStyle(color: AppTheme.neonPurple, fontSize: 14, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// REGISTER SCREEN
// ══════════════════════════════════════════════════════════════════════
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey  = GlobalKey<FormState>();
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _pass2Ctrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose();
    _passCtrl.dispose(); _pass2Ctrl.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.register(_nameCtrl.text.trim(), _emailCtrl.text.trim(), _passCtrl.text);
    if (!mounted) return;
    if (ok) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear cuenta'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Text('¡Únete a GameZone!',
                  style: TextStyle(color: AppTheme.textPrimary, fontSize: 24, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                const Text('Crea tu cuenta y empieza a jugar',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                const SizedBox(height: 28),
                _field(_nameCtrl,  'Nombre completo',      Icons.person_outline, validator: (v) => v!.isEmpty ? 'Ingresa tu nombre' : null),
                const SizedBox(height: 14),
                _field(_emailCtrl, 'Correo electrónico',   Icons.email_outlined, type: TextInputType.emailAddress,
                  validator: (v) { if (v!.isEmpty) return 'Ingresa tu correo'; if (!v.contains('@')) return 'Correo inválido'; return null; }),
                const SizedBox(height: 14),
                _field(_passCtrl,  'Contraseña',           Icons.lock_outline, obscure: _obscure,
                  suffix: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: AppTheme.textMuted),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                  validator: (v) { if (v!.isEmpty) return 'Ingresa contraseña'; if (v.length < 6) return 'Mínimo 6 caracteres'; return null; }),
                const SizedBox(height: 14),
                _field(_pass2Ctrl, 'Confirmar contraseña', Icons.lock_outline, obscure: true,
                  validator: (v) { if (v!.isEmpty) return 'Confirma tu contraseña'; if (v != _passCtrl.text) return 'Las contraseñas no coinciden'; return null; }),
                if (auth.error != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.neonPink.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.neonPink.withValues(alpha: 0.3)),
                    ),
                    child: Text(auth.error!, style: const TextStyle(color: AppTheme.neonPink, fontSize: 13)),
                  ),
                ],
                const SizedBox(height: 26),
                SizedBox(
                  width: double.infinity,
                  child: auth.isLoading
                      ? const Center(child: CircularProgressIndicator(color: AppTheme.neonPurple))
                      : ElevatedButton(onPressed: _onRegister, child: const Text('CREAR CUENTA')),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿Ya tienes cuenta? ', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: const Text('Inicia sesión',
                        style: TextStyle(color: AppTheme.neonPurple, fontSize: 14, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label, IconData icon, {
    TextInputType? type, bool obscure = false, Widget? suffix, String? Function(String?)? validator,
  }) => TextFormField(
    controller: ctrl, obscureText: obscure, keyboardType: type,
    style: const TextStyle(color: AppTheme.textPrimary),
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppTheme.textMuted),
      suffixIcon: suffix,
    ),
    validator: validator,
  );
}
