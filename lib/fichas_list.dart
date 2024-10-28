import 'package:cnel_ficha/model/planification.dart';
import 'package:cnel_ficha/util/responsive.dart';
import 'package:cnel_ficha/widgets/ficha_card.dart';
import 'package:flutter/material.dart';

class FichasList extends StatelessWidget {
  const FichasList({super.key, required this.notification});
  final NotificationF notification;

  @override
  Widget build(BuildContext context) {
    const padding = 10.0;
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth <= BreakPoint.mobile.value
          ? constraints.maxWidth // 1 card en mobile
          : (constraints.maxWidth <= BreakPoint.mobileLarge.value
              ? (constraints.maxWidth / 2) - (padding / 2) // 2 cards en tablet
              : (constraints.maxWidth / 3) -
                  (padding / 1.5)); // 3 cards en desktop
      return Wrap(
        spacing: padding,
        runSpacing: padding,
        children: [
          ...List.generate(
              groupDetailsByDate(notification.detallePlanificacion).length,
              (index) {
            String fechaCorte =
                groupDetailsByDate(notification.detallePlanificacion)
                    .keys
                    .elementAt(index);
            List<PlanningDetail> detalles = groupDetailsByDate(
                notification.detallePlanificacion)[fechaCorte]!;
            String input = fechaCorte;
            final RegExp regex = RegExp(r'de 2024');
            String output = input.replaceAll(regex, '');
            return FichaCard(
              output: output,
              detalles: detalles,
              widthCard: width,
            );
          }),
        ],
      );
    });
  }
}

Map<String, List<PlanningDetail>> groupDetailsByDate(
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
