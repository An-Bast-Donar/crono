import 'package:flutter/material.dart';

class SmallWindowPage extends StatelessWidget {
  const SmallWindowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const Center(child: SizedBox.shrink()));
  }
}
