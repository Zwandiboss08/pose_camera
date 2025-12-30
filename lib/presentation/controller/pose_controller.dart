import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pose_styling_camera_flutter/domain/pose_entity.dart';
import 'package:pose_styling_camera_flutter/domain/pose_repository.dart';

class PoseController extends GetxController {
  final PoseRepository repository;
  PoseController({required this.repository});

  // State Variables
  var isCameraInitialized = false.obs;
  late CameraController cameraController;

  var selectedCategory = '1_person'.obs;
  var poseList = <PoseEntity>[].obs;
  var currentPose = Rxn<PoseEntity>(); // Nullable: null means no overlay

  // To prevent rapid random repeats
  String? _lastRandomId;

  @override
  void onInit() {
    super.onInit();
    initializeCamera();
    loadPoses('1_person');
  }

  Future<void> initializeCamera() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        cameraController = CameraController(
          cameras.first, // usually back camera
          ResolutionPreset.high,
          enableAudio: false,
        );
        await cameraController.initialize();
        isCameraInitialized.value = true;
      }
    } else {
      Get.snackbar("Error", "Camera permission needed");
    }
  }

  // ... existing code ...

  Future<void> takePicture() async {
    if (!cameraController.value.isInitialized) {
      return;
    }

    if (cameraController.value.isTakingPicture) {
      return; // Already taking a picture, ignore click
    }

    try {
      // 1. Capture the image
      final XFile file = await cameraController.takePicture();

      // 2. Show feedback (For now, we just show where it saved)
      // In a real app, you would use the 'gal' or 'gallery_saver' package here to save to Gallery.
      Get.snackbar(
        "Click!",
        "Picture saved to: ${file.path}",
        backgroundColor: Colors.white,
        colorText: Colors.black,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20),
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to take picture: $e");
    }
  }

  // ... existing code ...

  void changeCategory(String category) {
    selectedCategory.value = category;
    currentPose.value = null; // Clear overlay on category switch
    loadPoses(category);
  }

  Future<void> loadPoses(String category) async {
    var poses = await repository.getPosesByCategory(category);
    poseList.assignAll(poses);
  }

  void selectPose(PoseEntity pose) {
    currentPose.value = pose;
    _lastRandomId = pose.id;
  }

  Future<void> randomizePose() async {
    var pose = await repository.getRandomPose(
      selectedCategory.value,
      excludeId: _lastRandomId,
    );
    selectPose(pose);
  }

  @override
  void onClose() {
    if (isCameraInitialized.value) {
      cameraController.dispose();
    }
    super.onClose();
  }
}
