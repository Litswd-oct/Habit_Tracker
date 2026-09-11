import 'dart:convert';

class Habit {
  final String id;
  final String name;
  final int iconCodePoint;
  final int colorValue;
  final int targetPerDay;
  final Map<String, int> completions;

  Habit({
    required this.id,
    required this.name,
    required this.iconCodePoint,
    required this.colorValue,
    required this.targetPerDay,
    Map<String, int>? completions,
  }) : completions = completions ?? {};

  Habit copyWith({
    String? name,
    int? iconCodePoint,
    int? colorValue,
    int? targetPerDay,
    Map<String, int>? completions,
  }) {
    return Habit(
      id: id,
      name: name ?? this.name,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      colorValue: colorValue ?? this.colorValue,
      targetPerDay: targetPerDay ?? this.targetPerDay,
      completions: completions ?? Map.from(this.completions),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'iconCodePoint': iconCodePoint,
      'colorValue': colorValue,
      'targetPerDay': targetPerDay,
      'completions': completions,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      iconCodePoint: map['iconCodePoint'] ?? 0,
      colorValue: map['colorValue'] ?? 0,
      targetPerDay: map['targetPerDay'] ?? 1,
      completions: Map<String, int>.from(map['completions'] ?? {}),
    );
  }

  String toJson() => json.encode(toMap());

  factory Habit.fromJson(String source) => Habit.fromMap(json.decode(source));
}
