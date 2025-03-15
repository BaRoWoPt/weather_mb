import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/view/screens/home_screen.dart';
import 'package:weather_app/view/screens/search_screen.dart';
import 'package:weather_app/view/utility/app_colors.dart';
import 'package:weather_app/view/utility/assets_path.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotateAnimation;
  late AnimationController _cloudController;
  late Animation<double> _cloudAnimation;
  double screenWidth = 0.0;

  bool _animationsInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    _cloudController = AnimationController(
      vsync: this,
      duration:
          const Duration(seconds: 15), // Thời gian để đám mây chạy qua màn hình
    )..repeat();

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linearToEaseOut),
    );

    _cloudAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cloudController, curve: Curves.linear),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_animationsInitialized) {
      screenWidth = MediaQuery.of(context).size.width;
      _animationsInitialized = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _cloudController.dispose();
    super.dispose();
  }

  Future<void> _moveToNextScreen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? firstTime = prefs.getBool('firstTime');
    List<String>? savePlaces = prefs.getStringList('savePlaces');
    if (firstTime == false || savePlaces == null || savePlaces.isEmpty) {
      await prefs.setBool('firstTime', true);
      Get.off(() => const SearchScreen());
    } else {
      Get.off(() => HomeScreen(
            location: savePlaces[0],
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColor, AppColors.shadeColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Phần trên: Mặt trời và mây
            Expanded(
              flex: 1,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Logo mặt trời (SVG) với hiệu ứng xoay
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: RotationTransition(
                      turns: _rotateAnimation,
                      child: SvgPicture.asset(
                        AssetsImagePath.logo,
                        height: 120,
                        width: 120,
                      ),
                    ),
                  ),
                  // Đám mây 1
                  AnimatedBuilder(
                    animation: _cloudAnimation,
                    builder: (context, child) {
                      double offsetX =
                          (_cloudAnimation.value + 0.0) * (screenWidth + 90) -
                              90;
                      if (offsetX > screenWidth) {
                        offsetX -= (screenWidth + 90); // Quay lại bên trái
                      }
                      return Transform.translate(
                        offset: Offset(offsetX, 20.0),
                        child: Opacity(
                          opacity: 0.6,
                          child: Image.asset(
                            AssetsImagePath.cloud1,
                            height: 60,
                            width: 90,
                          ),
                        ),
                      );
                    },
                  ),
                  // Đám mây 2
                  AnimatedBuilder(
                    animation: _cloudAnimation,
                    builder: (context, child) {
                      double offsetX =
                          (_cloudAnimation.value + 0.25) * (screenWidth + 120) -
                              120;
                      if (offsetX > screenWidth) {
                        offsetX -= (screenWidth + 120);
                      }
                      return Transform.translate(
                        offset: Offset(offsetX, 20.0),
                        child: Opacity(
                          opacity: 0.7,
                          child: Image.asset(
                            AssetsImagePath.cloud2,
                            height: 80,
                            width: 120,
                          ),
                        ),
                      );
                    },
                  ),
                  // Đám mây 3
                  AnimatedBuilder(
                    animation: _cloudAnimation,
                    builder: (context, child) {
                      double offsetX =
                          (_cloudAnimation.value + 0.5) * (screenWidth + 100) -
                              100;
                      if (offsetX > screenWidth) {
                        offsetX -= (screenWidth + 100);
                      }
                      return Transform.translate(
                        offset: Offset(offsetX, 20.0),
                        child: Opacity(
                          opacity: 0.8,
                          child: Image.asset(
                            AssetsImagePath.cloud1,
                            height: 70,
                            width: 100,
                          ),
                        ),
                      );
                    },
                  ),
                  // Đám mây 4
                  AnimatedBuilder(
                    animation: _cloudAnimation,
                    builder: (context, child) {
                      double offsetX =
                          (_cloudAnimation.value + 0.75) * (screenWidth + 80) -
                              80;
                      if (offsetX > screenWidth) {
                        offsetX -= (screenWidth + 80);
                      }
                      return Transform.translate(
                        offset: Offset(offsetX, 20.0),
                        child: Opacity(
                          opacity: 0.65,
                          child: Image.asset(
                            AssetsImagePath.cloud2,
                            height: 50,
                            width: 80,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Phần giữa: Chữ "Weather"
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Weather',
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 50,
                      color: AppColors.secondaryColor,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          color: AppColors.shadeColor.withOpacity(0.5),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Phần dưới: Nút "Khám Phá" và chữ "B.S.K"
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Column(
                children: [
                  // Nút "Khám Phá"
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: GestureDetector(
                      onTap: _moveToNextScreen,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.amberColor,
                              AppColors.shadeColor,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadeColor.withOpacity(0.3),
                              offset: const Offset(0, 4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Text(
                          'Khám Phá',
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Chữ "B.S.K"
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'B.S.K',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          color: AppColors.secondaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
