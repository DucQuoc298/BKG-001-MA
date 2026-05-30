import 'package:bkg_001_ma/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {

    void onHomeRoute(){
      context.go(AppRoutes.home);
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AppButton(
            title: 'Home',
            onPressed: onHomeRoute ),
      ),
    );
  }
}