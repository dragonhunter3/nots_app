import 'package:flutter/material.dart';
import 'package:noots_app/src/routes/go_router.dart';
import 'package:noots_app/src/theme/theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerDelegate: MyAppRouter.router.routerDelegate,
        routeInformationParser: MyAppRouter.router.routeInformationParser,
        routeInformationProvider: MyAppRouter.router.routeInformationProvider,
        theme: AppTheme.instance.lightTheme(context),
      ),
    );
  }
}
