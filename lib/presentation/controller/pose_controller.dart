import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pose_styling_camera_flutter/domain/pose_entity.dart';
import 'package:pose_styling_camera_flutter/domain/pose_repository.dart';
import 'package:gal/gal.dart';
import 'dart:io';

class PoseController extends GetxController {
  final PoseRepository repository;
  PoseController({required this.repository});
  var lastCapturedPath = RxnString();
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

  // Future<void> takePicture() async {
  //   if (!cameraController.value.isInitialized) {
  //     return;
  //   }

  //   if (cameraController.value.isTakingPicture) {
  //     return; // Already taking a picture, ignore click
  //   }

  //   try {
  //     // 1. Capture the image
  //     final XFile file = await cameraController.takePicture();

  //     // 2. Show feedback (For now, we just show where it saved)
  //     // In a real app, you would use the 'gal' or 'gallery_saver' package here to save to Gallery.
  //     Get.snackbar(
  //       "Click!",
  //       "Picture saved to: ${file.path}",
  //       backgroundColor: Colors.white,
  //       colorText: Colors.black,
  //       snackPosition: SnackPosition.TOP,
  //       margin: const EdgeInsets.all(20),
  //     );
  //   } catch (e) {
  //     Get.snackbar("Error", "Failed to take picture: $e");
  //   }
  // }
  Future<void> takePicture() async {
    if (!cameraController.value.isInitialized ||
        cameraController.value.isTakingPicture) {
      return;
    }

    try {
      // 1. Capture the image (saved to temp cache)
      final XFile file = await cameraController.takePicture();

      // 2. Request Permission & Save to Gallery
      // 'Gal' automatically handles the correct permissions for Android & iOS
      await Gal.putImage(file.path);
      lastCapturedPath.value = file.path;
      // 3. Show success message
      Get.snackbar(
        "Saved!",
        "Picture saved to your Gallery",
        backgroundColor: Colors.black,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      // Check if it was a permission error
      if (e is GalException && e.type == GalExceptionType.accessDenied) {
        Get.snackbar(
          "Error",
          "Permission denied. Please allow access to photos.",
        );
      } else {
        Get.snackbar("Error", "Failed to save picture: $e");
      }
    }
  }

  Future<void> openGallery() async {
    // Check if we have a photo path
    if (lastCapturedPath.value != null) {
      // Open that specific file safely
      final result = await OpenFilex.open(lastCapturedPath.value!);

      if (result.type != ResultType.done) {
        Get.snackbar("Error", "Could not open file: ${result.message}");
      }
    } else {
      // If no photo taken yet, try to open the generic gallery app
      // (This uses the 'gal' package as a fallback for the main gallery)
      try {
        await Gal.open();
      } catch (e) {
        Get.snackbar("Gallery", "Please open your Gallery app manually.");
      }
    }
  }

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
