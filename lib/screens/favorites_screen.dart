import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/favorites_search_input.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../widgets/follow_button.dart';

class FavoratieScreen extends StatefulWidget {
  const FavoratieScreen({super.key});

  @override
  State<FavoratieScreen> createState() => _FavoratieScreenState();
}

class _FavoratieScreenState extends State<FavoratieScreen> {
  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).getUser;
    return user == null
        ? const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: const Text(
                "favorites",
              ),
              centerTitle: false,
            ),
            body: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(38, 38, 38, 1.000),
                    // borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Text(
                    "From here you can directly see all the post of the user.",
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FavoritesSearchInpu(user),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text("Unable to load data"),
                      );
                    }

                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final data = snapshot.data!.docs[index].data();
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(data["photoUrl"]),
                              ),
                              title: Text(data["username"]),
                              subtitle: Text(data["bio"]),
                              trailing: SizedBox(
                                height: 50,
                                width: 80,
                                child: FollowButton(
                                  backgroundColor: Colors.blue,
                                  borderColor: Colors.blue,
                                  text: "Add",
                                  textColor: Colors.white,
                                  function: () {
                                    FirestoreMethods().toogleFavorites(
                                      user.uid,
                                      data["uid"],
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                )
              ],
            ),
          );
  }
}
