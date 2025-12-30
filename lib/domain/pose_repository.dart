import 'pose_entity.dart';

abstract class PoseRepository {
  Future<List<PoseEntity>> getPosesByCategory(String category);
  Future<PoseEntity> getRandomPose(String category, {String? excludeId});
}
