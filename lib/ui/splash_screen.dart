import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurantcity3/ui/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/splash_screen";
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    openHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: Container(
                  padding: const EdgeInsets.all(0.0),
                  width: 300,
                  height: 400,
                  child: Column(
                    children: [
                      Lottie.asset("images/animation_restaurant.json"),
                      const Text(
                        'Restaurant City',
                        style: TextStyle(fontFamily: 'Pattaya', fontSize: 24, color: Colors.red),
                      )
                    ],
                  ),
                )
            )
        )
    );
  }

  openHome() {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
              (route) => false);
    });
  }
}
