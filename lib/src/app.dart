import 'package:flutter/material.dart';

import 'router.dart';
import 'theme.dart';

class IFAAApp extends StatelessWidget {
  const IFAAApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = buildRouter();
    return MaterialApp.router(
      title: 'IFAA',
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}