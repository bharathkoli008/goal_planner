import 'package:flutter/material.dart';
import 'package:goal_planner/core/constants/constants.dart';

class CustomFocusTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;

  const CustomFocusTextField({
    super.key,
    required this.controller,
    required this.label,
    this.onSubmitted,
    this.onChanged,

    this.keyboardType = TextInputType.text,
  });

  @override
  State<CustomFocusTextField> createState() => _CustomFocusTextFieldState();
}

class _CustomFocusTextFieldState extends State<CustomFocusTextField> {
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
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          color: _isFocused ? appPurple : appGrey600,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          focusNode: _focusNode,
          style: appFont(14, Colors.white),
          controller: widget.controller,
          cursorColor: appPurple,
          keyboardType: widget.keyboardType,
          onSubmitted: widget.onSubmitted,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: const TextStyle(fontSize: 12, color: Colors.grey),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
