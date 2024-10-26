import 'package:cnel_ficha/model/planification.dart';
import 'package:flutter/material.dart';

import '../util/util.dart';

class FichaCard extends StatelessWidget {
  const FichaCard({
    super.key,
    required this.output,
    required this.detalles,
    this.widthCard,
  });

  final String output;
  final List<PlanningDetail> detalles;
  final double? widthCard;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: DecorationStyle.greyBorder(),
      padding: const EdgeInsets.all(15),
      width: widthCard,
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
          LayoutBuilder(builder: (context, constraints) {
            return Wrap(
              spacing: 5,
              runSpacing: 5,
              children: [
                ...List.generate(detalles.length, (index) {
                  final detail = detalles[index];
                  final width = (index == detalles.length - 1 && index.isEven)
                      ? constraints.maxWidth
                      : constraints.maxWidth * 0.5;
                  return Container(
                    width: width - 5,
                    decoration: DecorationStyle.greyBorder(),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      '${detail.horaDesde} - ${detail.horaHasta}',
                      style: TextStyleS.textGlobal(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
              ],
            );
          }),
        ],
      ),
    );
  }
}
