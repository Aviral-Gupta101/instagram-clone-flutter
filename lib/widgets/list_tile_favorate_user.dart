import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

import '../resources/firestore_methods.dart';
import 'follow_button.dart';

class ListTileFavorateUser extends StatefulWidget {
  final String userUid;
  final String guestUid;
  const ListTileFavorateUser(
      {required this.userUid, required this.guestUid, super.key});

  @override
  State<ListTileFavorateUser> createState() => _ListTileFavorateUserState();
}

class _ListTileFavorateUserState extends State<ListTileFavorateUser> {
  Map<String, dynamic> data = {};
  bool isLoading = true;

  Future<void> getData() async {
    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.guestUid)
        .get();
    setState(() {
      data = snap.data() as Map<String, dynamic>;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(data["photoUrl"]),
              ),
              title: Text(data["username"]),
              subtitle: Text(data["bio"]),
              trailing: SizedBox(
                height: 50,
                width: 100,
                child: FollowButton(
                  backgroundColor: mobileBackgroundColor,
                  borderColor: Colors.white,
                  text: "Remove",
                  textColor: Colors.white,
                  function: () async {
                    await FirestoreMethods().toogleFavorites(
                      widget.userUid,
                      widget.guestUid,
                    );
                  },
                ),
              ),
            ),
          );
  }
}
