import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:service_app/model/app_constant.dart';
import 'package:service_app/model/global.dart';
import 'package:service_app/model/posting_model.dart';

class PostingViewModel {
  /// Uploads listing info to Firestore
 Future<bool>
  addListingInfoToFirestore() async {
  try {
    postingModel.setImagesNames();

    if (AppConstants.currentUser.id == null || AppConstants.currentUser.id!.isEmpty) {
      print("Current user ID is null or empty");
      return false;
    }

    final docRef = FirebaseFirestore.instance.collection("postings").doc();
    postingModel.id = docRef.id;

    Map<String, dynamic> dataMap = {
      "id": postingModel.id,
      "address": postingModel.address ?? '',
      "bathrooms": postingModel.bathroom ?? <String, int>{},
      "description": postingModel.description ?? '',
      "beds": postingModel.beds ?? <String, int>{},
      "city": postingModel.city ?? '',
      "country": postingModel.country ?? '',
      "hostID": AppConstants.currentUser.id ?? '',
      "imageNames": postingModel.imageNames ?? [],
      "name": postingModel.name ?? '',
      "price": postingModel.price ?? 0,
      "rating": 3.5,
      "type": postingModel.type ?? '',
      "createdAt": FieldValue.serverTimestamp(),
    };

    print("Uploading posting with id: ${postingModel.id}");
    print("Data map: $dataMap");

    await docRef.set(dataMap);

    try {
      await AppConstants.currentUser.addPostingToMyPostings(postingModel);
    } catch (e) {
      print("Error adding posting to user's postings: $e");
      // Optionally: return false;
    }

    return true;
  } catch (e) {
    print("Firestore Upload Error: $e");
    return false;
  }
}


 updatePostingInfoToFirestore() async {
  try {
    if (postingModel.id == null || postingModel.id!.isEmpty) {
      print("Posting ID is null or empty");
      return false;
    }

    if (AppConstants.currentUser.id == null || AppConstants.currentUser.id!.isEmpty) {
      print("Current user ID is null or empty");
      return false;
    }

    postingModel.setImagesNames();

    Map<String, dynamic> dataMap = {
      "id": postingModel.id,
      "address": postingModel.address ?? '',
      "bathrooms": postingModel.bathroom ?? <String, int>{},
      "description": postingModel.description ?? '',
      "beds": postingModel.beds ?? <String, int>{},
      "city": postingModel.city ?? '',
      "country": postingModel.country ?? '',
      "hostID": AppConstants.currentUser.id ?? '',
      "imageNames": postingModel.imageNames ?? [],
      "name": postingModel.name ?? '',
      "price": postingModel.price ?? 0,
      "rating": postingModel.rating ?? 3.5,
      "type": postingModel.type ?? '',
      "createdAt": FieldValue.serverTimestamp(),
    };

    print("Updating posting with id: ${postingModel.id}");
    print("Data map: $dataMap");

    // Update the existing document instead of creating a new one
    await FirebaseFirestore.instance
        .collection("postings")
        .doc(postingModel.id)
        .update(dataMap);

    // Update the user's postings list
    try {
      await AppConstants.currentUser.addPostingToMyPostings(postingModel);
    } catch (e) {
      print("Error updating posting in user's postings: $e");
      return false;
    }

    return true;
  } catch (e) {
    print("Firestore Update Error: $e");
    return false;
  }
}



  /// Uploads images to Firebase Storage in background
  Future<void> addImagesToFirebaseStorage() async {
    try {
      for (int i = 0; i < postingModel.displayImages!.length; i++) {
        Reference ref = FirebaseStorage.instance
            .ref()
            .child("postingImages")
            .child(postingModel.id!)
            .child(postingModel.imageNames![i]);

        await ref.putData(postingModel.displayImages![i].bytes);
      }
      print("All images uploaded successfully.");
    } catch (e) {
      print("Image Upload Error: $e");
    }
  }
}
