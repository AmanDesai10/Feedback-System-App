import 'package:flutter/material.dart';
import 'build_bar.dart';
import './paint/ripple_effect.dart';
import 'paint/sliced_card.dart';

class AnimatedButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final Color activeColor;
  final double size;
  final int index;
  final Color slidingCardColor;
  final Color inactiveColor;
  final int itemCount;
  final OnButtonPressCallback onTap;
  const AnimatedButton({
    Key? key,
    required this.icon,
    required this.size,
    required this.title,
    required this.isSelected,
    required this.activeColor,
    required this.onTap,
    required this.index,
    required this.slidingCardColor,
    required this.inactiveColor,
    required this.itemCount,
  }) : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    if (widget.isSelected) {
      _animationController.forward(from: 0.3);
    }
  }

  Widget _buildCard(double height) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      // width: 70,
      color: Color(0xfff1f3ff),
      width: deviceWidth / widget.itemCount,
      height: height,
      child: SlicedCard.draw(
          cardColor: widget.slidingCardColor,
          heightFraction: Tween<double>(begin: 0.1, end: 0.4)
              .animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(0.5, 0.7),
                ),
              )
              .value),
    );
  }

  @override
  void didUpdateWidget(AnimatedButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isSelected != widget.isSelected && !widget.isSelected) {
      _animationController.reverse();
    }
  }

  TextStyle getTextStyle() => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: widget.activeColor,
      );

  // copied from here
  //https://stackoverflow.com/a/62536187/16122873
  double textHeight(text, textStyle) => (TextPainter(
          text: TextSpan(text: text, style: textStyle),
          maxLines: 1,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          textDirection: Directionality.of(context))
        ..layout())
      .size
      .height;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final activeColor = widget.activeColor;
    final size = widget.size;
    final index = widget.index;
    final onTap = widget.onTap;
    final title = widget.title;
    final inactiveColor = widget.inactiveColor;
    final slidingCardColor = widget.slidingCardColor;
    return GestureDetector(
      onTap: () {
        onTap(index);
        if (_animationController.status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (_, __) => Stack(
          alignment: Alignment.center,
          children: [
            Container(
              color: Color(0xfff1f3ff),
              width: 56,
              height: 56,
            ),
            SlideTransition(
              position: Tween<Offset>(
                begin: Offset.zero,
                end: Offset(0, -1.4),
              ).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(0.3, 1.0),
                ),
              ),
              child: Icon(
                widget.icon,
                size: size,
                color: inactiveColor,
              ),
            ),
            SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0, 0.8),
                end: Offset(0, -0.8),
              ).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(0.3, 1.0),
                ),
              ),
              child: _buildCard(64),
            ),
            SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0, 1.6),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(0.3, 1.0),
                ),
              ),
              child: Container(
                width: deviceWidth / widget.itemCount,
                // color: Colors.amber,
                alignment: Alignment.center,
                height: textHeight(title, getTextStyle()),
                child: Text(
                  title,
                  overflow: TextOverflow.clip,
                  maxLines: 1,
                  style: getTextStyle(),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, 42),
              child: _buildCard(56.0),
            ),
            Transform.translate(
              offset: Offset(0, 25),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(0.3, 1.0),
                  ),
                ),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: activeColor,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: widget.isSelected && _animationController.value <= 0.3,
              child: RippleEffect.draw(
                size: Tween<double>(begin: 8.0, end: 56.0)
                    .animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(0.0, 0.3),
                      ),
                    )
                    .value,
                strokeWidth: Tween<double>(begin: 24.0, end: 0.0)
                    .animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(0.1, 0.3),
                      ),
                    )
                    .value,
                rippleColor: activeColor.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
