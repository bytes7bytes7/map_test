import 'package:flutter/material.dart';

class SearchSuggestionCard extends StatelessWidget {
  const SearchSuggestionCard({
    super.key,
    required this.title,
    required this.onPressed,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final subtitleText = subtitle;

    return ListTile(
      title: Text(
        title,
      ),
      subtitle: subtitleText != null
          ? Text(
              subtitleText,
            )
          : null,
      onTap: onPressed,
    );
  }
}
