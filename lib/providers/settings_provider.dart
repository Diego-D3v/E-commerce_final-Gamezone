import 'package:flutter/foundation.dart';

class SettingsProvider extends ChangeNotifier {
  bool _notificaciones = true;
  bool _ofertas        = false;
  bool _modoOscuro     = true; // extra: conectar a ThemeData si se desea

  bool get notificaciones => _notificaciones;
  bool get ofertas        => _ofertas;
  bool get modoOscuro     => _modoOscuro;

  void toggleNotificaciones() { _notificaciones = !_notificaciones; notifyListeners(); }
  void toggleOfertas()        { _ofertas = !_ofertas; notifyListeners(); }
  void toggleModoOscuro()     { _modoOscuro = !_modoOscuro; notifyListeners(); }

  set notificaciones(bool v) { _notificaciones = v; notifyListeners(); }
  set ofertas(bool v)        { _ofertas = v; notifyListeners(); }
  set modoOscuro(bool v)     { _modoOscuro = v; notifyListeners(); }
}
