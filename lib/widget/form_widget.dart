import 'package:flutter/material.dart';

class FormWidget extends StatelessWidget {
  final String? name;
  final ValueChanged<String> onChangedName;

  const FormWidget({
    Key? key,
    this.name = '',
    required this.onChangedName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildName(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );

  Widget buildName() => TextFormField(
        initialValue: name,
        style: const TextStyle(
          color: Colors.amber,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Name',
          hintStyle: TextStyle(color: Colors.white70),
        ),
        validator: (name) =>
            name != null && name.isEmpty ? 'The name cannot be empty' : null,
        onChanged: onChangedName,
      );
}