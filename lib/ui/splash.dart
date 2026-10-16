import 'package:flutter/material.dart';

import 'style/colors.dart';
import 'home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 80, color: AppColors.principal),
            SizedBox(height: 18),
            Text(
              'Minhas Receitas',
              style: TextStyle(
                color: AppColors.texto,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Descubra novos sabores!',
              style: TextStyle(color: AppColors.principal, fontSize: 16),
            ),
            SizedBox(height: 25),
            CircularProgressIndicator(color: AppColors.secundaria),
          ],
        ),
      ),
    );
  }
}
