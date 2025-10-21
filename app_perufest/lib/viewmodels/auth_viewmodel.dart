import 'package:flutter/foundation.dart';
import '../models/usuario.dart';
import '../services/firestore_service.dart';
import 'package:bcrypt/bcrypt.dart';
import '../services/registro_sesion_service.dart';
import '../models/registro_sesion.dart';

enum AuthState { idle, loading, success, error }

class AuthViewModel extends ChangeNotifier {
  AuthState _state = AuthState.idle;
  String _errorMessage = '';
  Usuario? _currentUser;
  List<RegistroSesion> _historialSesiones = [];

  AuthState get state => _state;
  String get errorMessage => _errorMessage;
  Usuario? get currentUser => _currentUser;
  List<RegistroSesion> get historialSesiones => _historialSesiones;
  bool get isLoading => _state == AuthState.loading;
  bool get isLoggedIn => _currentUser != null;

  Future<void> registrar({
    required String nombre,
    required String username,
    required String correo,
    required String telefono,
    required String rol,
    required String contrasena,
  }) async {
    if (_state == AuthState.loading) return;

    _setState(AuthState.loading);

    try {
      // Pequeño delay para mostrar el estado de carga
      await Future.delayed(const Duration(milliseconds: 100));

      // Verificar si el correo ya existe
      final correoExiste = await FirestoreService.correoExiste(correo);
      if (correoExiste) {
        _setError('El correo ya está registrado');
        return;
      }

      // Encriptar la contraseña con bcrypt
      final contrasenaEncriptada = BCrypt.hashpw(contrasena, BCrypt.gensalt());

      final usuario = Usuario(
        id: '',
        nombre: nombre,
        username: username,
        correo: correo,
        telefono: telefono,
        rol: rol,
        contrasena: contrasenaEncriptada,
      );

      await FirestoreService.registrarUsuario(usuario);

      _setState(AuthState.success);
      if (kDebugMode) {
        debugPrint('Usuario registrado exitosamente: $correo');
      }
    } catch (e) {
      _setError('Error al registrar usuario');
      if (kDebugMode) {
        debugPrint('Error al registrar usuario: $e');
      }
    }
  }

  Future<void> login(String correo, String contrasena) async {
    if (_state == AuthState.loading) return;

    _setState(AuthState.loading);

    try {
      await Future.delayed(const Duration(milliseconds: 100));

      final usuario = await FirestoreService.loginUsuario(correo, contrasena);

      if (usuario != null) {
        _currentUser = usuario;
        
        // 🆕 REGISTRAR INICIO DE SESIÓN
        await RegistroSesionService.registrarInicioSesion(
          usuarioId: usuario.id,
          correo: usuario.correo,
        );
        
        _setState(AuthState.success);
        if (kDebugMode) {
          debugPrint('Login exitoso para: ${usuario.nombre}');
        }
      } else {
        _setError('Credenciales incorrectas');
      }
    } catch (e) {
      _setError('Error al hacer login');
      if (kDebugMode) {
        debugPrint('Error al hacer login: $e');
      }
    }
  }

  void logout() {
    _currentUser = null;
    _setState(AuthState.idle);
    if (kDebugMode) {
      debugPrint('Usuario deslogueado');
    }
  }

  Future<void> cargarHistorialSesiones() async {
    if (_currentUser == null) return;

    try {
      _historialSesiones = await RegistroSesionService.obtenerHistorialUsuario(_currentUser!.id);
      notifyListeners();
      if (kDebugMode) {
        debugPrint('Historial cargado: ${_historialSesiones.length} registros');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error al cargar historial: $e');
      }
    }
  }

  // Método para actualizar los datos del usuario actual
  Future<void> actualizarUsuario() async {
    if (_currentUser == null) return;

    try {
      final usuarioActualizado = await FirestoreService.obtenerUsuarioPorId(_currentUser!.id);
      if (usuarioActualizado != null) {
        _currentUser = usuarioActualizado;
        notifyListeners();
        if (kDebugMode) {
          debugPrint('Datos del usuario actualizados: ${usuarioActualizado.nombre}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error al actualizar datos del usuario: $e');
      }
    }
  }

  void resetState() {
    _setState(AuthState.idle);
  }

  void _setState(AuthState newState) {
    _state = newState;
    if (newState != AuthState.error) {
      _errorMessage = '';
    }
    notifyListeners();
  }

  void _setError(String message) {
    _state = AuthState.error;
    _errorMessage = message;
    notifyListeners();
  }
}
