// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // upload post
  Future<String> uploadPost(
    String description,
    String uid,
    Uint8List file,
    String username,
    String profileImage,
  ) async {
    String res = "some error occured";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage("posts", file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        postUrl: photoUrl,
        datePublished: DateTime.now(),
        profileImage: profileImage,
        likes: [],
      );

      _firestore.collection("posts").doc(postId).set(
            post.toJson(),
          );
      res = "success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      final ref = _firestore.collection("posts").doc(postId);
      if (likes.contains(uid)) {
        await ref.update({
          "likes": FieldValue.arrayRemove([uid]),
        });
      } else {
        await ref.update({
          "likes": FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> postComment(String postId, String text, String uid,
      String username, String profilePic) async {
    String res = "some error occurred";
    try {
      if (text.trim().isEmpty) return "no input";
      String commentId = const Uuid().v1();
      DocumentReference ref = _firestore
          .collection("posts")
          .doc(postId)
          .collection("comments")
          .doc(commentId);
      await ref.set({
        "name": username,
        "text": text,
        "profilePic": profilePic,
        "uid": uid,
        "commentId": commentId,
        "datePublished": DateTime.now(),
      });
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<int> commentsCount(String postId) async {
    int count = -1;

    try {
      CollectionReference ref =
          _firestore.collection("posts").doc(postId).collection("comments");

      await ref.get().then((QuerySnapshot querySnapshot) {
        count = querySnapshot.docs.length;
      });
    } catch (e) {
      print(e);
    }
    return count;
  }

  Future<String> deletePost(String postId) async {
    String res = "some error occured";
    try {
      await _firestore.collection("posts").doc(postId).delete();
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Follow and Unfollow
  Future<void> toogleFollow(String userUid, String guestUid) async {
    try {
      DocumentReference userRef = _firestore.collection("users").doc(userUid);
      DocumentReference guestRef = _firestore.collection("users").doc(guestUid);
      DocumentSnapshot userSnap = await userRef.get();

      if ((userSnap.data() as Map<String, dynamic>)["following"]
          .contains(guestUid)) {
        userRef.update({
          "following": FieldValue.arrayRemove([guestUid]),
        });
        guestRef.update({
          "followers": FieldValue.arrayRemove([userUid]),
        });
      } else {
        userRef.update({
          "following": FieldValue.arrayUnion([guestUid]),
        });
        guestRef.update({
          "followers": FieldValue.arrayUnion([userUid]),
        });
      }
    } catch (e) {
      print(e);
    }
  }

  // Add or Remove user to favoraite
  Future<void> toogleFavorites(String userUid, String guestUid) async {
    try {
      DocumentReference userRef = _firestore.collection("users").doc(userUid);
      DocumentSnapshot userSnap = await userRef.get();

      if ((userSnap.data() as Map<String, dynamic>)["favorites"]
          .contains(guestUid)) {
        await userRef.update({
          "favorites": FieldValue.arrayRemove([guestUid]),
        });
      } else {
        await userRef.update({
          "favorites": FieldValue.arrayUnion([guestUid]),
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
