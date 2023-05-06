import 'package:flutter/material.dart';
import 'package:instagram_clone/responsive/dimensions.dart';

class ResponsiveLayoutScreen extends StatelessWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayoutScreen(
      {required this.webScreenLayout,
      required this.mobileScreenLayout,
      super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > webScreenSize) {
        return webScreenLayout;
      }
      return mobileScreenLayout;
    });
  }
}
