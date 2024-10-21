import 'package:cnel_ficha/model/planification.dart';
import 'package:flutter/material.dart';

class FichaCard extends StatelessWidget {
  const FichaCard({super.key, required this.output, required this.detalles});
  final String output;
  final List<PlanningDetail> detalles;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: const Color(0xff272e3f),
        ),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(output, style: const TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              ...List.generate(detalles.length, (index) {
                final detail = detalles[index];
                return Expanded(
                  child: Container(
                    margin: index == detalles.length - 1
                        ? const EdgeInsets.only(right: 0)
                        : const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    child: Text('${detail.horaDesde} - ${detail.horaHasta}'),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
