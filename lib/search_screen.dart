import 'package:cnel_ficha/fichas_list.dart';
import 'package:cnel_ficha/model/planification.dart';
import 'package:cnel_ficha/widgets/custom_search_bar.dart';
import 'package:cnel_ficha/widgets/responsive_center.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ColorStyle {
  static Color backgroundBlack = const Color(0xff272e3f);
  static Color background = const Color(0xfff3efff);
  static Color colorGrey = const Color(0xff7f8c9f);
  static Color backgroundOrange = const Color(0xfff37474);
}

class DecorationStyle {
  static BoxDecoration greyBorder = BoxDecoration(
    border: Border.all(color: ColorStyle.colorGrey),
    borderRadius: BorderRadius.circular(5),
  );
}

class TextStyleS {
  static TextStyle textGlobal({
    fontSize,
    color,
    fontWeight,
    decoration,
    decorationThickness,
    decorationColor,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 17,
      color: color ?? ColorStyle.backgroundBlack,
      fontWeight: fontWeight ?? FontWeight.w200,
      decoration: decoration ?? TextDecoration.none,
      decorationThickness: decorationThickness ?? 0.0,
      decorationColor: decorationColor ?? Colors.transparent,
    );
  }
}

// for testing purposes
// 2000005742

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  NotificationResponse? _notificacionResponse;

  @override
  Widget build(BuildContext context) {
    // Método para lanzar la URL
    Future<void> _launchURL(String url) async {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri)) {
        throw 'No se pudo abrir $url';
      }
    }

    return Scaffold(
      backgroundColor: ColorStyle.background,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Puedes usar SliverToBoxAdapter para widgets individuales como el search bar
                SliverToBoxAdapter(
                  child: ResponsiveCenter(
                    padding: const EdgeInsets.all(20),
                    child: CustomSearchBar(
                      handleSearch: (notificacionResponse) {
                        setState(() {
                          _notificacionResponse = notificacionResponse;
                        });
                      },
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 10.0),
                ),
                // Sliver para el contenido de las notificaciones
                if (_notificacionResponse != null)
                  SliverToBoxAdapter(
                    child: ResponsiveCenter(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        decoration: DecorationStyle.greyBorder,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_notificacionResponse!
                                  .notificaciones.isNotEmpty) ...[
                                ..._notificacionResponse!.notificaciones
                                    .map((notification) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Contrato: ${notification.cuentaContrato}',
                                        style: TextStyleS.textGlobal(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                      ),
                                      Text(
                                        'Alimentador: ${notification.alimentador}',
                                        style: TextStyleS.textGlobal(),
                                      ),
                                      Text(
                                        'Código: ${notification.cuen}',
                                        style: TextStyleS.textGlobal(),
                                      ),
                                      Text(
                                        'Dirección: ${notification.direccion}',
                                        style: TextStyleS.textGlobal(),
                                      ),
                                      const Divider(),
                                      Text(
                                        'Detalles de Planificación:',
                                        style: TextStyleS.textGlobal(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                      ),
                                      FichasList(notification: notification),
                                    ],
                                  );
                                }),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 25.0),
                ),
              ],
            ),
          ),    ResponsiveCenter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                        'Este es un sitio independiente. Información obtenida del portal oficial ',
                        style: TextStyleS.textGlobal(),
                      ),
                      TextSpan(
                        text: 'CNEL'.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _launchURL(
                                'https://serviciosenlinea.cnelep.gob.ec/cortes-energia/');
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});
//
//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   NotificationResponse? _notificacionResponse;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//
//       // sugiero mejorar esto reemplazando el SingleChildScrollView
//       //por un CustomScrollView usando Slivers
//       body: SingleChildScrollView(
//         child: ResponsiveCenter(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomSearchBar(
//                 handleSearch: (notificacionResponse) {
//                   setState(() {
//                     _notificacionResponse = notificacionResponse;
//                   });
//                 },
//               ),
//               const SizedBox(height: 25.0),
//               Container(
//                 decoration: _notificacionResponse != null
//                     ? DecorationStyle.greyBorder
//                     : null,
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Text(
//                       //   'Detalles de Planificación:',
//                       //   style: TextStyleS.textGlobal(),
//                       // ),
//                       // Container(
//                       //   decoration: DecorationStyle.greyBorder,
//                       //   padding: const EdgeInsets.symmetric(
//                       //       horizontal: 15, vertical: 10),
//                       //   child: Column(
//                       //     mainAxisSize: MainAxisSize.min,
//                       //     crossAxisAlignment: CrossAxisAlignment.start,
//                       //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       //     children: [
//                       // Text(
//                       //   'Lunes',
//                       //   style: TextStyleS.textGlobal(
//                       //     fontSize: 15.0,
//                       //     fontWeight: FontWeight.bold,
//                       //   ),
//                       // ),
//                       // SizedBox(
//                       //   height: 10,
//                       // ),
//                       // Row(
//                       //   children: [
//                       //     Expanded(
//                       //       child: Container(
//                       //         margin: const EdgeInsets.only(right: 5),
//                       //         decoration: DecorationStyle.greyBorder,
//                       //         alignment: Alignment.center,
//                       //         padding: const EdgeInsets.all(8),
//                       //         child: Text('cscscs - sdsdsd',
//                       //           style: TextStyleS.textGlobal(
//                       //             fontSize: 15.0,
//                       //             fontWeight: FontWeight.bold,
//                       //           ),),
//                       //       ),
//                       //     )
//                       //   ],
//                       // ),
//                       //     ],
//                       //   ),
//                       // ),
//                       const SizedBox(height: 16),
//                       if (_notificacionResponse != null) ...[
//                         // Text('Respuesta: ${_notificacionResponse!.resp}'),
//                         // if (_notificacionResponse!.mensaje != null)
//                         //   Text('Mensaje: ${_notificacionResponse!.mensaje}'),
//                         // if (_notificacionResponse!.mensajeError != null)
//                         //   Text('Error: ${_notificacionResponse!.mensajeError}'),
//                         if (_notificacionResponse!
//                             .notificaciones.isNotEmpty) ...[
//                           // const Text('Notificaciones:'),
//                           ..._notificacionResponse!.notificaciones
//                               .map((notification) {
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 // Text(
//                                 //     'ID Unidad Negocios: ${notification.idUnidadNegocios}'),
//                                 Text(
//                                   'Contrato: ${notification.cuentaContrato}',
//                                   style: TextStyleS.textGlobal(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 20.0),
//                                 ),
//                                 // Text('Cuenta Contrato: ${notification.cuentaContrato}'),
//                                 Text(
//                                   'Alimentador: ${notification.alimentador}',
//                                   style: TextStyleS.textGlobal(),
//                                 ),
//                                 Text(
//                                   'Código: ${notification.cuen}',
//                                   style: TextStyleS.textGlobal(),
//                                 ),
//                                 Text(
//                                   'Dirección: ${notification.direccion}',
//                                   style: TextStyleS.textGlobal(),
//                                 ),
//                                 // Text('Dirección: ${notification.direccion}'),
//                                 // // Text('Fecha Registro: ${notification.fechaRegistro}'),
//                                 const Divider(),
//                                 Text(
//                                   'Detalles de Planificación:',
//                                   style: TextStyleS.textGlobal(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 20.0),
//                                 ),
//                                 FichasList(notification: notification),
//                               ],
//                             );
//                           }),
//                         ],
//                       ],
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 25.0),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
