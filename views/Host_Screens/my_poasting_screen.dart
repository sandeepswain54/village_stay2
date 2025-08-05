import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:service_app/model/app_constant.dart';
import 'package:service_app/views/Widgets/create_posting_screen.dart';
import 'package:service_app/views/Widgets/posting_List_tile_button.dart';
import 'package:service_app/views/Widgets/posting_listing_tile_ui.dart';

class MyPoastingScreen extends StatefulWidget {
  const MyPoastingScreen({super.key});

  @override
  State<MyPoastingScreen> createState() => _MyPoastingScreenState();
}

class _MyPoastingScreenState extends State<MyPoastingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main scrollable content
          Padding(
            padding: const EdgeInsets.only(top: 25, bottom: 80), // Space for bottom button
            child: ListView.builder(
              itemCount: AppConstants.currentUser.myPostings!.length + 1,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(26, 0, 26, 16),
                  child: InkResponse(
                    onTap: () {
                      Get.to(
                        CreatePostingScreen(
                          posting: (index == AppConstants.currentUser.myPostings!.length)
                              ? null
                              : AppConstants.currentUser.myPostings![index],
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: (index == AppConstants.currentUser.myPostings!.length)
                          ? const PostingTileButton()
                          : PostingListingTileUi(posting: AppConstants.currentUser.myPostings![index]),
                    ),
                  ),
                );
              },
            ),
          ),

          // Fixed bottom button
          Positioned(
            left: 26,
            right: 26,
            bottom: 16,
            child: InkResponse(
              onTap: () {
                Get.to(const CreatePostingScreen(posting: null));
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  '+ Create a Listing',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}