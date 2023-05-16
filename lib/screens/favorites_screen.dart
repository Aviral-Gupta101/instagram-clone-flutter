import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/favorites_search_input.dart';

class FavoratieScreen extends StatefulWidget {
  const FavoratieScreen({super.key});

  @override
  State<FavoratieScreen> createState() => _FavoratieScreenState();
}

class _FavoratieScreenState extends State<FavoratieScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: const Text(
            "favorites",
          ),
          centerTitle: false,
        ),
        body: ListView(
          children: const [
            FavoritesSearchInpu(),
          ],
        ));
  }
}
