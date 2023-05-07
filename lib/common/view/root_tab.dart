import 'package:delivery_app/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

class RootTab extends StatelessWidget {
  const RootTab({super.key});

  

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      child: Scaffold(
        body: Center(
          child: Text('root tab'),
        ),
      ),
    );
  }
}