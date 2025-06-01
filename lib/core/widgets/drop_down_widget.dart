import 'package:flutter/material.dart';
import 'package:goal_planner/core/constants/constants.dart';

class CustomFocusDropdown<T> extends StatefulWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String label;


  const CustomFocusDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.label,

  });

  @override
  State<CustomFocusDropdown<T>> createState() => _CustomFocusDropdownState<T>();
}

class _CustomFocusDropdownState<T> extends State<CustomFocusDropdown<T>> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: _isFocused ? appGrey600 : appPurple,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButtonFormField<T>(
          focusNode: _focusNode,
          value: widget.value,
          style: appFont(14, Colors.white),
          decoration: InputDecoration(
            labelText: widget.label,
            border: InputBorder.none,
            labelStyle: const TextStyle(fontSize: 12, color: appGrey),
          ),
          items: widget.items,
          onChanged: widget.onChanged,
          dropdownColor: appDarkGrey,
          
        ),
      ),
    );
  }
}
