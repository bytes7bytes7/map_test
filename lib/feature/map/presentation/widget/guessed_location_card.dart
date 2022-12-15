import 'package:flutter/material.dart';

import 'rounded_icon_button.dart';

const _vertPadding = 8.0;

class GuessedLocationCard extends StatelessWidget {
  const GuessedLocationCard({
    super.key,
    required this.title,
    required this.onClosed,
    required this.onSubmitted,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final VoidCallback onClosed;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final subtitleText = subtitle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: theme.textTheme.headline6,
            ),
            const Spacer(),
            RoundedIconButton(
              icon: Icons.close,
              foregroundColor: theme.colorScheme.onBackground,
              backgroundColor: theme.colorScheme.background,
              onPressed: onClosed,
            ),
          ],
        ),
        if (subtitleText != null)
          Text(
            subtitleText,
            style: theme.textTheme.bodyText2,
          ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            vertical: _vertPadding,
          ),
          child: ElevatedButton(
            onPressed: onSubmitted,
            child: const Center(
              child: Text(
                'Подтвердить',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
