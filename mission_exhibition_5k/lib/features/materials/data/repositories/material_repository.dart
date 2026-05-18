import 'package:dio/dio.dart';
import 'package:mission_exhibition_5k/core/constants/app_constants.dart';
import 'package:mission_exhibition_5k/features/materials/domain/entities/material_entity.dart';
import 'package:mission_exhibition_5k/features/materials/domain/repositories/abstract_material_repository.dart';
import 'package:mission_exhibition_5k/features/materials/data/models/material_model.dart';

/// Implementation of the material repository using Dio for HTTP calls
class MaterialRepository implements AbstractMaterialRepository {
  final Dio dio;
  List<MaterialEntity>? _cachedMaterials;

  MaterialRepository({required this.dio});

  @override
  Future<List<MaterialEntity>> getAllMaterials() async {
    if (_cachedMaterials != null) {
      return _cachedMaterials!;
    }
    final response = await dio.get(AppConstants.productsEndpoint);
    final List<dynamic> data = response.data as List<dynamic>;
    _cachedMaterials = data
        .map<MaterialEntity>((json) => MaterialModel.fromJson(json as Map<String, dynamic>))
        .toList();
    return _cachedMaterials!;
  }

  @override
  Future<MaterialEntity> getMaterialById(int id) async {
    if (_cachedMaterials != null) {
      final index = _cachedMaterials!.indexWhere((m) => m.id == id);
      if (index != -1) {
        return _cachedMaterials![index];
      }
    }
    final response = await dio.get('${AppConstants.productsEndpoint}/$id');
    return MaterialModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<MaterialEntity> createMaterial(MaterialEntity material) async {
    await getAllMaterials();
    _cachedMaterials = List<MaterialEntity>.of(_cachedMaterials!);
    
    // Find next available ID
    final nextId = _cachedMaterials!.isEmpty 
        ? 1 
        : _cachedMaterials!.map((m) => m.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
        
    final newMaterial = MaterialEntity(
      id: nextId,
      title: material.title,
      description: material.description,
      price: material.price,
      imageUrl: material.imageUrl,
      missionSection: material.missionSection,
    );

    try {
      final model = MaterialModel(
        title: material.title,
        description: material.description,
        price: material.price,
        imageUrl: material.imageUrl,
        missionSection: material.missionSection,
      );
      await dio.post(
        AppConstants.productsEndpoint,
        data: model.toJson(),
      );
    } catch (_) {
      // Ignore network errors to support offline testing
    }
    
    _cachedMaterials!.add(newMaterial);
    return newMaterial;
  }

  @override
  Future<MaterialEntity> updateMaterial(int id, MaterialEntity material) async {
    await getAllMaterials();
    _cachedMaterials = List<MaterialEntity>.of(_cachedMaterials!);
    final index = _cachedMaterials!.indexWhere((m) => m.id == id);
    
    final updatedMaterial = MaterialEntity(
      id: id,
      title: material.title,
      description: material.description,
      price: material.price,
      imageUrl: material.imageUrl,
      missionSection: material.missionSection,
    );

    try {
      final model = MaterialModel(
        title: material.title,
        description: material.description,
        price: material.price,
        imageUrl: material.imageUrl,
        missionSection: material.missionSection,
      );
      await dio.put(
        '${AppConstants.productsEndpoint}/$id',
        data: model.toJson(),
      );
    } catch (_) {
      // Ignore network errors
    }

    if (index != -1) {
      _cachedMaterials![index] = updatedMaterial;
    } else {
      _cachedMaterials!.add(updatedMaterial);
    }
    return updatedMaterial;
  }

  @override
  Future<void> deleteMaterial(int id) async {
    await getAllMaterials();
    _cachedMaterials = List<MaterialEntity>.of(_cachedMaterials!);
    try {
      await dio.delete('${AppConstants.productsEndpoint}/$id');
    } catch (_) {
      // Ignore network errors
    }
    _cachedMaterials!.removeWhere((m) => m.id == id);
  }
}
