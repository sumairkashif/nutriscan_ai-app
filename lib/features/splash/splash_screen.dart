import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../main_layout.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainLayout()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Ensure background matches theme
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Icon or Logo
            const Icon(
              Icons.eco_rounded,
              size: 100,
              color: AppColors.primary,
            )
            .animate()
            .fade(duration: 600.ms)
            .scale(delay: 200.ms, duration: 600.ms, curve: Curves.easeOutBack),
            
            const SizedBox(height: 20),
            
            Text(
              "NutriScan AI",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            )
            .animate()
            .fade(delay: 400.ms, duration: 600.ms)
            .slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }
}
