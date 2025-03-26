import 'package:flutter/material.dart';
import 'gym_trend_card.dart';

class GymTrendSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const GymTrendSection({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate adaptive height based on children content
    final adaptiveHeight = _calculateAdaptiveHeight();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                // For desktop layout, use a responsive grid
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: constraints.maxWidth > 1200 ? 4 : 2,
                      childAspectRatio: 1.3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      mainAxisExtent: adaptiveHeight,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: children.length,
                    itemBuilder: (context, index) => children[index],
                  ),
                );
              } else {
                // For mobile layout, use an adaptive height list
                return Container(
                  height: adaptiveHeight,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    children: children,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // Helper method to calculate adaptive height based on children content
  double _calculateAdaptiveHeight() {
    // Check if any child is a GymTrendCard and analyze its content
    if (children.isNotEmpty) {
      for (var child in children) {
        if (child is GymTrendCard) {
          // Adjust height based on number of items
          final itemCount = child.items.length;
          if (itemCount <= 1) return 180;
          if (itemCount <= 2) return 200;
          if (itemCount <= 3) return 230;
          return 250;
        }
      }
    }
    // Default height if no GymTrendCard is found
    return 220;
  }
}
