import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomIcon {
  final IconData unselected, selected;

  BottomIcon({
    required this.selected,
    required this.unselected,
  });
}

List<BottomIcon> bottomIcons = [
  BottomIcon(
    selected: Icons.home_filled,
    unselected: Icons.home_outlined,
  ),
 BottomIcon(
  selected: CupertinoIcons.news,
  unselected: CupertinoIcons.news,
),



  BottomIcon(
    selected: CupertinoIcons.compass_fill,
    unselected: CupertinoIcons.compass,
  ),
  BottomIcon(
    selected: Icons.person_rounded,
    unselected: Icons.person_outline_rounded,
  ),
];