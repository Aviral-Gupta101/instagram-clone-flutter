import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/comments_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  const PostCard({required this.snap, super.key});

  final Map<String, dynamic> snap;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int comment = 0;

  void getCommentCount() async {
    final val = await FirestoreMethods().commentsCount(widget.snap["postId"]);
    setState(() {
      comment = val;
    });
  }

  @override
  void initState() {
    super.initState();
    getCommentCount();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return user == null
        ? const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          )
        : Container(
            color: mobileBackgroundColor,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                // HEADER SECTION
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                          .copyWith(right: 0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(widget.snap["profileImage"]),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.snap["username"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (builder) {
                              return Dialog(
                                child: ListView(
                                  shrinkWrap: true,
                                  children: ["delete"]
                                      .map(
                                        (e) => InkWell(
                                          onTap: () {},
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 16),
                                            child: Text(e),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                ),

                // IMAGE SECTION
                GestureDetector(
                  onDoubleTap: () async {
                    await FirestoreMethods().likePost(
                      widget.snap["postId"],
                      user.uid,
                      widget.snap["likes"],
                    );
                    setState(() {
                      isLikeAnimating = true;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: double.infinity,
                        child: Image.network(
                          widget.snap["postUrl"],
                          fit: BoxFit.cover,
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(microseconds: 200),
                        opacity: isLikeAnimating ? 1 : 0,
                        child: LikeAnimation(
                          isAnimation: isLikeAnimating,
                          duration: const Duration(
                            milliseconds: 500,
                          ),
                          onEnd: () {
                            setState(() {
                              isLikeAnimating = false;
                            });
                          },
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 120,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // LIKE COMMENT SECTION
                Row(
                  children: [
                    LikeAnimation(
                      isAnimation: widget.snap["likes"].contains(user.uid),
                      smallLike: true,
                      child: IconButton(
                        onPressed: () async {
                          await FirestoreMethods().likePost(
                            widget.snap["postId"],
                            user.uid,
                            widget.snap["likes"],
                          );
                        },
                        icon: widget.snap["likes"].contains(user.uid)
                            ? const Icon(Icons.favorite, color: Colors.red)
                            : const Icon(
                                Icons.favorite_border,
                              ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => CommentScreen(widget.snap))),
                      icon: const Icon(
                        Icons.comment_outlined,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.send,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.bookmark_outline),
                        ),
                      ),
                    )
                  ],
                ),

                // DESCRIPTION AND NUMBER OF COMMENTS
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        child: Text(
                          "${widget.snap["likes"].length.toString()} Likes",
                          // style: TextStyle(fontWeight: FontWeight.w500),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 8),
                        width: double.infinity,
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: primaryColor),
                            children: [
                              TextSpan(
                                  text: widget.snap["username"],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                text: "  ${widget.snap["description"]}",
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          width: double.infinity,
                          child: Text(
                            "View all $comment comments",
                            style: const TextStyle(
                              fontSize: 16,
                              color: secondaryColor,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        width: double.infinity,
                        child: Text(
                          DateFormat.yMMMd()
                              .format(widget.snap["datePublished"].toDate()),
                          style: const TextStyle(
                            fontSize: 16,
                            color: secondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
