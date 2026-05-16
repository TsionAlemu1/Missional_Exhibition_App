import 'package:dio/dio.dart';
import 'package:mission_exhibition_5k/core/constants/app_constants.dart';
import 'package:mission_exhibition_5k/features/materials/domain/entities/material_entity.dart';
import 'package:mission_exhibition_5k/features/materials/domain/repositories/abstract_material_repository.dart';
import 'package:mission_exhibition_5k/features/materials/data/models/material_model.dart';

/// Implementation of the material repository using Dio for HTTP calls
class MaterialRepository implements AbstractMaterialRepository {
  final Dio dio;

  MaterialRepository({required this.dio});

  @override
  Future<List<MaterialEntity>> getAllMaterials() async {
    final response = await dio.get(AppConstants.productsEndpoint);
    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((json) => MaterialModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<MaterialEntity> getMaterialById(int id) async {
    final response = await dio.get('${AppConstants.productsEndpoint}/$id');
    return MaterialModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<MaterialEntity> createMaterial(MaterialEntity material) async {
    final model = MaterialModel(
      title: material.title,
      description: material.description,
      price: material.price,
      imageUrl: material.imageUrl,
      missionSection: material.missionSection,
    );
    final response = await dio.post(
      AppConstants.productsEndpoint,
      data: model.toJson(),
    );
    return MaterialModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<MaterialEntity> updateMaterial(int id, MaterialEntity material) async {
    final model = MaterialModel(
      title: material.title,
      description: material.description,
      price: material.price,
      imageUrl: material.imageUrl,
      missionSection: material.missionSection,
    );
    final response = await dio.put(
      '${AppConstants.productsEndpoint}/$id',
      data: model.toJson(),
    );
    return MaterialModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteMaterial(int id) async {
    await dio.delete('${AppConstants.productsEndpoint}/$id');
  }
}
