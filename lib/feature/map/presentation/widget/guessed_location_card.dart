import 'package:flutter/material.dart';

import 'rounded_icon_button.dart';

const _vertPadding = 8.0;

class GuessedLocationCard extends StatelessWidget {
  const GuessedLocationCard({
    super.key,
    required this.title,
    required this.onClosed,
    this.onPrimary,
    this.onSecondary,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final VoidCallback onClosed;
  final VoidCallback? onPrimary;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final subtitleText = subtitle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.headline6,
              ),
            ),
            RoundedIconButton(
              icon: Icons.close,
              foregroundColor: theme.colorScheme.onBackground,
              backgroundColor: theme.colorScheme.background,
              onPressed: onClosed,
            ),
          ],
        ),
        if (subtitleText != null)
          Flexible(
            child: Text(
              subtitleText,
              style: theme.textTheme.bodyText2,
            ),
          ),
        if (onPrimary != null)
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              vertical: _vertPadding,
            ),
            child: ElevatedButton(
              onPressed: onPrimary,
              child: const Center(
                child: Text(
                  'Выбрать предложенную точку',
                ),
              ),
            ),
          ),
        if (onSecondary != null)
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              vertical: _vertPadding,
            ),
            child: ElevatedButton(
              onPressed: onSecondary,
              child: const Center(
                child: Text(
                  'Выбрать точные координаты',
                ),
              ),
            ),
          ),
      ],
    );
  }
}
