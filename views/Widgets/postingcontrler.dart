// controllers/posting_controller.dart
import 'package:get/get.dart';
import 'package:service_app/model/app_constant.dart';
import 'package:service_app/model/posting_model.dart';

class PostingController extends GetxController {
  var myPostings = <PostingModel>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadPostings();
  }

  void loadPostings() {
    myPostings.value = AppConstants.currentUser.myPostings ?? [];
  }

  void addPosting(PostingModel newPosting) {
    AppConstants.currentUser.myPostings ??= [];
    AppConstants.currentUser.myPostings!.add(newPosting);
    myPostings.value = AppConstants.currentUser.myPostings!;
    update();
  }

  void updatePosting(int index, PostingModel updatedPosting) {
    AppConstants.currentUser.myPostings![index] = updatedPosting;
    myPostings.value = AppConstants.currentUser.myPostings!;
    update();
  }
}