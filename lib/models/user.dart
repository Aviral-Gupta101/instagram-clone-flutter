import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String username;
  final String email;
  final String bio;
  final String photoUrl;
  final List followers;
  final List following;
  final List favorites;

  User({
    required this.uid,
    required this.username,
    required this.email,
    required this.bio,
    required this.photoUrl,
    required this.followers,
    required this.following,
    required this.favorites,
  });

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "email": email,
        "bio": bio,
        "followers": followers,
        "following": following,
        "photoUrl": photoUrl,
        "favorites": favorites
      };

  static User fromSnap(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return User(
        uid: data["uid"],
        username: data["username"],
        email: data["email"],
        bio: data["bio"],
        photoUrl: data["photoUrl"],
        followers: data["followers"],
        following: data["following"],
        favorites: data["favorites"]);
  }
}
