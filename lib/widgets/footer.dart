import 'package:cnel_ficha/util/router.dart';
import 'package:cnel_ficha/widgets/responsive_center.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../util/util.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveCenter(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              RichText(
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
                      style: TextStyleS.textLink(),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launchURL(
                              'https://serviciosenlinea.cnelep.gob.ec/cortes-energia/');
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 7.0),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Terminos y condiciones',
                      style: TextStyleS.textLink(),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          goRouter.go('/terminos-y-condiciones');
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
