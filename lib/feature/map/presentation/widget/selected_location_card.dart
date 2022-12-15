import 'package:flutter/material.dart';

import 'rounded_icon_button.dart';

class SelectedLocationCard extends StatelessWidget {
  const SelectedLocationCard({
    super.key,
    required this.title,
    required this.onClosed,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final VoidCallback onClosed;

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
      ],
    );
  }
}
