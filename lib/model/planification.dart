class NotificationResponse {
  final String resp;
  final String? mensaje;
  final String? mensajeError;
  final String? extra;
  final List<NotificationF> notificaciones;

  NotificationResponse({
    required this.resp,
    this.mensaje,
    this.mensajeError,
    this.extra,
    required this.notificaciones,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      resp: json['resp'],
      mensaje: json['mensaje'],
      mensajeError: json['mensajeError'],
      extra: json['extra'],
      notificaciones: (json['notificaciones'] as List)
          .map((e) => NotificationF.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resp': resp,
      'mensaje': mensaje,
      'mensajeError': mensajeError,
      'extra': extra,
      'notificaciones': notificaciones.map((e) => e.toJson()).toList(),
    };
  }
}

class NotificationF {
  final int idUnidadNegocios;
  final String cuentaContrato;
  final String alimentador;
  final String cuen;
  final String direccion;
  final String fechaRegistro;
  final List<PlanningDetail> detallePlanificacion;

  NotificationF({
    required this.idUnidadNegocios,
    required this.cuentaContrato,
    required this.alimentador,
    required this.cuen,
    required this.direccion,
    required this.fechaRegistro,
    required this.detallePlanificacion,
  });

  factory NotificationF.fromJson(Map<String, dynamic> json) {
    return NotificationF(
      idUnidadNegocios: json['idUnidadNegocios'],
      cuentaContrato: json['cuentaContrato'],
      alimentador: json['alimentador'],
      cuen: json['cuen'],
      direccion: json['direccion'],
      fechaRegistro: json['fechaRegistro'],
      detallePlanificacion: (json['detallePlanificacion'] as List)
          .map((e) => PlanningDetail.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUnidadNegocios': idUnidadNegocios,
      'cuentaContrato': cuentaContrato,
      'alimentador': alimentador,
      'cuen': cuen,
      'direccion': direccion,
      'fechaRegistro': fechaRegistro,
      'detallePlanificacion':
          detallePlanificacion.map((e) => e.toJson()).toList(),
    };
  }
}

class PlanningDetail {
  final String alimentador;
  final String fechaCorte;
  final String horaDesde;
  final String horaHasta;
  final String comentario;
  final String fechaRegistro;
  final String fechaHoraCorte;

  PlanningDetail({
    required this.alimentador,
    required this.fechaCorte,
    required this.horaDesde,
    required this.horaHasta,
    required this.comentario,
    required this.fechaRegistro,
    required this.fechaHoraCorte,
  });

  factory PlanningDetail.fromJson(Map<String, dynamic> json) {
    return PlanningDetail(
      alimentador: json['alimentador'],
      fechaCorte: json['fechaCorte'],
      horaDesde: json['horaDesde'],
      horaHasta: json['horaHasta'],
      comentario: json['comentario'],
      fechaRegistro: json['fechaRegistro'],
      fechaHoraCorte: json['fechaHoraCorte'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alimentador': alimentador,
      'fechaCorte': fechaCorte,
      'horaDesde': horaDesde,
      'horaHasta': horaHasta,
      'comentario': comentario,
      'fechaRegistro': fechaRegistro,
      'fechaHoraCorte': fechaHoraCorte,
    };
  }
}
