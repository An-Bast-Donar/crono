import 'package:flutter/material.dart';

class LargeWindowPage extends StatelessWidget {
  const LargeWindowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: false,
        title: const Text('CRONO'),
      ),
      body: const Center(child: SizedBox.shrink()),
    );
  }
}
