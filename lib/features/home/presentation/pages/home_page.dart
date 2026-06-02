import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bkg_001_ma/shared/widgets/widgets.dart';
import '../../../../core/router/app_routes.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    void onLoginSuccess() {
      // context.go(AppRoutes.login);
    }
    return Scaffold(
      body: Center(
        child: AppButton(
          text: 'Login',
          onPressed: onLoginSuccess,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            backgroundColor: Colors.blue,
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // <--- Bỏ color ở đây
          ),
        ),
      ),
    );
  }
}

