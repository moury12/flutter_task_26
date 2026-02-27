import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final String city;
  final String street;
  final int number;
  final String zipcode;

  const Address({
    required this.city,
    required this.street,
    required this.number,
    required this.zipcode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'] as String? ?? '',
      street: json['street'] as String? ?? '',
      number: (json['number'] as num?)?.toInt() ?? 0,
      zipcode: json['zipcode'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [city, street, number, zipcode];
}

class UserName extends Equatable {
  final String firstname;
  final String lastname;

  const UserName({required this.firstname, required this.lastname});

  factory UserName.fromJson(Map<String, dynamic> json) {
    return UserName(
      firstname: json['firstname'] as String? ?? '',
      lastname: json['lastname'] as String? ?? '',
    );
  }

  String get fullName => '$firstname $lastname';

  @override
  List<Object?> get props => [firstname, lastname];
}

class User extends Equatable {
  final int id;
  final String email;
  final String username;
  final String phone;
  final UserName name;
  final Address address;

  const User({
    required this.id,
    required this.email,
    required this.username,
    required this.phone,
    required this.name,
    required this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String? ?? '',
      username: json['username'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      name: UserName.fromJson(json['name'] as Map<String, dynamic>? ?? {}),
      address: Address.fromJson(json['address'] as Map<String, dynamic>? ?? {}),
    );
  }

  @override
  List<Object?> get props => [id, email, username, phone, name, address];
}
