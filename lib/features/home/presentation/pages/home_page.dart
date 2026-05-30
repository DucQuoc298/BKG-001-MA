import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bkg_001_ma/shared/widgets/widgets.dart';
import '../../../../core/router/app_routes.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    void onLoginSuccess() {
      context.go(AppRoutes.login);
    }
    return Scaffold(
      body: Center(
        child: AppButton(
          title: 'Login',
          isLoading: false,
          onPressed: onLoginSuccess,
        ),
      ),
    );
  }
}

