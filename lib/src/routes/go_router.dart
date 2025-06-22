import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:noots_app/src/routes/error_route.dart';
import 'package:noots_app/src/routes/routs_transition.dart';

class MyAppRouter {
  static final router = GoRouter(
    initialLocation: '/${AppRoute.errorPage}',
    routes: [
      GoRoute(
        name: AppRoute.errorPage,
        path: '/${AppRoute.errorPage}',
        pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
          context: context,
          state: state,
          child: const ErrorPage(),
        ),
      ),
      // GoRoute(
      //   name: AppRoute.dashboard,
      //   path: '/${AppRoute.dashboard}',
      //   pageBuilder: (context, state) => buildPageWithFadeTransition<void>(
      //     context: context,
      //     state: state,
      //     child: const DashboardPage(),
      //   ),
      // ),
    ],
    errorPageBuilder: (context, state) {
      return const MaterialPage(child: ErrorPage());
    },
  );

  static void clearAndNavigate(BuildContext context, String name) {
    while (context.canPop()) {
      context.pop();
    }
    context.pushReplacementNamed(name);
  }
}

class AppRoute {
  static const String errorPage = 'error-page';
}
