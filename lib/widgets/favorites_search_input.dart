import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/widgets/follow_button.dart';

class FavoritesSearchInpu extends StatefulWidget {
  final User user;
  const FavoritesSearchInpu(this.user, {super.key});

  @override
  State<FavoritesSearchInpu> createState() => _FavoritesSearchInpuState();
}

class _FavoritesSearchInpuState extends State<FavoritesSearchInpu> {
  final TextEditingController _controller = TextEditingController();
  bool _showUser = false;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Color.fromRGBO(38, 38, 38, 1.000),
            borderRadius: BorderRadius.all(Radius.circular(14))),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.search,
                  color: Colors.grey.shade700,
                  size: 26,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Search...",
                      hintStyle:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (value.length == 3) {
                          _showUser = true;
                        } else if (value.length == 2) {
                          _showUser = false;
                        }
                      });
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _controller.clear();
                    setState(() {
                      if (_showUser == true) {
                        _showUser = false;
                      }
                    });
                  },
                  icon: Icon(
                    Icons.clear,
                    size: 20,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("users")
                  .where("username",
                      isGreaterThanOrEqualTo: _controller.text.trim())
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text("Some error in firestroe"),
                  );
                }

                return _showUser == false
                    ? Container()
                    : Container(
                        constraints:
                            const BoxConstraints(minHeight: 0, maxHeight: 230),
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final data = snapshot.data!.docs[index].data();
                            return ListTile(
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
                                      widget.user.uid,
                                      data["uid"],
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
