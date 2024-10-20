import 'dart:convert';

import 'package:cnel_ficha/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'enum/enum.dart';
import 'firebase_options.dart';
import 'model/model.dart';
import 'util/regx.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchScreen(),
    );
  }
}

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

// 2000005742
class _SearchScreenState extends State<SearchScreen> {
  IdType _selectedIdType = IdType.CUEN;
  final TextEditingController _idController = TextEditingController();
  NotificationResponse? _notificacion;
  @override
  Widget build(BuildContext context) {
    double reponsiveS(BuildContext context) {
      if (context.isDesktop) {
        return 200;
      } else if (context.isTablet) {
        return 0;
      } else if (context.isMobileLarge) {
        return 0;
      }else {
        return 0;

      }
    }

    int getCrossAxisCount(BuildContext context) {
      if (context.isDesktop) {
        return 3; // 5 columnas para desktop
      } else if (context.isTablet) {
        return 2; // 2 columnas para tablet
      } else {
        return 1; // 1 columna para mobile
      }
    }

    return Scaffold(
      appBar: AppBar(
      ),
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: reponsiveS(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fila que contiene el cuadro de búsqueda, Dropdown y botón
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Cuadro de búsqueda
                      Flexible(
                        flex: 2,
                        child: TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegexUtils.numberR)
                          ],
                          controller: _idController,
                          decoration: const InputDecoration(
                            hintText: 'Buscar',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0), // Espacio entre elementos

                      // Dropdown para seleccionar el tipo
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
                      const SizedBox(width: 10.0), // Espacio entre elementos

                      Flexible(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xff272e3f),
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(5)),
                          height: 45,
                          child: InkWell(
                            onTap: () async {
                              if (_idController.text.isEmpty ||
                                  _selectedIdType == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Por favor, ingrese un ID y seleccione un tipo.'),
                                  ),
                                );
                                return;
                              }

                              try {
                                String idValue = _idController.text;
                                String idType = _selectedIdType
                                    .toString()
                                    .split('.')
                                    .last; // Convertir a string
                                NotificationResponse notification =
                                    await fetchNotificacion(idValue, idType);
                                setState(() {
                                  _notificacion =
                                      notification; // Almacenar la notificación recibida
                                });
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                  ),
                                );
                              }
                            },
                            child: context.isDesktop
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
                  ),
                  const SizedBox(height: 16),
                  if (_notificacion != null) ...[
                    Text('Respuesta: ${_notificacion!.resp}'),
                    if (_notificacion!.mensaje != null)
                      Text('Mensaje: ${_notificacion!.mensaje}'),
                    if (_notificacion!.mensajeError != null)
                      Text('Error: ${_notificacion!.mensajeError}'),
                    if (_notificacion!.notificaciones.isNotEmpty) ...[
                      const Text('Notificaciones:'),
                      ..._notificacion!.notificaciones.map((n) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID Unidad Negocios: ${n.idUnidadNegocios}'),
                            Text('Cuenta Contrato: ${n.cuentaContrato}'),
                            Text('Alimentador: ${n.alimentador}'),
                            Text('Código: ${n.cuen}'),
                            Text('Dirección: ${n.direccion}'),
                            Text('Fecha Registro: ${n.fechaRegistro}'),
                            const Divider(),
                            const Text('Detalles de Planificación:'),
                            // Usar GridView para mostrar los detalles
                            GridView.builder(
                              physics:
                                  const NeverScrollableScrollPhysics(), // Evita el scroll dentro del grid
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: getCrossAxisCount(context),
                                childAspectRatio: 1.6,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                              ),
                              itemCount:
                                  _groupDetailsByDate(n.detallePlanificacion)
                                      .length,
                              itemBuilder: (context, index) {
                                String fechaCorte =
                                    _groupDetailsByDate(n.detallePlanificacion)
                                        .keys
                                        .elementAt(index);
                                List<PlanningDetail> detalles =
                                    _groupDetailsByDate(
                                        n.detallePlanificacion)[fechaCorte]!;
                                String input = fechaCorte;
                                final RegExp regex = RegExp(r'de 2024');
                                String output = input.replaceAll(regex, '');
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: const Color(0xff272e3f),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize
                                          .min, // Respetar el tamaño mínimo de la columna
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(output,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        ...detalles.map((detail) {
                                          return Card(
                                            elevation: 4,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize
                                                    .min, // Respetar el tamaño mínimo de la columna
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                          'Desde: ${detail.horaDesde}'),
                                                      const SizedBox(
                                                          width: 15.0),
                                                      Text(
                                                          'Hasta: ${detail.horaHasta}'),
                                                    ],
                                                  ),
                                                  // Más detalles pueden ir aquí si es necesario
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        );
                      }),
                    ],
                  ],
                  const SizedBox(height: 50.0),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

//   _SearchMenuState createState() => _SearchMenuState();
//   @override
//
//   const SearchMenu({super.key});
// class SearchMenu extends StatefulWidget {
//
Future<NotificationResponse> fetchNotificacion(
    String idValue, String idType) async {
  final response = await http.get(Uri.parse(
      'https://api.cnelep.gob.ec/servicios-linea/v1/notificaciones/consultar/$idValue/$idType'));

  if (response.statusCode == 200) {
    print(json.decode(response.body));
    String responseBody = utf8.decode(response.bodyBytes);
    return NotificationResponse.fromJson(json.decode(responseBody));
  } else {
    throw Exception('Failed to load notificacion');
  }
}

//
//
//
// }
//
// class _SearchMenuState extends State<SearchMenu> {
//   final TextEditingController _idController = TextEditingController();
//   IdType? _selectedIdType;
//   NotificationResponse? _notificacion;
//
//   int getCrossAxisCount(BuildContext context) {
//     if (context.isDesktop) {
//       return 3; // 5 columnas para desktop
//     } else if (context.isTablet) {
//       return 2; // 2 columnas para tablet
//     } else {
//       return 1; // 1 columna para mobile
//     }
//   }
//
//   @override
//   void initState() {
//     _selectedIdType = IdType.CUEN;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//               horizontal: context.isDesktop ? context.screenWidth / 4.5 : 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // UI para la entrada de ID y tipo
//               Row(
//                 children: [
//                   const SizedBox(width: 20.0),
//                   SizedBox(
//                     width: 150,
//                     child: Flexible(
//                       flex: 1,
//                       child: TextField(
//                         inputFormatters: [
//                           FilteringTextInputFormatter.allow(RegexUtils.numberR)
//                         ],
//                         controller: _idController,
//                         keyboardType: TextInputType.number,
//                         decoration: const InputDecoration(
//                           hintText: 'identificación',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 25.0),
//                   SizedBox(
//                     width: 200,
//                     child: Flexible(
//                       flex: 2,
//                       child: DropdownButtonFormField<IdType>(
//                         value: _selectedIdType,
//                         items: idTypes.map((Map<String, dynamic> idType) {
//                           return DropdownMenuItem<IdType>(
//                             value: idType['value'],
//                             child: Text(idType['label']),
//                           );
//                         }).toList(),
//                         decoration: const InputDecoration(
//                           hintText: 'Tipo',
//                           border: OutlineInputBorder(),
//                         ),
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedIdType = value;
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 25.0),
//                   Flexible(
//                     flex: 1,
//                     child: Container(
//                       decoration: BoxDecoration(
//                           color: const Color(0xff272e3f),
//                           border: Border.all(),
//                           borderRadius: BorderRadius.circular(5)),
//                       height: 45,
//                       child: InkWell(
//                         onTap: () async {
//                           if (_idController.text.isEmpty ||
//                               _selectedIdType == null) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text(
//                                     'Por favor, ingrese un ID y seleccione un tipo.'),
//                               ),
//                             );
//                             return;
//                           }
//
//                           try {
//                             String idValue = _idController.text;
//                             String idType = _selectedIdType
//                                 .toString()
//                                 .split('.')
//                                 .last; // Convertir a string
//                             NotificationResponse notification =
//                             await fetchNotificacion(idValue, idType);
//                             setState(() {
//                               _notificacion =
//                                   notification; // Almacenar la notificación recibida
//                             });
//                           } catch (e) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text('Error: $e'),
//                               ),
//                             );
//                           }
//                         },
//                         child: context.isDesktop
//                             ? const Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Center(
//                                 child: Text(
//                                   'Buscar',
//                                   style: TextStyle(color: Colors.white),
//                                 )))
//                             : const Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Icon(
//                             Icons.search_sharp,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               if (_notificacion != null) ...[
//                 Text('Respuesta: ${_notificacion!.resp}'),
//                 if (_notificacion!.mensaje != null)
//                   Text('Mensaje: ${_notificacion!.mensaje}'),
//                 if (_notificacion!.mensajeError != null)
//                   Text('Error: ${_notificacion!.mensajeError}'),
//                 if (_notificacion!.notificaciones.isNotEmpty) ...[
//                   const Text('Notificaciones:'),
//                   ..._notificacion!.notificaciones.map((n) {
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('ID Unidad Negocios: ${n.idUnidadNegocios}'),
//                         Text('Cuenta Contrato: ${n.cuentaContrato}'),
//                         Text('Alimentador: ${n.alimentador}'),
//                         Text('Código: ${n.cuen}'),
//                         Text('Dirección: ${n.direccion}'),
//                         Text('Fecha Registro: ${n.fechaRegistro}'),
//                         const Divider(),
//                         const Text('Detalles de Planificación:'),
//                         // Usar GridView para mostrar los detalles
//                         GridView.builder(
//                           physics: const NeverScrollableScrollPhysics(),
//                           shrinkWrap: true,
//                           gridDelegate:
//                           SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: getCrossAxisCount(context),
//                             childAspectRatio: 2.7,
//                             crossAxisSpacing:
//                             5, // Espacio horizontal entre elementos
//                             mainAxisSpacing: 5,
//                           ),
//                           itemCount: _groupDetailsByDate(n.detallePlanificacion)
//                               .length,
//                           itemBuilder: (context, index) {
//                             String fechaCorte =
//                             _groupDetailsByDate(n.detallePlanificacion)
//                                 .keys
//                                 .elementAt(index);
//                             List<PlanningDetail> detalles = _groupDetailsByDate(
//                                 n.detallePlanificacion)[fechaCorte]!;
//
//                             return Container(
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(5),
//                                   border: Border.all(
//                                     color: const Color(0xff272e3f),
//                                   )),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(fechaCorte,
//                                         style: const TextStyle(
//                                             fontWeight: FontWeight.bold)),
//                                     ...detalles.map((detail) {
//                                       return Card(
//                                         elevation: 4,
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Column(
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                             children: [
//                                               Row(
//                                                 children: [
//                                                   Text(
//                                                       'Desde: ${detail.horaDesde}'),
//                                                   const SizedBox(width: 15.0),
//                                                   Text(
//                                                       'Hasta: ${detail.horaHasta}'),
//                                                 ],
//                                               ),
//                                               // Puedes agregar más detalles aquí si es necesario
//                                             ],
//                                           ),
//                                         ),
//                                       );
//                                     }),
//                                     // const Divider(),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     );
//                   }),
//                 ],
//               ],
//               const SizedBox(height: 50.0),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // Método para agrupar detalles por fechaCorte
Map<String, List<PlanningDetail>> _groupDetailsByDate(
    List<PlanningDetail> detalles) {
  Map<String, List<PlanningDetail>> groupedDetails = {};

  for (var detail in detalles) {
    String key = detail.fechaCorte; // Usar fechaCorte como clave
    if (!groupedDetails.containsKey(key)) {
      groupedDetails[key] = []; // Inicializa la lista si no existe
    }
    groupedDetails[key]!.add(detail); // Agrega el detalle a la lista
  }

  return groupedDetails;
}
