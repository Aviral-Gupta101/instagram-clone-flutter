import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/screens/search_screen.dart';

const webScreenSize = 600;

var homeScreenItems = const [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Center(
    child: Text("favortie"),
  ),
  Center(
    child: Text("person"),
  ),
];
