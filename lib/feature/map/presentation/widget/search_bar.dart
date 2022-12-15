import 'package:flutter/material.dart';

const _margin = 10.0;
const _padding = 4.0;
const _borderRadius = 8.0;
const _prefixPadding = 10.0;

class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onClear,
    this.focusNode,
  });

  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final VoidCallback? onClear;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(_margin),
      padding: const EdgeInsets.all(_padding),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(_prefixPadding),
            child: Icon(Icons.search),
          ),
          Flexible(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: 'Поиск',
                suffixIcon: GestureDetector(
                  onTap: onClear,
                  child: const Icon(
                    Icons.close,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
