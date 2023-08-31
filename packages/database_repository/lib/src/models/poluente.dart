/// {@template Poluente}
/// Poluente model
///
/// [Poluente.empty] represents a new Poluente.
/// {@endtemplate}
class Poluente{
  /// {@macro Poluente}
  Poluente({
    required this.id,
    required this.name,
    this.size,
    this.solution,
    this.date,
  });

  /// The current Poluente's id.
  late final String id;

  /// The current Poluente's name (display name).
  String name;

  /// The current Poluente's size.
  int? size;

  /// The current Poluente's solution.
  String? solution;

  /// The current Poluente's solution date.
  DateTime? date;

  /// Empty Poluente which represents a new Poluente.
  static Poluente get empty => Poluente(id: '', name: '');

  /// Poluente factory which represents a clone Poluente.
  Poluente get clone => Poluente(
        id: this.id,
        name: this.name,
        size: this.size,
        solution: this.solution,
        date: this.date,
      );

  /// Convenience getter to determine whether the current poluente is empty.
  bool get isEmpty => this.id.isEmpty;

  /// Convenience getter to determine whether the current poluente is valid.
  bool get isValid => !this.name.isEmpty;
}
