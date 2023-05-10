import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profileImage;
  final likes;

  Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.postUrl,
    required this.datePublished,
    required this.profileImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "postId": postId,
        "postUrl": postUrl,
        "profileImage": profileImage,
        "datePublished": datePublished,
        "description": description,
        "likes": likes,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return Post(
      uid: data["uid"],
      username: data["username"],
      postId: data["postId"],
      postUrl: data["postUrl"],
      profileImage: data["profileImage"],
      datePublished: data["datePublished"],
      description: data["description"],
      likes: data["likes"],
    );
  }
}
