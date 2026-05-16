import '../../domain/entities/material_entity.dart';

/// Data layer model that handles JSON serialization
/// Extends the domain entity for clean architecture separation
class MaterialModel extends MaterialEntity {
  const MaterialModel({
    super.id,
    required super.title,
    required super.description,
    super.price,
    super.imageUrl,
    required super.missionSection,
  });

  /// Maps API category values to our mission sections
  static const Map<String, String> _categoryToMission = {
    'electronics': 'Mission in Old Testament',
    'jewelery': 'Mission in New Testament',
    "men's clothing": 'Mission History',
    "women's clothing": 'Ethiopian Missionaries',
  };

  /// Creates a MaterialModel from a JSON map
  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['id'] as int?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image'] as String? ?? '',
      missionSection: _resolveMissionSection(json['category'] as String? ?? ''),
    );
  }

  /// Converts API category to mission section.
  /// If already a mission section name (from our app), returns as-is.
  static String _resolveMissionSection(String category) {
    final lower = category.toLowerCase();
    if (_categoryToMission.containsKey(lower)) {
      return _categoryToMission[lower]!;
    }
    return category;
  }

  /// Converts this model to a JSON map for API requests
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'price': price,
      'description': description,
      'image': imageUrl,
      'category': missionSection,
    };
  }
}
