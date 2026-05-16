import 'package:equatable/equatable.dart';
import 'package:mission_exhibition_5k/features/materials/domain/entities/material_entity.dart';

/// Base event class for material-related events
abstract class MaterialEvent extends Equatable {
  const MaterialEvent();

  @override
  List<Object?> get props => [];
}

/// Fetches all materials, optionally filtered by mission section
class FetchMaterials extends MaterialEvent {
  final String? missionSection;

  const FetchMaterials({this.missionSection});

  @override
  List<Object?> get props => [missionSection];
}

/// Fetches a single material by its ID
class FetchMaterialById extends MaterialEvent {
  final int id;

  const FetchMaterialById(this.id);

  @override
  List<Object?> get props => [id];
}

/// Creates a new material
class CreateMaterial extends MaterialEvent {
  final MaterialEntity material;

  const CreateMaterial(this.material);

  @override
  List<Object?> get props => [material];
}

/// Updates an existing material
class UpdateMaterial extends MaterialEvent {
  final int id;
  final MaterialEntity material;

  const UpdateMaterial(this.id, this.material);

  @override
  List<Object?> get props => [id, material];
}

/// Deletes a material by its ID
class DeleteMaterial extends MaterialEvent {
  final int id;

  const DeleteMaterial(this.id);

  @override
  List<Object?> get props => [id];
}
