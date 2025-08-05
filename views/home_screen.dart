import 'package:flutter/material.dart';
import 'package:service_app/Chat_Bot/chat_screen.dart';
import 'package:service_app/SHOPING/home_shop.dart';
import 'package:service_app/views/Host_Screens/booking.dart';
import 'package:service_app/model/Screens_home/acccount_screen.dart';
import 'package:service_app/OpenStreet/openstreet.dart';
import 'package:service_app/Tinder%20Matching/PlanTripScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selelectedIndex = 0;
  bool _showUnreadBadge = true;

  final List<String> screenTitles = [
    'Home',
    'Saved',
    'Chat',
    'Profile',
    'Path',
  ];

  final List<Widget> screens = [
    Booking(),           // Home Screen
    SellerOnboardingScreen(),    // Saved / Trip Planner Screen
    PlanTripScreen(),        // Chat Screen
    AccountScreen(),     // Profile Screen
    Openstreet(),        // Find Path Screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFC9DEC8), Color(0xFF5C815E)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: Text(
          screenTitles[selelectedIndex],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
      ),
      body: IndexedStack(
        index: selelectedIndex,
        children: screens,
      ),
      floatingActionButton: selelectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                setState(() => _showUnreadBadge = false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatScreen(),
                    fullscreenDialog: true,
                  ),
                );
              },
              backgroundColor: Colors.blue[600],
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.chat_bubble, color: Colors.white, size: 30),
                  if (_showUnreadBadge)
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            )
          : null,

      /// --- CUSTOM PILL-SHAPED BOTTOM BAR ---
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 16, // height of the bar
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30), // pill shape
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, "Home", 0),
              _buildNavItem(Icons.save_rounded, "Saved", 1),
              Stack(
                children: [
                  _buildNavItem(Icons.message, "Chat", 2),
                  if (_showUnreadBadge)
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              _buildNavItem(Icons.person, "Profile", 3),
              _buildNavItem(Icons.map, "Path", 4),
            ],
          ),
        ),
      ),
    );
  }

  /// Build each navigation item (icon + text when selected)
  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = selelectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selelectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple.shade100 : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 15, // icon size
              color: isSelected ? Colors.purple : Colors.black,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
