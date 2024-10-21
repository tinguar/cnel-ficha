import 'package:cnel_ficha/model/planification.dart';
import 'package:cnel_ficha/search_screen.dart';
import 'package:flutter/material.dart';

class FichaCard extends StatelessWidget {
  const FichaCard({super.key, required this.output, required this.detalles});
  final String output;
  final List<PlanningDetail> detalles;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: DecorationStyle.greyBorder,
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            output,
            style: TextStyleS.textGlobal(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              ...List.generate(detalles.length, (index) {
                final detail = detalles[index];
                return Expanded(
                  child: Container(
                    margin: index == detalles.length - 1
                        ? const EdgeInsets.only(right: 0)
                        : const EdgeInsets.only(right: 5),
                    decoration: DecorationStyle.greyBorder,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    child: Text('${detail.horaDesde} - ${detail.horaHasta}',  style: TextStyleS.textGlobal(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),),
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
