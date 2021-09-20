import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:teledoc/variable.dart';
import 'package:path/path.dart';

class StorageRepo {
  FirebaseStorage storage =
      FirebaseStorage.instanceFor(bucket: "gs://teledoc-5cd0e.appspot.com");

  Future<String> uploadFile(File file, userId) async {
    String filename = basename(file.path);
    var storaeRef = storage.ref().child("doctors/$userId");
    var uploadTask = storaeRef.putFile(file);
    var completeTask = await uploadTask.whenComplete(() => null);
    String downloadUrl = await completeTask.ref.getDownloadURL();
    return downloadUrl;
  }

  Future addMessage(String chatRoomId, String messageId,
      Map<String, dynamic> messageInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  upLoadLastMessageSend(
      String chatRoomId, Map<String, dynamic> lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();
    if (snapShot.exists) {
      //ChatRoom Exist
      return true;
    } else {
      //ChatRoom doesnot exist
      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }
}
