import 'package:flutter/material.dart';

class SocialMediaButton extends StatelessWidget {
  final String assetPath;

  const SocialMediaButton({required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color:Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.white,
        child: Image.asset(assetPath, height: 30),
      ),
    );
  }
}
