import 'dart:io';
import 'package:cnel_ficha/fichas_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart' as google_fonts;
import 'package:path_provider/path_provider.dart';

import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../model/model.dart';
import '../util/util.dart';


Future<void> generatePdf(BuildContext context, NotificationResponse? _notificacionResponse) async {

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
          return pw.Stack(
            children: [
              pw.Column(
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
                                  border: pw.Border.all(
                                      color: PdfColors.grey),
                                  borderRadius:
                                  pw.BorderRadius.circular(5),
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
              ),
              pw.Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: pw.Container(
                  alignment: pw.Alignment.centerRight,
                  padding: const pw.EdgeInsets.only(right: 20.0, top: 10.0),
                  child: pw.Text(
                    'Este es un sitio independiente, realizado por TINGUAR.COM',
                    style: pw.TextStyle(
                      font: robotoFont,
                      fontSize: 12,
                      color: PdfColors.grey,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // pw.Positioned(
  //   top: 200,
  //   left: 100,
  //   child: pw.Transform.rotate(
  //     angle: -0.5,
  //     child: pw.Opacity(
  //       opacity: 0.2,
  //       child: pw.Text(
  //         'tinguar.com'.toUpperCase(),
  //         style: pw.TextStyle(
  //           font: robotoFont,
  //           fontSize: 60,
  //           color: PdfColors.grey,
  //         ),
  //       ),
  //     ),
  //   ),
  // ),

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