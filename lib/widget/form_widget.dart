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
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Nom ville',
        ),
        validator: (name) =>
            name != null && name.isEmpty ? 'Remplir le nom' : null,
        onChanged: onChangedName,
      );
}
