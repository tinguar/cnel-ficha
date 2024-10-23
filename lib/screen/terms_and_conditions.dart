import 'package:cnel_ficha/search_screen.dart';
import 'package:cnel_ficha/widgets/responsive_center.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';

import '../util/class.dart';
import '../widgets/footer.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  Future<String> loadMarkdown() async {
    return await rootBundle.loadString('assets/md/terms_and_conditions.md');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorStyle.background,
        appBar: AppBar(
          backgroundColor: ColorStyle.background,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back,),
                onPressed: () {
                  context.go('/');
                },
              ),
              const SizedBox(width: 20.0),
               Text('Términos y Condiciones'.toUpperCase()),
            ],
          ),
          centerTitle: true,

        ),
        body: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: FutureBuilder<String>(
                      future: loadMarkdown(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          return ResponsiveCenter(
                              child: Markdown(
                                physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true, data: snapshot.data ?? ''));
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            const FooterWidget()
          ],
        ));
  }
}
