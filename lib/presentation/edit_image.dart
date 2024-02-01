import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:hh_mcon_vg/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class EditImage extends StatefulWidget {
  final XFile? image;

  const EditImage({super.key, this.image});

  @override
  State<EditImage> createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {
  final WidgetsToImageController imgController = WidgetsToImageController();
  bool eye1Activated = false;
  bool eye2Activated = false;
  bool mouth1Activated = false;
  late final size = MediaQuery.of(context).size;
  late XFile? image = widget.image;
  bool isLoading = false;
  Offset eye1Position = const Offset(150, 150);
  Offset eye2Position = const Offset(220, 150);
  Offset mouthPosition = const Offset(185, 250);
  bool multiFaces = false;
  final GlobalKey globalKey = GlobalKey();
  final mlFaceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true,
      enableContours: true,
      performanceMode: FaceDetectorMode.accurate,
      enableLandmarks: true,
    ),
  );

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      checkForMultiFaces();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final topHeight = MediaQuery.of(context).viewPadding.top + 70;
    final bottomHeight = MediaQuery.of(context).viewPadding.bottom + 250;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              notDiscussedString,
                            ),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: WidgetsToImage(
                controller: imgController,
                key: globalKey,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      child: Image.file(
                        File(image!.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Visibility(
                      visible: eye1Activated,
                      child: Positioned(
                        left: eye1Position.dx,
                        top: eye1Position.dy - topHeight,
                        child: Draggable(
                          feedback: Row(
                            children: [
                              ClipOval(
                                child: Container(
                                  width: 45,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: kGreenBackground,
                                  ),
                                  child: const Center(
                                    child: SizedBox(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          childWhenDragging: const SizedBox(),
                          onDraggableCanceled:
                              (Velocity velocity, Offset offset) {
                            if (topHeight > offset.dy ||
                                (size.height - bottomHeight) < offset.dy) {
                              return;
                            }
                            setState(() => eye1Position = offset);
                          },
                          child: Row(
                            children: [
                              ClipOval(
                                child: Container(
                                  width: 45,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: kGreenBackground,
                                  ),
                                  child: const Center(
                                    child: SizedBox(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: eye2Activated,
                      child: Positioned(
                        left: eye2Position.dx,
                        top: eye2Position.dy - topHeight,
                        child: Draggable(
                          feedback: Row(
                            children: [
                              ClipOval(
                                child: Container(
                                  width: 45,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: kGreenBackground,
                                  ),
                                  child: const Center(
                                    child: SizedBox(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          childWhenDragging: const SizedBox(),
                          onDraggableCanceled:
                              (Velocity velocity, Offset offset) {
                            if (topHeight > offset.dy ||
                                (size.height - bottomHeight) < offset.dy) {
                              return;
                            }
                            setState(() => eye2Position = offset);
                          },
                          child: Row(
                            children: [
                              ClipOval(
                                child: Container(
                                  width: 45,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: kGreenBackground,
                                  ),
                                  child: const Center(
                                    child: SizedBox(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: mouth1Activated,
                      child: Positioned(
                        left: mouthPosition.dx,
                        top: mouthPosition.dy - topHeight,
                        child: Draggable(
                          feedback: Row(
                            children: [
                              ClipOval(
                                child: Container(
                                  width: 66,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: kGreenBackground,
                                  ),
                                  child: const Center(
                                    child: SizedBox(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          childWhenDragging: const SizedBox(),
                          onDraggableCanceled:
                              (Velocity velocity, Offset offset) {
                            if (topHeight > offset.dy ||
                                (size.height - bottomHeight) < offset.dy) {
                              return;
                            }
                            setState(() => mouthPosition = offset);
                          },
                          child: Row(
                            children: [
                              ClipOval(
                                child: Container(
                                  width: 66,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: kGreenBackground,
                                  ),
                                  child: const Center(
                                    child: SizedBox(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: multiFaces,
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 20),
                        width: 240,
                        height: 69,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.black.withOpacity(0.4),
                        ),
                        child: const Center(
                          child: Text(
                            multipleFaceString,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  InkWell(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/back_icon.png",
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "다시찍기",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      image = null;
                      eye1Activated = false;
                      mouth1Activated = false;
                    },
                  ),
                  Expanded(
                    child: Visibility(
                      visible: !multiFaces,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (!eye1Activated) {
                                    setState(() {
                                      eye1Activated = true;
                                    });
                                    return;
                                  }
                                  if (!eye2Activated) {
                                    setState(() {
                                      eye2Activated = true;
                                    });
                                    return;
                                  }
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        noMoreCanBeAddedString,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                      child: Text(
                                    "눈",
                                    style: TextStyle(fontSize: 18),
                                  )),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  if (!mouth1Activated) {
                                    setState(() {
                                      mouth1Activated = true;
                                    });
                                    return;
                                  }
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        noMoreCanBeAddedString,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                      child: Text(
                                    "입",
                                    style: TextStyle(fontSize: 18),
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !multiFaces,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            mouth1Activated && eye1Activated
                                ? activeButtonBg
                                : inactiveButtonBg,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide.none,
                          )),
                        ),
                        onPressed: () async {
                          try {
                            if (mouth1Activated && eye1Activated) {
                              setState(() => isLoading = true);
                              try {
                                await savePictureToFile(imgController);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        imageSavedString,
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                log(e.toString());
                              }
                              setState(() => isLoading = false);
                            }
                          } catch (e, src) {
                            log(src.toString());
                            throw Exception(e);
                          }
                        },
                        child: Visibility(
                          visible: !isLoading,
                          replacement: const SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          child: const Text(
                            '저장하기',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkForMultiFaces() async {
    if (image?.path == null) return;
    final faces = await mlFaceDetector.processImage(
      InputImage.fromFilePath(
        image!.path,
      ),
    );
    if (faces.length > 1) {
      setState(() => multiFaces = true);
    }
  }

  Future<File?> savePictureToFile(
    WidgetsToImageController imageController,
  ) async {
    final bytes = await imageController.capture();
    if (bytes != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await File(
              '${directory.path}/mimicon_${math.Random().nextDouble()}.png')
          .create();
      await imagePath.writeAsBytes(bytes);
      Gal.putImage(imagePath.path);
      return imagePath;
    }
    return null;
  }
}
