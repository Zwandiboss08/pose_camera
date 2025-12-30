import '../domain/pose_entity.dart';
import '../domain/pose_repository.dart';

class PoseRepositoryImpl implements PoseRepository {
  final List<PoseEntity> _allPoses = [
    // --- 1 Person ---
    const PoseEntity(
      id: '1',
      category: '1_person',
      title: 'Casual Lean',
      assetPath: 'assets/images/1person_lean.jpg',
    ),
    const PoseEntity(
      id: '2',
      category: '1_person',
      title: 'Sitting Down',
      assetPath: 'assets/images/1person_sitdown.jpg',
    ),
    const PoseEntity(
      id: '3',
      category: '1_person',
      title: 'Walking Away',
      assetPath: 'assets/images/1person_walkingaway.jpg',
    ),

    // --- 2 Persons ---
    const PoseEntity(
      id: '4',
      category: '2_persons',
      title: 'Back to Back',
      assetPath: 'assets/images/2person_backtoback.jpg',
    ),
    const PoseEntity(
      id: '5',
      category: '2_persons',
      title: 'Heart Hand',
      assetPath: 'assets/images/2person_hearthand.jpg',
    ),
    const PoseEntity(
      id: '6',
      category: '2_persons',
      title: 'Holding Hands',
      assetPath: 'assets/images/2person_holdinghands.jpg',
    ),

    // --- 3 Persons ---
    const PoseEntity(
      id: '7',
      category: '3_persons',
      title: 'Star Pose',
      assetPath: 'assets/images/3person_starpose.jpg',
    ),
    const PoseEntity(
      id: '8',
      category: '3_persons',
      title: 'The Triangle',
      assetPath: 'assets/images/3person_triangle.jpg',
    ),

    // --- 4 Persons ---
    const PoseEntity(
      id: '9',
      category: '4_persons',
      title: 'Abbey Road',
      assetPath: 'assets/images/4person_abbeyroad.jpg',
    ),
    const PoseEntity(
      id: '10',
      category: '4_persons',
      title: 'V Shape',
      assetPath: 'assets/images/4person_vshape.jpg',
    ),
  ];

  @override
  Future<List<PoseEntity>> getPosesByCategory(String category) async {
    // Small delay to simulate loading if needed
    await Future.delayed(const Duration(milliseconds: 50));
    return _allPoses.where((p) => p.category == category).toList();
  }

  @override
  Future<PoseEntity> getRandomPose(String category, {String? excludeId}) async {
    final list = _allPoses.where((p) => p.category == category).toList();

    if (list.isEmpty) throw Exception('No poses found for category: $category');

    if (list.length > 1 && excludeId != null) {
      list.removeWhere((p) => p.id == excludeId);
    }

    return (list..shuffle()).first;
  }
}
