import 'package:delivery_app/common/const/colors.dart';
import 'package:delivery_app/common/layout/default_layout.dart';
import 'package:delivery_app/restaurant/view/restaurant_screen.dart';
import 'package:flutter/material.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
late TabController controller;

  int index = 0;

  @override
  void initState(){
    super.initState();
    
    controller = TabController(length: 4, vsync: this);
    controller.addListener(() { 
      tabListener();
    });
  }
  @override
  void dispose(){
    controller.removeListener(() {
      tabListener();
    });
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: "성수 딜리버리",
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BDOY_TEXT_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        onTap: (int index){
          setState(() {
          controller.animateTo(index);
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "home"),
          BottomNavigationBarItem(icon: Icon(Icons.food_bank_rounded), label: "food"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded), label: "order"),
          BottomNavigationBarItem(icon: Icon(Icons.person_2_outlined), label: "profile"),
        ]),
      child : TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          const RestaurantScreen(
          ),
          Center(
            child: Container(
              child: const Text("음식"),
            ),
          ),
          Center(
            child: Container(
              child: const Text("주문"),
            ),
          ),
          Center(
            child: Container(
              child: const Text("프로필"),
            ),
          )
      ],
      ),
    );
  }
}