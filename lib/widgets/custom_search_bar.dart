import 'dart:convert';
import 'package:cnel_ficha/enum/enum.dart';
import 'package:cnel_ficha/model/planification.dart';
import 'package:cnel_ficha/util/regx.dart';
import 'package:cnel_ficha/util/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key, required this.handleSearch});
  final Function(NotificationResponse) handleSearch;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  IdType _selectedIdType = IdType.CUEN;
  final TextEditingController _idController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
        const SizedBox(width: 10.0),
        Flexible(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
                color: const Color(0xff272e3f),
                border: Border.all(),
                borderRadius: BorderRadius.circular(5)),
            height: 45,
            child: InkWell(
              onTap: _search,
              child: context.isDesktop || context.isTablet
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                          child: Text(
                        'Buscar',
                        style: TextStyle(color: Colors.white),
                      )))
                  : const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.search_sharp,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _search() async {
    if (_idController.text.isEmpty) {
      _showMessages('Por favor, ingrese un ID y seleccione un tipo.');
      return;
    }

    try {
      String idValue = _idController.text;
      String idType =
          _selectedIdType.toString().split('.').last; // Convertir a string
      NotificationResponse notification =
          await fetchNotificacion(idValue, idType);
      widget.handleSearch(notification);
    } catch (e) {
      _showMessages('Error: $e');
    }
  }

  void _showMessages(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<NotificationResponse> fetchNotificacion(
      String idValue, String idType) async {
    final response = await http.get(Uri.parse(
        'https://api.cnelep.gob.ec/servicios-linea/v1/notificaciones/consultar/$idValue/$idType'));

    if (response.statusCode == 200) {
      log(json.decode(response.body));
      String responseBody = utf8.decode(response.bodyBytes);
      return NotificationResponse.fromJson(json.decode(responseBody));
    } else {
      throw Exception('Failed to load notificacion');
    }
  }
}
