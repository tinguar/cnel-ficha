import 'package:cnel_ficha/fichas_list.dart';
import 'package:cnel_ficha/model/planification.dart';
import 'package:cnel_ficha/util/util.dart';
import 'package:cnel_ficha/widgets/custom_search_bar.dart';
import 'package:cnel_ficha/widgets/responsive_center.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
import 'dart:io';
import 'package:google_fonts/google_fonts.dart' as google_fonts;

import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
    // Método para lanzar la URL
    Future<void> _launchURL(String url) async {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri)) {
        throw 'No se pudo abrir $url';
      }
    }

    Future<void> _generatePdf(BuildContext context) async {
      final pdf = pw.Document();

      final fontData =
          await rootBundle.load('assets/fonts/roboto/Roboto-Regular.ttf');
      final robotoFont = pw.Font.ttf(fontData.buffer.asByteData());

      // Verifica que haya datos en _notificacionResponse
      if (_notificacionResponse == null) return;

      // Iterar sobre cada notificación y crear una nueva página
      for (var notification in _notificacionResponse!.notificaciones) {
        // Agrupar detalles por fecha
        final groupedDetails =
            groupDetailsByDate(notification.detallePlanificacion);

        // Agregar una nueva página para cada notificación
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Contrato: ${notification.cuentaContrato}',
                    style: pw.TextStyle(
                      font: robotoFont,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  pw.Text(
                    'Alimentador: ${notification.alimentador}',
                    style: pw.TextStyle(font: robotoFont),
                  ),
                  pw.Text(
                    'Código: ${notification.cuen}',
                    style: pw.TextStyle(font: robotoFont),
                  ),
                  pw.Text(
                    'Dirección: ${notification.direccion}',
                    style: pw.TextStyle(font: robotoFont),
                  ),
                  pw.Divider(),
                  pw.Text(
                    'Detalles de Planificación:',
                    style: pw.TextStyle(
                      font: robotoFont,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),

                  // Add grid-like details here
                  pw.Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: groupedDetails.entries.map((entry) {
                      String fechaCorte = entry.key;
                      List<PlanningDetail> detalle = entry.value;

                      String output =
                          fechaCorte.replaceAll(RegExp(r'de 2024'), '');

                      return pw.Container(
                        padding: const pw.EdgeInsets.all(8),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.grey),
                          borderRadius: pw.BorderRadius.circular(5),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              output,
                              style: pw.TextStyle(
                                font: robotoFont,
                                color: ColorPdf.colorBlack,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            ...detalle
                                .map(
                                  (detalle) => pw.Container(
                                    decoration: pw.BoxDecoration(
                                      border:
                                          pw.Border.all(color: PdfColors.grey),
                                      borderRadius: pw.BorderRadius.circular(5),
                                    ),
                                    padding: const pw.EdgeInsets.all(2),
                                    margin: const pw.EdgeInsets.all(2),
                                    child: pw.Text(
                                      '${detalle.horaDesde} - ${detalle.horaHasta}',
                                      style: pw.TextStyle(
                                        font: robotoFont,
                                        fontSize: 15.0,
                                        fontWeight: pw.FontWeight.bold,
                                        color: ColorPdf.colorBlack,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  pw.SizedBox(height: 20), // Espacio entre notificaciones
                ],
              );
            },
          ),
        );
      }

      // Guardar el PDF como bytes
      final Uint8List pdfData = await pdf.save();

      // Manejar la descarga del PDF para diferentes plataformas
      if (kIsWeb) {
        // Lógica para la web
        final blob = html.Blob([pdfData]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', 'document.pdf')
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        // Lógica para Android
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/captura.pdf');
        await file.writeAsBytes(pdfData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF guardado en ${file.path}')),
        );
      }
    }

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
                            onPressed: () => _launchURL('https://tinguar.com/'),
                            icon: const FaIcon(FontAwesomeIcons.microchip)),
                        IconButton(
                            onPressed: () => _launchURL(
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
                  // Puedes usar SliverToBoxAdapter para widgets individuales como el search bar
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
                  // Sliver para el contenido de las notificaciones
                  if (_notificacionResponse != null)
                    SliverToBoxAdapter(
                      child: ResponsiveCenter(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () => _generatePdf(context),
                              child: Container(
                                decoration: DecorationStyle.greyBorder(
                                    color: ColorStyle.backgroundBlack),
                                height: 45,
                                child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                        child: Text(
                                          'Descargar PDF del horario                          ',
                                          style: TextStyle(color: Colors.white),
                                        ))),
                              ),
                            ),const SizedBox(height: 20),
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
                                            FichasList(notification: notification),
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
      ),
    );
  }
}
