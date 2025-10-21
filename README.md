# 📱 PerúFest 2025 - Sistema de Gestión de Eventos

## 📋 Información del Proyecto

**Curso:** Desarrollo de Aplicaciones Móviles II  
**Alumno:** Elvis Ronald Leyva Sardon
**Fecha:** Octubre 2025  
**Repositorio:** https://github.com/elvisleyva49/EXAMEN_U2_LEYVA.git

---

## 📖 Descripción del Proyecto

**PerúFest 2025** es una aplicación móvil desarrollada en Flutter que permite la gestión integral de eventos del Parque Perú. La aplicación cuenta con un sistema de autenticación robusto y funcionalidades diferenciadas para administradores y visitantes.

La app utiliza **Firebase Firestore** como base de datos principal y implementa un sistema de encriptación **bcrypt** para la seguridad de contraseñas.

---

## 👤 Historia de Usuario - Historial de Inicios de Sesión

### Historia de Usuario
> **Como** usuario autenticado,  
> **quiero** ver un historial de mis inicios de sesión,  
> **para** saber cuándo y desde qué dispositivo accedí a mi cuenta.

### 📋 Criterios de Aceptación

✅ **Registro Automático:** Al iniciar sesión exitosamente, se registra automáticamente:
- Usuario que inició sesión
- Fecha y hora del inicio de sesión (zona horaria Perú UTC-5)
- Dirección IP desde donde se conectó

✅ **Visualización del Historial:** En la sección "Historial de inicios de sesión", el usuario puede ver:
- Usuario (correo electrónico)
- Fecha y hora de inicio de sesión
- Dirección IP de conexión

✅ **Ordenamiento:** Los registros se muestran ordenados del más reciente al más antiguo

---

## ⚙️ Funcionalidades Implementadas

### 📊 Historial de Sesiones
- **Colección Firestore:** `registrosleyva` para almacenar logs
- **Registro automático** al hacer login exitoso
- **Pantalla de historial** accesible desde ambos dashboards
- **Zona horaria Perú** (UTC-5) para todos los registros
- **IP** para identificación de dispositivo

---

## 🚀 Funcionalidades del Sistema de Logs

### 📝 Registro de Sesión
```dart
// Registro automático al hacer login
await RegistroSesionService.registrarInicioSesion(
  usuarioId: usuario.id,
  correo: usuario.correo,
);
```

### 📖 Consulta de Historial
```dart
// Obtención del historial del usuario actual
final historial = await RegistroSesionService.obtenerHistorialUsuario(usuarioId);
```

### 🕐 Zona Horaria Perú
```dart
// Conversión automática a hora de Perú (UTC-5)
static DateTime _obtenerFechaHoraPeru() {
  final ahora = DateTime.now().toUtc();
  return ahora.subtract(const Duration(hours: 5));
}
```

---

## 🎯 Campos de la Colección `registrosleyva`

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `usuarioId` | String | ID único del usuario |
| `correo` | String | Email del usuario |
| `fechaHora` | Timestamp | Momento del inicio de sesión (Hora Perú) |
| `direccionIP` | String | IP del dispositivo |

---

## 📸 Capturas de Pantalla



> **Nota:** Las capturas de pantalla se incluirán como evidencia de las funcionalidades implementadas.

---

## 🔍 Índices de Firestore

### Índice Compuesto Requerido
**Colección:** `registrosleyva`
- `usuarioId` (Ascendente)
- `fechaHora` (Descendente)

Este índice es necesario para la consulta optimizada del historial ordenado por fecha.

---

*Desarrollado como parte del curso de Desarrollo de Aplicaciones Móviles II - 2025*