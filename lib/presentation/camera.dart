import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hh_mcon_vg/presentation/edit_image.dart';
import 'package:hh_mcon_vg/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  int toggleCam = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    CameraDescription description =
        await availableCameras().then((cameras) => cameras[toggleCam]);
    _controller = CameraController(
      description,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _controller?.initialize();
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Container(
              height: 70,
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
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
                  )
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (controller == null) {
                    return Container();
                  }
                  final width = constraints.maxWidth;
                  final height = constraints.maxHeight;
                  return Center(
                    child: AspectRatio(
                      aspectRatio: width / height,
                      child: CameraPreview(controller),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 20),
                  FloatingActionButton(
                    onPressed: takePicture,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.white,
                        width: 3,
                        strokeAlign: 2,
                      ),
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          getImageFromGallery();
                        },
                        child: SvgPicture.asset(
                          "assets/images/gallery.svg",
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () async {
                          setState(() {
                            toggleCam = toggleCam == 0 ? 1 : 0;
                          });
                          CameraDescription description =
                              await availableCameras().then((camera) {
                            return camera[toggleCam];
                          });
                          _controller?.setDescription(description);
                        },
                        child: SvgPicture.asset(
                          "assets/images/reload.svg",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditImage(image: image),
      ),
    );
  }

  void checkForPerm() async {
    try {
      PermissionStatus status = await Permission.camera.status;
      if (status.isDenied) {
        await Permission.camera.request();
        status = await Permission.camera.status;
        if (status.isGranted) {
          _initializeCamera();
        }
        return;
      }
    } catch (e) {
      print("e");
      print(e);
    }
  }

  void takePicture() async {
    checkForPerm();
    if (_controller?.hasListeners != true) return;
    final res = await _controller?.takePicture();
    if (res == null) return;
    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditImage(image: res),
      ),
    );
  }
}
