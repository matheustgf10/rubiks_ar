import 'dart:math';

import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/widgets/ar_view.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class LocalObjectWidget extends StatefulWidget {
  late String cube;

  LocalObjectWidget({required this.cube});

  @override
  _LocalObjectWidgetState createState() => _LocalObjectWidgetState();
}

class _LocalObjectWidgetState extends State<LocalObjectWidget> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARNode? localObjectNode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Local Object (Cube)')),
      body: Container(
        child: GestureDetector(
          onHorizontalDragEnd: (dragEndDetails) {
            var snackBar;

            if (dragEndDetails.velocity.pixelsPerSecond.dx > -1000) {
              _rotateRubiksToRight();

              snackBar = SnackBar(
                content: Text('Arrastando para a Direita'),
                duration: Duration(seconds: 1),
                action: SnackBarAction(
                  label: 'Remover',
                  onPressed: () {
                    // Navigator.pop(context);
                  },
                ),
              );
            } else {
              _rotateRubiksToLeft();
              snackBar = SnackBar(
                content: Text('Arrastando para a Esqueda'),
                duration: Duration(seconds: 1),
                action: SnackBarAction(
                  label: 'Remover',
                  onPressed: () {
                    // Navigator.pop(context);
                  },
                ),
              );
            }

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: Stack(
            children: [
              ARView(
                onARViewCreated: onARViewCreated,
                planeDetectionConfig:
                    PlaneDetectionConfig.horizontalAndVertical,
              ),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: onLocalObjectAtOriginButtonPressed,
                          child: Text("Adicionar/Remover Cubo"),
                        ),
                      ],
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     ElevatedButton(
                    //       onPressed: onLocalObjectShuffleButtonPressed,
                    //       child: Text("Objeto aleatório"),
                    //     ),
                    //   ],
                    // )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;

    this.arSessionManager!.onInitialize(
          showFeaturePoints: false,
          showPlanes: true,
          customPlaneTexturePath: "Images/triangle.png",
          showWorldOrigin: false,
          handleTaps: false,
        );
    this.arObjectManager!.onInitialize();
  }

  Future<void> onLocalObjectAtOriginButtonPressed() async {
    if (this.localObjectNode != null) {
      this.arObjectManager!.removeNode(this.localObjectNode!);
      this.localObjectNode = null;
    } else {
      var newNode = ARNode(
          type: NodeType.localGLTF2,
          uri: (widget.cube == "3x3x3")
              ? "assets/3d/rubiks_cube_3x3x3/scene.gltf"
              : "assets/3d/rubiks_cube_2x2x2/scene.gltf",
          scale: Vector3(0.05, 0.05, 0.05),
          position: Vector3(0.0, 0.0, 0.0),
          rotation: Vector4(1.0, 0.0, 0.0, 0.0));
      bool? didAddLocalNode = await this.arObjectManager?.addNode(newNode);
      this.localObjectNode = (didAddLocalNode!) ? newNode : null;
    }
  }

  Future<void> _rotateRubiksToLeft() async {
    if (this.localObjectNode != null) {
      var newScale = Vector3(0.05, 0.05, 0.05);
      var newTranslationAxis = Random().nextInt(3);
      var newTranslationAmount = Random().nextDouble() / 3;
      var newTranslation = Vector3(1, 0, 0);
      newTranslation[newTranslationAxis] = newTranslationAmount;
      var newRotationAxisIndex = Random().nextInt(3);
      var newRotationAmount = Random().nextDouble();
      var newRotationAxis = Vector3(1, 0, 0);

      newRotationAxis[newRotationAxisIndex] = 1.0;

      final newTransform = Matrix4.identity();

      newTransform.setTranslation(newTranslation);
      newTransform.rotate(newRotationAxis, newRotationAmount);
      newTransform.scale(newScale);

      this.localObjectNode!.transform = newTransform;
    }
  }

  Future<void> _rotateRubiksToRight() async {
    if (this.localObjectNode != null) {
      var newScale = Vector3(0.05, 0.05, 0.05);
      var newTranslationAxis = Random().nextInt(3);
      var newTranslationAmount = Random().nextDouble() / 3;
      var newTranslation = Vector3(0, 1, 0);
      newTranslation[newTranslationAxis] = newTranslationAmount;
      var newRotationAxisIndex = Random().nextInt(3);
      var newRotationAmount = Random().nextDouble();
      var newRotationAxis = Vector3(0, 0, 0);

      newRotationAxis[newRotationAxisIndex] = 1.0;
      this.localObjectNode!.transform.rotateY(10);

      final newTransform = Matrix4.identity();

      newTransform.setTranslation(newTranslation);
      newTransform.rotate(newRotationAxis, newRotationAmount);
      newTransform.scale(newScale);

      this.localObjectNode!.transform = newTransform;
    }
  }
}
