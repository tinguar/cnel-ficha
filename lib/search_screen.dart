import 'package:cnel_ficha/fichas_list.dart';
import 'package:cnel_ficha/model/planification.dart';
import 'package:cnel_ficha/util/util.dart';
import 'package:cnel_ficha/widgets/custom_search_bar.dart';
import 'package:cnel_ficha/widgets/footer.dart';
import 'package:cnel_ficha/widgets/pdf.dart';
import 'package:cnel_ficha/widgets/responsive_center.dart';
import 'package:flutter/material.dart';
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
  final GlobalKey _globalKey = GlobalKey(); // Clave para el RepaintBoundary

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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Horarios ec'.toUpperCase(),
                                  style: TextStyleS.textGlobal(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0),
                                ),
                                TextSpan(
                                  text: ' cnel'.toUpperCase(),
                                  style: TextStyleS.textLink(
                                      decoration: TextDecoration.none,
                                      fontSize: 25.0),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            'Aquí puedes acceder a los horarios de cortes de luz programados por CNEL en tu zona.',
                            style: TextStyleS.textGlobal(),
                          ),
                          const SizedBox(height: 10.0),
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
                                    padding: const EdgeInsets.all(8.0),
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
            const FooterWidget()
          ],
        ),
      ),
    );
  }
}
