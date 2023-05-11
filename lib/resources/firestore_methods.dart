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
}
