import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;

  void _selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardOpen = mediaQuery.viewInsets.bottom > 0;
    Widget logoToShow = Container();
    Widget avatarToShow = Container();

    if (!keyboardOpen) {
      logoToShow = Column(
        children: [
          SvgPicture.asset(
            "assets/ic_instagram.svg",
            color: primaryColor,
            height: 64,
          ),
          const SizedBox(
            height: 64,
          ),
        ],
      );
      avatarToShow = Stack(
        children: [
          _image != null
              ? CircleAvatar(
                  radius: 64,
                  backgroundImage: MemoryImage(_image!),
                )
              : const CircleAvatar(
                  radius: 64,
                  backgroundImage: NetworkImage(
                      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png"),
                ),
          Positioned(
            bottom: -10,
            left: 80,
            child: IconButton(
                onPressed: _selectImage, icon: const Icon(Icons.add_a_photo)),
          ),
        ],
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            children: [
              Flexible(child: Container(), flex: 1),
              logoToShow,
              avatarToShow,
              const SizedBox(
                height: 24,
              ),
              TextFiledInput(
                textEditingController: _usernameController,
                hintText: "Enter your Username",
                keyboardType: TextInputType.name,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFiledInput(
                textEditingController: _emailController,
                hintText: "Enter your email",
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFiledInput(
                textEditingController: _passwordController,
                hintText: "Enter your password",
                keyboardType: TextInputType.text,
                obscureText: true,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFiledInput(
                textEditingController: _bioController,
                hintText: "Enter your bio",
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: () async {
                  // String res = await Auts
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: const ShapeDecoration(
                    color: blueColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                  ),
                  child: const Text("Sign up"),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(child: Container(), flex: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Alrady have an account? "),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "Login.",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
