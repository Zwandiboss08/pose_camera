import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pose_styling_camera_flutter/domain/pose_entity.dart';
import 'package:pose_styling_camera_flutter/presentation/controller/pose_controller.dart';

class PoseView extends GetView<PoseController> {
  const PoseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Obx(() {
            if (controller.isCameraInitialized.value) {
              return SizedBox.expand(
                child: CameraPreview(controller.cameraController),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),

          Obx(() {
            final pose = controller.currentPose.value;
            if (pose != null) {
              return Center(
                child: Opacity(
                  opacity: 0.5,
                  child: _buildPosePlaceholder(pose),
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomPanel()),
        ],
      ),
    );
  }

  Widget _buildPosePlaceholder(PoseEntity pose) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Image.asset(
        pose.assetPath,
        fit: BoxFit.contain,
        colorBlendMode: BlendMode.screen,
        color: Colors.white.withOpacity(0.7),
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      padding: const EdgeInsets.only(bottom: 30, top: 20),

      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black87],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: controller.takePicture,
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                color: Colors.white.withOpacity(0.2),
              ),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: ['1_person', '2_persons', '3_persons', '4_persons']
                  .map(
                    (cat) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Obx(
                        () => ChoiceChip(
                          label: Text(cat.replaceAll('_', ' ').toUpperCase()),
                          selected: controller.selectedCategory.value == cat,
                          onSelected: (bool selected) {
                            if (selected) controller.changeCategory(cat);
                          },
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            height: 80,
            child: Obx(
              () => ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.poseList.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return GestureDetector(
                      onTap: controller.randomizePose,
                      child: Container(
                        width: 70,
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.shuffle, size: 30),
                      ),
                    );
                  }

                  final pose = controller.poseList[index - 1];
                  return GestureDetector(
                    onTap: () => controller.selectPose(pose),
                    child: Container(
                      width: 70,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(10),
                        border: controller.currentPose.value == pose
                            ? Border.all(color: Colors.amber, width: 2)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          pose.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
