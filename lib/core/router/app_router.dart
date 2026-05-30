import 'package:flutter/material.dart';
import 'app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:bkg_001_ma/features/auth/presentation/pages/pages.dart';
import 'package:bkg_001_ma/features/home/presentation/pages/pages.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
  ],
);