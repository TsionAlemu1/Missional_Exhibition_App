import 'package:equatable/equatable.dart';

/// Core domain entity for a mission material
class MaterialEntity extends Equatable {
  final int? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String missionSection;

  const MaterialEntity({
    this.id,
    required this.title,
    required this.description,
    this.price = 0.0,
    this.imageUrl = '',
    required this.missionSection,
  });

  @override
  List<Object?> get props =>
      [id, title, description, price, imageUrl, missionSection];
}
