import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/views/login.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> pages = [
    {
      'image': 'assets/titu2.png',
      'title': 'Adventure Planner',
      'description': 'Organizes local treks, nature walks & farming experiences.',
      'color': Colors.blue,
    },
    {
      'image': 'assets/open.png',
      'title': 'Location Services',
      'description': 'Vilage Stay utilizes location services for timely service.',
      'color': Colors.green,
    },
    {
      'image': 'assets/pay.png',
      'title': 'Easy Payments',
      'description': 'Secure and hassle-free transactions',
      'color': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (_, index) => _buildPage(pages[index]),
          ),
          _buildIndicator(),
          _buildNavigationButton(),
        ],
      ),
    );
  }

  Widget _buildPage(Map<String, dynamic> page) {
    return Container(
      color: page['color'],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(page['image'], height:MediaQuery.of(context).size.height*0.5,),
          const SizedBox(height: 40),
          Text(
            page['title'],
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              page['description'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator() {
    return Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: pages.map((page) {
          int index = pages.indexOf(page);
          return Container(
            width: _currentPage == index ? 24 : 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: _currentPage == index ? Colors.white : Colors.white54,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNavigationButton() {
    return Positioned(
      bottom: 40,
      left: 20,
      right: 20,
      child: ElevatedButton(
        onPressed: () {
          if (_currentPage < pages.length - 1) {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          } else {
            Get.offAll(() => const Login());
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          _currentPage == pages.length - 1 ? 'Get Started' : 'Next',
          style: TextStyle(
            fontSize: 18,
            color: pages[_currentPage]['color'],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}