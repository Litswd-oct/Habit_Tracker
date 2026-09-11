import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/habit_provider.dart';

class AddHabitSheet extends StatefulWidget {
  const AddHabitSheet({super.key});

  @override
  State<AddHabitSheet> createState() => _AddHabitSheetState();
}

class _AddHabitSheetState extends State<AddHabitSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  int _targetPerDay = 1;
  int _selectedColor = Colors.blue.toARGB32();
  int _selectedIcon = Icons.fitness_center.codePoint;

  final List<Color> _colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
  ];

  final List<IconData> _icons = [
    Icons.fitness_center,
    Icons.local_drink,
    Icons.book,
    Icons.directions_run,
    Icons.self_improvement,
    Icons.pool,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<HabitProvider>().addHabit(
        name: _nameController.text.trim(),
        iconCodePoint: _selectedIcon,
        colorValue: _selectedColor,
        targetPerDay: _targetPerDay,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16.0,
        right: 16.0,
        top: 24.0,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Новая привычка', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Название привычки',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Введите название' : null,
              ),
              const SizedBox(height: 16.0),
              Text('Цель на день (раз): $_targetPerDay', style: const TextStyle(fontWeight: FontWeight.bold)),
              Slider(
                value: _targetPerDay.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                label: _targetPerDay.toString(),
                onChanged: (val) {
                  setState(() {
                    _targetPerDay = val.toInt();
                  });
                },
              ),
              const SizedBox(height: 8.0),
              const Text('Цвет:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              Wrap(
                spacing: 8.0,
                children: _colors.map((color) {
                  return ChoiceChip(
                    label: const Text('  '),
                    selected: _selectedColor == color.toARGB32(),
                    selectedColor: color,
                    backgroundColor: color.withValues(alpha: 0.3),
                    shape: const CircleBorder(),
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedColor = color.toARGB32());
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16.0),
              const Text('Иконка:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              Wrap(
                spacing: 8.0,
                children: _icons.map((icon) {
                  final isSelected = _selectedIcon == icon.codePoint;
                  return ChoiceChip(
                    label: Icon(icon, color: isSelected ? Colors.white : Colors.black54),
                    selected: isSelected,
                    selectedColor: Theme.of(context).primaryColor,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedIcon = icon.codePoint);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submit,
                  child: const Text('Сохранить привычку'),
                ),
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }
}
