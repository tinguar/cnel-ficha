import 'dart:convert';
import 'package:cnel_ficha/enum/enum.dart';
import 'package:cnel_ficha/model/planification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../util/util.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key, required this.handleSearch});
  final Function(NotificationResponse) handleSearch;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  IdType _selectedIdType = IdType.CUEN;
  final TextEditingController _idController = TextEditingController();
  bool _isLoading = false; // Variable de estado para la carga

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              flex: 2,
              child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegexUtils.numberR)
                ],
                controller: _idController,
                decoration: const InputDecoration(
                  hintText: 'Buscar',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Flexible(
              flex: 3,
              child: DropdownButtonFormField<IdType>(
                value: _selectedIdType,
                items: idTypes.map((idType) {
                  return DropdownMenuItem<IdType>(
                    value: idType['value'] as IdType,
                    child: Text(idType['label'] as String),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedIdType = newValue!;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Tipo',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            context.isMobile ?  Container() : const  SizedBox(width: 10.0),
            Responsive(
                mobile: Container(),
                mobileLarge: buttonSearchWidget(),
                tablet: buttonSearchWidget(),
                desktop: buttonSearchWidget())
          ],
        ),
        context.isMobile
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: buttonSearchWidget(flex: 0, width: double.infinity),
              )
            : Container()
      ],
    );
  }

  Widget buttonSearchWidget({int? flex, double? width}) {
    return Flexible(
      flex: flex ?? 1,
      child: Container(
        decoration: DecorationStyle.greyBorder(
          color: ColorStyle.backgroundBlack,
        ),
        width: width,
        height: 45,
        child: InkWell(
          onTap: _isLoading
              ? null
              : _search, // Deshabilitar el botón mientras carga
          child: _isLoading // Mostrar indicador de carga o botón de búsqueda
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white))
              : context.isMobile
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.search_sharp,
                        color: Colors.white,
                      ),
                    )
                  : const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Buscar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
        ),
      ),
    );
  }

  Future<void> _search() async {
    if (_idController.text.isEmpty) {
      _showMessages('Por favor, ingrese un ID y seleccione un tipo.', 'Alerta');
      return;
    }

    setState(() {
      _isLoading = true; // Activar el estado de carga
    });

    try {
      String idValue = _idController.text;
      String idType =
          _selectedIdType.toString().split('.').last; // Convertir a string
      NotificationResponse notification =
          await fetchNotificacion(idValue, idType);
      widget.handleSearch(notification);
    } catch (e) {
      _showMessages('Valor no encontrado', 'ERROR');
    } finally {
      setState(() {
        _isLoading = false; // Desactivar el estado de carga
      });
    }
  }

  void _showMessages(String message, String messageTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            messageTitle.toUpperCase(),
            style: TextStyleS.textGlobal(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: ColorStyle.backgroundOrange),
          ),
          content: Text(
            message,
            style: TextStyleS.textGlobal(),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: TextStyleS.textGlobal(
                    fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar la alerta
              },
            ),
          ],
        );
      },
    );
  }

  Future<NotificationResponse> fetchNotificacion(
      String idValue, String idType) async {
    final response = await http.get(Uri.parse(
        'https://api.cnelep.gob.ec/servicios-linea/v1/notificaciones/consultar/$idValue/$idType'));

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      return NotificationResponse.fromJson(json.decode(responseBody));
    } else {
      throw Exception('Failed to load notificacion');
    }
  }
}
