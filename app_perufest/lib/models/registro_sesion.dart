import 'package:cloud_firestore/cloud_firestore.dart';

class RegistroSesion {
  final String id;
  final String usuarioId;
  final String correo;
  final DateTime fechaHora;
  final String direccionIP;

  RegistroSesion({
    required this.id,
    required this.usuarioId,
    required this.correo,
    required this.fechaHora,
    required this.direccionIP,
  });

  factory RegistroSesion.fromJson(Map<String, dynamic> json) {
    return RegistroSesion(
      id: json['id']?.toString() ?? '',
      usuarioId: json['usuarioId'] ?? '',
      correo: json['correo'] ?? '',
      fechaHora: (json['fechaHora'] as Timestamp).toDate(),
      direccionIP: json['direccionIP'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuarioId': usuarioId,
      'correo': correo,
      'fechaHora': Timestamp.fromDate(fechaHora),
      'direccionIP': direccionIP,
    };
  }

  /// 🇵🇪 FORMATO DE FECHA Y HORA PARA PERÚ
  String get fechaHoraFormateada {
    return '${fechaHora.day.toString().padLeft(2, '0')}/'
           '${fechaHora.month.toString().padLeft(2, '0')}/'
           '${fechaHora.year} '
           '${fechaHora.hour.toString().padLeft(2, '0')}:'
           '${fechaHora.minute.toString().padLeft(2, '0')} '
           '(Hora Perú)';
  }
}