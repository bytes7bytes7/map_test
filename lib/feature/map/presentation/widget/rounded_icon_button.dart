import 'package:flutter/material.dart';

const _iconSize = 14.0;
const _buttonSize = 24.0;

class RoundedIconButton extends StatelessWidget {
  const RoundedIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconSize = _iconSize,
    this.buttonSize = _buttonSize,
    this.backgroundColor,
    this.foregroundColor,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final double iconSize;
  final double buttonSize;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: ButtonStyle(
        alignment: Alignment.center,
        padding: const MaterialStatePropertyAll(EdgeInsets.zero),
        minimumSize: MaterialStatePropertyAll(Size.square(buttonSize)),
        maximumSize: MaterialStatePropertyAll(Size.square(buttonSize)),
        backgroundColor: MaterialStatePropertyAll(
          backgroundColor,
        ),
        shape: const MaterialStatePropertyAll(
          CircleBorder(),
        ),
      ),
      icon: Icon(
        icon,
        size: iconSize,
      ),
      color: foregroundColor,
      onPressed: onPressed,
    );
  }
}
