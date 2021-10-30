import 'package:flutter/material.dart';

import 'animated_button.dart';
import 'menu_item.dart';

typedef OnButtonPressCallback = void Function(int index);

class BuildBar extends StatelessWidget {
  final List<BarItem> buttons;
  final int selectedIndex;
  final double iconSize;
  final Color? activeColor;
  final Color? inactiveColor;
  final OnButtonPressCallback onButtonPress;
  final Color backgroundColor;

  const BuildBar({
    Key? key,
    required this.buttons,
    required this.selectedIndex,
    required this.iconSize,
    required this.activeColor,
    required this.inactiveColor,
    required this.onButtonPress,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      height: 65,
      decoration: BoxDecoration(
        color: Color(0xfff1f3ff),
      ),
      alignment: Alignment.topCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: buttons.map(
          (item) {
            final buttonIndex = buttons.indexOf(item);
            return AnimatedButton(
              icon: item.icon,
              size: iconSize,
              title: item.title,
              activeColor: item.activeColor ?? activeColor!,
              inactiveColor: item.inactiveColor ?? inactiveColor!,
              index: buttonIndex,
              isSelected: buttonIndex == selectedIndex ? true : false,
              onTap: onButtonPress,
              slidingCardColor: backgroundColor,
              itemCount: buttons.length,
            );
          },
        ).toList(),
      ),
    );
  }
}
