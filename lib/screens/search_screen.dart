import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isShowUser = false;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: "Search for a user",
          ),
          onFieldSubmitted: (String _) {
            if (_.length >= 2) {
              setState(() {
                isShowUser = true;
              });
            }
          },
        ),
      ),
      body: isShowUser
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("users")
                  .where("username",
                      isGreaterThanOrEqualTo: _searchController.text.trim())
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(
                    color: primaryColor,
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (_, index) {
                    final snapData = snapshot.data!.docs[index].data();
                    if (snapData["uid"] !=
                        FirebaseAuth.instance.currentUser!.uid) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(snapData["photoUrl"]),
                        ),
                        title: Text(snapData["username"]),
                      );
                    }
                  },
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection("posts").get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) =>
                      Image.network(snapshot.data!.docs[index]["postUrl"]),
                  staggeredTileBuilder: (index) => StaggeredTile.count(
                    (index % 7 == 0 ? 2 : 1),
                    (index % 7 == 0 ? 2 : 1),
                  ),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                );
              },
            ),
    );
  }
}
