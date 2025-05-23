import 'package:flutter/material.dart';
import 'package:food_delivery_app/Model/bottom_icon_model.dart';  
import 'package:food_delivery_app/View/home_page.dart';
import 'package:food_delivery_app/View/news_page.dart';  
import 'package:food_delivery_app/consts.dart';  
import 'package:food_delivery_app/View/profile_page.dart'; 
import 'package:food_delivery_app/View/map_page.dart';


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  final List selectedPage = [
    const HomePage(),
    const NewsPage(),
    const MapPage(),
    const ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbgColor,
      bottomNavigationBar: Container(
        height: 85,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...List.generate(
              bottomIcons.length,
              (index) => GestureDetector(
                onTap: () {
                  setState(() {
                    currentIndex = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Icon(
                        currentIndex == index
                            ? bottomIcons[index].selected
                            : bottomIcons[index].unselected,
                        color: kblack,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: const BoxDecoration(
                          color: kblack,
                          shape: BoxShape.circle,
                        ),
                        width: currentIndex == index ? 7 : 0,
                        height: currentIndex == index ? 7 : 0,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: selectedPage[currentIndex],
    );
  }
}