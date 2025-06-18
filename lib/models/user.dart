class User {
  final int? id;
  final String? name;
  final String? email;
  final String? hp;
  final String? password;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.hp,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? null,
      name: json['name'] ?? null,
      email: json['email'] ?? null,
      hp: json['hp'] ?? null,
      password: json['password'] ?? null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'hp': hp,
      };
}
