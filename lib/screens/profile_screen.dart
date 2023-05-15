import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';

import '../providers/user_provider.dart';
import '../widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  final bool currentUser;
  const ProfileScreen(
      {required this.uid, required this.currentUser, super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var currentUid = FirebaseAuth.instance.currentUser!.uid;
  bool isLoading = true;
  late final uid;
  var userData = {};
  bool isFollowing = false;
  int follower = 0;
  int following = 0;

  Future<void> getUserData() async {
    try {
      setState(() {
        uid = widget.currentUser ? currentUid : widget.uid;
      });
      FirebaseFirestore ref = FirebaseFirestore.instance;
      DocumentSnapshot userSnap = await ref.collection("users").doc(uid).get();
      QuerySnapshot postSnap =
          await ref.collection("posts").where("uid", isEqualTo: uid).get();

      setState(() {
        userData = userSnap.data() as Map<String, dynamic>;
        var postCount = postSnap.docs.length;
        userData = {...userData, "postCount": postCount};
        isFollowing = userData["followers"].contains(currentUid);
        isLoading = false;
        follower = userData["followers"].length;
        following = userData["following"].length;
      });
    } catch (e) {
      showSnackbar(e.toString(), context);
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData["username"]),
              centerTitle: false,
            ),
            body: SafeArea(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(
                                userData["photoUrl"],
                              ),
                              radius: 40,
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      buildStatColoum(
                                        "posts",
                                        userData["postCount"],
                                      ),
                                      buildStatColoum(
                                        "followers",
                                        follower,
                                      ),
                                      buildStatColoum(
                                        "following",
                                        following,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      currentUid == uid
                                          ? FollowButton(
                                              backgroundColor:
                                                  mobileBackgroundColor,
                                              text: "Signout",
                                              textColor: primaryColor,
                                              borderColor: Colors.grey,
                                              function: () async {
                                                await AuthMethods().signout();
                                                await Future.delayed(
                                                  const Duration(
                                                      milliseconds: 500),
                                                );
                                                UserProvider().removeUser();
                                                if (!mounted) return;
                                                Navigator.of(context)
                                                    .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        const LoginScreen(),
                                                  ),
                                                  (Route<dynamic> route) =>
                                                      false,
                                                );
                                              },
                                            )
                                          : isFollowing
                                              ? FollowButton(
                                                  backgroundColor: Colors.white,
                                                  text: "Unfollow",
                                                  textColor: Colors.black,
                                                  borderColor: Colors.grey,
                                                  function: () {
                                                    FirestoreMethods()
                                                        .toogleFollow(
                                                      currentUid,
                                                      widget.uid,
                                                    );
                                                    setState(() {
                                                      isFollowing = false;
                                                      follower--;
                                                    });
                                                  },
                                                )
                                              : FollowButton(
                                                  backgroundColor: Colors.blue,
                                                  text: "Follow",
                                                  textColor: Colors.white,
                                                  borderColor: Colors.blue,
                                                  function: () {
                                                    FirestoreMethods()
                                                        .toogleFollow(
                                                      currentUid,
                                                      widget.uid,
                                                    );
                                                    setState(() {
                                                      isFollowing = true;
                                                      follower++;
                                                    });
                                                  },
                                                ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            userData["username"],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(top: 1),
                          child: Text(
                            userData["bio"],
                          ),
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("posts")
                        .where("uid", isEqualTo: uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        );
                      }
                      if (!snapshot.hasData) {
                        return const Center(
                          child: Text("Unable to load users post"),
                        );
                      }
                      return GridView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 1.5,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          return GridTile(
                            child: Image.network(
                              snapshot.data!.docs[index]["postUrl"],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
  }

  Column buildStatColoum(String label, int num) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
