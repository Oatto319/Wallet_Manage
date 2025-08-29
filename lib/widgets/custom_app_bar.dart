import 'package:flutter/material.dart';
import '../screens/home_screen.dart';

PreferredSizeWidget customAppBar(BuildContext context, String title) {
  return AppBar(
    leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      },
      tooltip: 'Back to Home',
    ),
    title: Text(title),
    actions: [
      
    ],
  );
}