import 'package:flutter/material.dart';

const _margin = 10.0;
const _padding = 4.0;

class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
    this.onChanged,
    this.focusNode,
  });

  final void Function(String)? onChanged;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(_margin),
      padding: const EdgeInsets.all(_padding),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              focusNode: focusNode,
              decoration: const InputDecoration(
                hintText: 'Поиск',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
