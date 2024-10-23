import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screen/screen.dart';
import '../search_screen.dart';

CustomTransitionPage buildCustomTransitionPage(LocalKey pageKey, Widget child) {
  return CustomTransitionPage(
    key: pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeIn).animate(animation),
        child: child,
      );
    },
  );
}

final goRouter = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => const SearchScreen(),
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        return buildCustomTransitionPage(state.pageKey, const SearchScreen());
      },
    ),
    GoRoute(
      path: '/terminos-y-condiciones',
      pageBuilder: (context, state) {
        return buildCustomTransitionPage(state.pageKey, const TermsAndConditionsScreen());
      },
    )
  ],
);
