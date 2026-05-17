import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mission_exhibition_5k/features/materials/domain/repositories/abstract_material_repository.dart';
import 'material_event.dart';
import 'material_state.dart';

/// Bloc that manages the state of materials
class MaterialBloc extends Bloc<MaterialEvent, MaterialBlocState> {
  final AbstractMaterialRepository materialRepository;

  MaterialBloc({required this.materialRepository})
      : super(MaterialBlocInitial()) {
    on<FetchMaterials>(_onFetchMaterials);
    on<FetchMaterialById>(_onFetchMaterialById);
    on<CreateMaterial>(_onCreateMaterial);
    on<UpdateMaterial>(_onUpdateMaterial);
    on<DeleteMaterial>(_onDeleteMaterial);
  }

  /// Handles fetching all materials with optional section filter
  Future<void> _onFetchMaterials(
    FetchMaterials event,
    Emitter<MaterialBlocState> emit,
  ) async {
    emit(MaterialBlocLoading());
    try {
      final materials = await materialRepository.getAllMaterials();
      if (event.missionSection != null && event.missionSection!.isNotEmpty) {
        final filtered = materials
            .where((m) =>
                m.missionSection.toLowerCase() ==
                event.missionSection!.toLowerCase())
            .toList();
        emit(MaterialsBlocLoaded(filtered));
      } else {
        emit(MaterialsBlocLoaded(materials));
      }
    } catch (e) {
      emit(MaterialBlocError('Failed to load materials: ${e.toString()}'));
    }
  }

  /// Handles fetching a single material by ID
  Future<void> _onFetchMaterialById(
    FetchMaterialById event,
    Emitter<MaterialBlocState> emit,
  ) async {
    emit(MaterialBlocLoading());
    try {
      final material = await materialRepository.getMaterialById(event.id);
      emit(MaterialDetailBlocLoaded(material));
    } catch (e) {
      emit(MaterialBlocError('Failed to load material: ${e.toString()}'));
    }
  }

  /// Handles creating a new material
  Future<void> _onCreateMaterial(
    CreateMaterial event,
    Emitter<MaterialBlocState> emit,
  ) async {
    emit(MaterialBlocLoading());
    try {
      await materialRepository.createMaterial(event.material);
      emit(const MaterialBlocOperationSuccess('Material created successfully'));
      final materials = await materialRepository.getAllMaterials();
      final filtered = materials
          .where((m) =>
              m.missionSection.toLowerCase() ==
              event.material.missionSection.toLowerCase())
          .toList();
      emit(MaterialsBlocLoaded(filtered));
    } catch (e) {
      emit(MaterialBlocError('Failed to create material: ${e.toString()}'));
    }
  }

  /// Handles updating an existing material
  Future<void> _onUpdateMaterial(
    UpdateMaterial event,
    Emitter<MaterialBlocState> emit,
  ) async {
    emit(MaterialBlocLoading());
    try {
      await materialRepository.updateMaterial(event.id, event.material);
      emit(const MaterialBlocOperationSuccess('Material updated successfully'));
      final materials = await materialRepository.getAllMaterials();
      final filtered = materials
          .where((m) =>
              m.missionSection.toLowerCase() ==
              event.material.missionSection.toLowerCase())
          .toList();
      emit(MaterialsBlocLoaded(filtered));
    } catch (e) {
      emit(MaterialBlocError('Failed to update material: ${e.toString()}'));
    }
  }

  /// Handles deleting a material
  Future<void> _onDeleteMaterial(
    DeleteMaterial event,
    Emitter<MaterialBlocState> emit,
  ) async {
    emit(MaterialBlocLoading());
    try {
      String section = '';
      try {
        final material = await materialRepository.getMaterialById(event.id);
        section = material.missionSection;
      } catch (_) {}

      await materialRepository.deleteMaterial(event.id);
      emit(const MaterialBlocOperationSuccess('Material deleted successfully'));
      
      final materials = await materialRepository.getAllMaterials();
      if (section.isNotEmpty) {
        final filtered = materials
            .where((m) => m.missionSection.toLowerCase() == section.toLowerCase())
            .toList();
        emit(MaterialsBlocLoaded(filtered));
      } else {
        emit(MaterialsBlocLoaded(materials));
      }
    } catch (e) {
      emit(MaterialBlocError('Failed to delete material: ${e.toString()}'));
    }
  }
}
