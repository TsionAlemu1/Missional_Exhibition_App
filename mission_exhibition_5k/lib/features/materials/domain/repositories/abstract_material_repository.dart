import '../entities/material_entity.dart';

/// Abstract contract for the material repository
abstract class AbstractMaterialRepository {
  Future<List<MaterialEntity>> getAllMaterials();
  Future<MaterialEntity> getMaterialById(int id);
  Future<MaterialEntity> createMaterial(MaterialEntity material);
  Future<MaterialEntity> updateMaterial(int id, MaterialEntity material);
  Future<void> deleteMaterial(int id);
}
