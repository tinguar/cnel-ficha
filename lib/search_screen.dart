import 'package:cnel_ficha/fichas_list.dart';
import 'package:cnel_ficha/model/planification.dart';
import 'package:cnel_ficha/util/util.dart';
import 'package:cnel_ficha/widgets/custom_search_bar.dart';
import 'package:cnel_ficha/widgets/pdf.dart';
import 'package:cnel_ficha/widgets/responsive_center.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// for testing purposes
// 2000005742

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  NotificationResponse? _notificacionResponse;
  GlobalKey _globalKey = GlobalKey(); // Clave para el RepaintBoundary

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.background,
      body: RepaintBoundary(
        key: _globalKey,
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    centerTitle: true,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () => launchURL('https://tinguar.com/'),
                            icon: const FaIcon(FontAwesomeIcons.microchip)),
                        IconButton(
                            onPressed: () => launchURL(
                                'https://github.com/tinguar/cnel-ficha'),
                            icon: const FaIcon(FontAwesomeIcons.github)),
                      ],
                    ),
                    floating: false,
                    pinned: true,
                    expandedHeight: 50.0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        color: ColorStyle.background,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: ResponsiveCenter(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          CustomSearchBar(
                            handleSearch: (notificacionResponse) {
                              setState(() {
                                _notificacionResponse = notificacionResponse;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 10.0),
                  ),
                  if (_notificacionResponse != null)
                    SliverToBoxAdapter(
                      child: ResponsiveCenter(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                generatePdf(context, _notificacionResponse);
                              },
                              child: Container(
                                decoration: DecorationStyle.greyBorder(
                                    color: ColorStyle.backgroundBlack),
                                height: 45,
                                child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                        child: Text(
                                      'Descargar horario en pdf'.toUpperCase(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ))),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              decoration: DecorationStyle.greyBorder(),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                            FichasList(
                                                notification: notification),
                                          ],
                                        );
                                      }),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 25.0),
                  ),
                ],
              ),
            ),
            ResponsiveCenter(
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
                              launchURL(
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
      ),
    );
  }
}
