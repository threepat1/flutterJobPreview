class Person {
  final String id;
  final String fullName;
  final int age;
  final String street;
  final String province;
  final String zipCode;

  Person({
    required this.id,
    required this.fullName,
    required this.age,
    required this.street,
    required this.province,
    required this.zipCode,
  });


  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      id: map['_id'],
      age: map['age'],
      fullName: map['fullName'],
      province: map['province'],
      street: map['street'],
      zipCode: map['zipCode'],
    );
  }
}
