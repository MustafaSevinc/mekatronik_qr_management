class Employee{
  final String name;
  final String surname;
  final String id;

  Employee({
    required this.name,
    required this.surname,
    required this.id,
});

  String get _name => name;
  String get _surname => surname;
  String get _id => id;
}