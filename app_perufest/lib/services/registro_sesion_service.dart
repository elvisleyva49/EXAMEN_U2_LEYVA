import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import '../models/registro_sesion.dart';

class RegistroSesionService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'registrosleyva';

  /// Registra un nuevo inicio de sesión
  static Future<void> registrarInicioSesion({
    required String usuarioId,
    required String correo,
  }) async {
    try {
      // Obtener IP (simulada para móvil)
      final direccionIP = await _obtenerDireccionIP();
      
      // 🇵🇪 OBTENER FECHA Y HORA EN ZONA HORARIA DE PERÚ
      final fechaHoraPeru = _obtenerFechaHoraPeru();
      
      final registro = RegistroSesion(
        id: '',
        usuarioId: usuarioId,
        correo: correo,
        fechaHora: fechaHoraPeru,
        direccionIP: direccionIP,
      );

      await _firestore.collection(_collection).add(registro.toJson());
      print('✅ Registro de sesión guardado para: $correo en hora de Perú: ${fechaHoraPeru.toString()}');
    } catch (e) {
      print('❌ Error al registrar inicio de sesión: $e');
    }
  }

  /// Obtiene historial de inicios de sesión de un usuario
  static Future<List<RegistroSesion>> obtenerHistorialUsuario(String usuarioId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('usuarioId', isEqualTo: usuarioId)
          .orderBy('fechaHora', descending: true) // Más reciente primero
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return RegistroSesion.fromJson(data);
      }).toList();
    } catch (e) {
      print('❌ Error al obtener historial: $e');
      return [];
    }
  }

  /// 🇵🇪 OBTENER FECHA Y HORA EN ZONA HORARIA DE PERÚ (UTC-5)
  static DateTime _obtenerFechaHoraPeru() {
    final ahora = DateTime.now().toUtc();
    // Perú está en UTC-5 (sin cambio de horario de verano)
    final fechaHoraPeru = ahora.subtract(const Duration(hours: 5));
    return fechaHoraPeru;
  }

  /// Simula obtener dirección IP (en móvil es complejo obtener la IP real)
  static Future<String> _obtenerDireccionIP() async {
    try {
      // En un entorno real, podrías usar un servicio web para obtener la IP
      // Por ahora usamos una IP simulada con timestamp para diferenciación
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      return '192.168.1.${timestamp % 255}';
    } catch (e) {
      return 'IP no disponible';
    }
  }
}