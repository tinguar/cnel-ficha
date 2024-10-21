import 'package:cnel_ficha/model/planification.dart';
import 'package:cnel_ficha/util/responsive.dart';
import 'package:cnel_ficha/widgets/ficha_card.dart';
import 'package:flutter/material.dart';

class FichasList extends StatelessWidget {
  const FichasList({super.key, required this.notification});
  final NotificationF notification;

  @override
  Widget build(BuildContext context) {
    double aspectRatio() {
      // Aspect ratio para el grid - juega con los valores para cada escenario
      if (context.isMobile) return 2.91;
      if (context.isMobileLarge) return 4.91;
      if (context.isTablet) return 3.45;
      return 3.15;
    }

    int getCrossAxisCount(BuildContext context) {
      if (context.isMobileLarge) return 1;
      if (context.isTablet) return 2;
      return 3;
    }

    return GridView.builder(
      physics:
          const NeverScrollableScrollPhysics(), // Evita el scroll dentro del grid
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: getCrossAxisCount(context),
        childAspectRatio: aspectRatio(),
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: _groupDetailsByDate(notification.detallePlanificacion).length,
      itemBuilder: (context, index) {
        String fechaCorte =
            _groupDetailsByDate(notification.detallePlanificacion)
                .keys
                .elementAt(index);
        List<PlanningDetail> detalles =
            _groupDetailsByDate(notification.detallePlanificacion)[fechaCorte]!;
        String input = fechaCorte;
        final RegExp regex = RegExp(r'de 2024');
        String output = input.replaceAll(regex, '');
        return FichaCard(output: output, detalles: detalles);
      },
    );
  }

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
}
