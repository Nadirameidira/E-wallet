import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'screens/welcome.dart';
import 'screens/dashboard_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Wallet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFEEECE2),
      ),
      home: const _SplashRouter(),
    );
  }
}

class _SplashRouter extends StatelessWidget {
  const _SplashRouter();

  Future<Widget> _resolve() async {
    final loggedIn = await AuthService.isLoggedIn();
    if (loggedIn) {
      final user = await AuthService.getCurrentUser();
      return DashboardScreen(userName: user?.namaLengkap ?? 'User');
    }
    return const WelcomePage();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _resolve(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snap.data!;
      },
    );
  }
}