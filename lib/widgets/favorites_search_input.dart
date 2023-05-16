import 'package:flutter/material.dart';

class FavoritesSearchInpu extends StatelessWidget {
  const FavoritesSearchInpu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
          color: Color.fromRGBO(38, 38, 38, 1.000),
          borderRadius: BorderRadius.all(Radius.circular(14))),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Colors.grey.shade700,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: "Seach",
                hintStyle: TextStyle(fontWeight: FontWeight.bold),
                border: InputBorder.none,
              ),
              onFieldSubmitted: (value) {},
            ),
          ),
        ],
      ),
    );
  }
}
