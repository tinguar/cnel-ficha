import 'package:cnel_ficha/fichas_list.dart';
import 'package:cnel_ficha/model/planification.dart';
import 'package:cnel_ficha/widgets/custom_search_bar.dart';
import 'package:cnel_ficha/widgets/responsive_center.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  NotificationResponse? _notificacionResponse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // sugiero mejorar esto reemplazando el SingleChildScrollView
      //por un CustomScrollView usando Slivers
      body: SingleChildScrollView(
        child: ResponsiveCenter(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSearchBar(
                handleSearch: (notificacion) {
                  setState(() {
                    _notificacionResponse = notificacion;
                  });
                },
              ),
              const SizedBox(height: 16),
              if (_notificacionResponse != null) ...[
                Text('Respuesta: ${_notificacionResponse!.resp}'),
                if (_notificacionResponse!.mensaje != null)
                  Text('Mensaje: ${_notificacionResponse!.mensaje}'),
                if (_notificacionResponse!.mensajeError != null)
                  Text('Error: ${_notificacionResponse!.mensajeError}'),
                if (_notificacionResponse!.notificaciones.isNotEmpty) ...[
                  const Text('Notificaciones:'),
                  ..._notificacionResponse!.notificaciones.map((notification) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'ID Unidad Negocios: ${notification.idUnidadNegocios}'),
                        Text('Cuenta Contrato: ${notification.cuentaContrato}'),
                        Text('Alimentador: ${notification.alimentador}'),
                        Text('Código: ${notification.cuen}'),
                        Text('Dirección: ${notification.direccion}'),
                        Text('Fecha Registro: ${notification.fechaRegistro}'),
                        const Divider(),
                        const Text('Detalles de Planificación:'),
                        FichasList(notification: notification),
                      ],
                    );
                  }),
                ],
              ],
              const SizedBox(height: 50.0),
            ],
          ),
        ),
      ),
    );
  }
}
