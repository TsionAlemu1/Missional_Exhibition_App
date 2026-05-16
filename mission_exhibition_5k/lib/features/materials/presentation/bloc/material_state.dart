import 'package:equatable/equatable.dart';
import 'package:mission_exhibition_5k/features/materials/domain/entities/material_entity.dart';

/// Base state class for material-related states
abstract class MaterialBlocState extends Equatable {
  const MaterialBlocState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any action
class MaterialBlocInitial extends MaterialBlocState {}

/// Loading state for any ongoing operation
class MaterialBlocLoading extends MaterialBlocState {}

/// State when a list of materials is loaded
class MaterialsBlocLoaded extends MaterialBlocState {
  final List<MaterialEntity> materials;

  const MaterialsBlocLoaded(this.materials);

  @override
  List<Object?> get props => [materials];
}

/// State when a single material detail is loaded
class MaterialDetailBlocLoaded extends MaterialBlocState {
  final MaterialEntity material;

  const MaterialDetailBlocLoaded(this.material);

  @override
  List<Object?> get props => [material];
}

/// State after a successful create/update/delete operation
class MaterialBlocOperationSuccess extends MaterialBlocState {
  final String message;

  const MaterialBlocOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// Error state with an error message
class MaterialBlocError extends MaterialBlocState {
  final String message;

  const MaterialBlocError(this.message);

  @override
  List<Object?> get props => [message];
}
