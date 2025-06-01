import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';

class ExpandableStockCard extends StatefulWidget {
  final String title;
  final String amount;
  final List<Widget> children;

  const ExpandableStockCard({
    super.key,
    required this.title,
    required this.amount,
    required this.children,
  });

  @override
  State<ExpandableStockCard> createState() => _ExpandableStockCardState();
}

class _ExpandableStockCardState extends State<ExpandableStockCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => isExpanded = !isExpanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(widget.title, style: appFont(11, appPurple, weight: FontWeight.w600)),
                    !isExpanded ? Icon(Icons.arrow_drop_down,color: appPurple,) :  Icon(Icons.arrow_drop_up,color: appPurple,)
                  ],
                ),
                Text(widget.amount, style: appFont(9, appPurple, weight: FontWeight.w600)),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.children
                  .map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0),
                child: e,
              ))
                  .toList(),
            ),
          ),
          crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
      ],
    );
  }
}
