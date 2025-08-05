import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:service_app/model/app_constant.dart';
import 'package:service_app/model/conversation_model.dart';

class InboxViewModel {


  getConversations(){
    return FirebaseFirestore.instance.collection("conversations")
    .where("userIDs",arrayContains: AppConstants.currentUser.id)
    .snapshots();
  }

  getMessages(ConversationModel? conversation){
    return FirebaseFirestore.instance
          .collection("conversation/${conversation!.id}/messages")
          .orderBy("dateTime")
          .snapshots();
  }
}