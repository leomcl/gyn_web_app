import 'package:flutter/material.dart';

class GymTrendCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> items;
  final IconData icon;
  final Color color;
  final int? limit;

  const GymTrendCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.items,
    required this.icon,
    required this.color,
    this.limit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayItems = (limit != null && limit! < items.length)
        ? items.sublist(0, limit)
        : items;

    // Calculate appropriate list height based on item count
    final double listHeight = _calculateListHeight(displayItems.length);

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 300;
        return Container(
          width: isDesktop ? null : 220,
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title row
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: color, size: 24),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Subtitle
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const Divider(height: 24),
                // Items list - dynamically sized based on content
                displayItems.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(
                          child: Text(
                            'No data available',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey[500],
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: listHeight,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: displayItems.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${index + 1}.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: color,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      displayItems[index],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Calculate list height based on number of items
  double _calculateListHeight(int itemCount) {
    if (itemCount == 0) return 40; // No data message
    if (itemCount == 1) return 30; // Single item
    if (itemCount == 2) return 60; // Two items
    if (itemCount == 3) return 90; // Three items
    return 120; // Four or more items
  }
}
