import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Color ? backgroundColor;
  final Widget child;
  final String ? title;
  final Widget ? bottomNavigationBar;

  const DefaultLayout({super.key, required this.child, this.backgroundColor, this.title, this.bottomNavigationBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: renderAppbar(),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
  AppBar? renderAppbar() {
  if(title ==null){
    return null;
  }
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    title : Text(title! , style: const TextStyle(
      fontWeight: FontWeight.w500,
    ),),
    foregroundColor: Colors.black,
  );
}
}


