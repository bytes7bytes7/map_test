import 'package:flutter/material.dart';

const _marginH = 10.0;
const _marginV = 0.0;
const _padding = 4.0;

class SearchList extends StatelessWidget {
  const SearchList({
    super.key,
    required this.maxHeight,
    required this.items,
    this.errorMessage,
  });

  final double maxHeight;
  final List<Widget> items;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: 0,
        maxHeight: maxHeight,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: _marginH,
        vertical: _marginV,
      ),
      padding: const EdgeInsets.all(_padding),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: items.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return items[index];
              },
            )
          : errorMessage != null
              ? Text(
                  errorMessage!,
                  style: theme.textTheme.subtitle2?.copyWith(
                    color: theme.errorColor,
                  ),
                  textAlign: TextAlign.center,
                )
              : Text(
                  'Ничего не найдено',
                  style: theme.textTheme.subtitle2,
                  textAlign: TextAlign.center,
                ),
    );
  }
}
