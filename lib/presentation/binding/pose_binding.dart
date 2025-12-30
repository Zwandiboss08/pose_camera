import 'package:get/get.dart';
import 'package:pose_styling_camera_flutter/presentation/controller/pose_controller.dart';
import '../../data/pose_repository_impl.dart';
import '../../domain/pose_repository.dart';

class PoseBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Inject the Repository (Data Layer implementation)
    // We bind the Interface (PoseRepository) to the Implementation (PoseRepositoryImpl)
    Get.lazyPut<PoseRepository>(() => PoseRepositoryImpl());

    // 2. Inject the Controller (Presentation Layer)
    // The controller will automatically find the repository we just injected
    Get.put(PoseController(repository: Get.find()));
  }
}
