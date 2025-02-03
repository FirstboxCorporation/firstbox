// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, unused_local_variable

import 'dart:convert';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:file_selector/file_selector.dart';

void main() {
  runApp(const MyApp());
}

void launchSMS(String phoneNumber, String message, BuildContext context) async {
  try {
    final url = 'sms:$phoneNumber?body=$message';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  } catch (e) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            icon: const Icon(
              Icons.error,
              color: Colors.red,
            ),
            title: const Text("Error"),
            content: Text("Something Happened:\n$e"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"))
            ],
          );
        });
  }
}

void launchCall(String phoneNumber, BuildContext context) async {
  try {
    final url = 'tel:$phoneNumber';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  } catch (e) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            icon: const Icon(
              Icons.error,
              color: Colors.red,
            ),
            title: const Text("Error"),
            content: Text("Something Happened:\n$e"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"))
            ],
          );
        });
  }
}

void launchMaps(String destaddress, BuildContext context) async {
  try {
    final Uri googleMapsUrl = Uri.parse(
        "https://www.google.com/maps/dir/?api=1&origin=Current+Location&destination=${Uri.encodeComponent(destaddress)}");
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  } catch (e) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            icon: const Icon(
              Icons.error,
              color: Colors.red,
            ),
            title: const Text("Error"),
            content: Text("Something Happened:\n$e"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"))
            ],
          );
        });
  }
}

Future<void> requistPermissions() async {
  if (await Permission.camera.isPermanentlyDenied ||
      await Permission.camera.isDenied) {
    var camera = await Permission.camera.request();
  }
  if (await Permission.microphone.isPermanentlyDenied ||
      await Permission.microphone.isDenied) {
    var microphone = await Permission.microphone.request();
  }
  if (await Permission.location.isPermanentlyDenied ||
      await Permission.location.isDenied) {
    var location = await Permission.location.request();
  }
  if (await Permission.locationAlways.isPermanentlyDenied ||
      await Permission.locationAlways.isDenied) {
    var locationAlways = await Permission.locationAlways.request();
  }
  var videos = await Permission.videos.request();
  if (await Permission.photos.isPermanentlyDenied ||
      await Permission.photos.isDenied) {
    var photos = await Permission.photos.request();
  }
  if (await Permission.phone.isPermanentlyDenied ||
      await Permission.phone.isDenied) {
    var phone = await Permission.phone.request();
  }
  if (await Permission.contacts.isPermanentlyDenied ||
      await Permission.contacts.isDenied) {
    var contacts = await Permission.contacts.request();
  }
  if (await Permission.sms.isPermanentlyDenied ||
      await Permission.sms.isDenied) {
    var messages = await Permission.sms.request();
  }
  if (await Permission.storage.isPermanentlyDenied ||
      await Permission.storage.isDenied) {
    var storage = await Permission.storage.request();
  }
}

Future<String> convertImageTo64Base(Uint8List image) async {
  String licensePictureBase64 = base64Encode(image);
  return licensePictureBase64;
}

Widget displayImageFrom64BaseString(String img) {
  Uint8List imgList = base64Decode(img);
  return SizedBox(width: 20, height: 20, child: Image.memory(imgList));
}

////////////////////
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: HomePage());
  }
}

////////////////////
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    requistPermissions();
  }

  bool isAddedimgFront = false;
  String imgFront = "";
  String imgNameFront = "Not Found";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        child: ListView(
          shrinkWrap: true,
          children: [
            const Card(
              child: Text("Open Maps"),
            ),
            MaterialButton(
              onPressed: () {
                launchMaps(
                    "Canada, Ontario, M9C1W3, Toronto, Eva Rd, 15", context);
              },
              child: const Icon(Icons.map),
            ),
            const Divider(),
            const Card(
              child: Text("Open Calls"),
            ),
            MaterialButton(
              onPressed: () {
                launchCall("+967771550374", context);
              },
              child: const Icon(Icons.phone),
            ),
            const Divider(),
            const Card(
              child: Text("Open SMS"),
            ),
            MaterialButton(
              onPressed: () {
                launchSMS("+967771550374", "Hi Najm", context);
              },
              child: const Icon(Icons.sms),
            ),
            const Divider(),
            const Card(
              child: Text("Add Personal Segnature"),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TakeSignaturePage()));
              },
              child: const Icon(Icons.person),
            ),
            const Divider(),
            const Card(
              child: Text("Scan QR Code"),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ShowScanBarcodeArrive()));
              },
              child: const Icon(Icons.qr_code),
            ),
            const Divider(),
            const Card(
              child: Text("Take Picture"),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TakeHomePicturePage()));
              },
              child: const Icon(Icons.camera),
            ),
            const Divider(),
            Container(
              margin: const EdgeInsets.all(5.0),
              width: 400,
              decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              child: Card(
                  child: ListTile(
                title: const Text("License: "),
                subtitle: Text(
                  imgNameFront,
                  overflow: TextOverflow.clip,
                ),
                trailing: imgNameFront == "Not Found"
                    ? TextButton(
                        onPressed: () async {
                          try {
                            const XTypeGroup picker = XTypeGroup(
                                label: 'images',
                                extensions: [
                                  'jpg',
                                  'jpeg',
                                  'png',
                                  'bmp',
                                  'pdf'
                                ]);
                            final XFile? pickedFile =
                                await openFile(acceptedTypeGroups: [picker]);
                            if (pickedFile != null) {
                              imgNameFront = pickedFile.name;
                              Uint8List imgFile =
                                  await pickedFile.readAsBytes();
                              imgFront = await convertImageTo64Base(imgFile);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Save Picture?"),
                                      content: Container(
                                        margin: const EdgeInsets.all(10),
                                        child: Image.memory(base64Decode(
                                            imgFront)), // عرض الصورة
                                      ),
                                      actions: [
                                        MaterialButton(
                                          onPressed: () {
                                            isAddedimgFront = true;
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Row(
                                                children: [
                                                  Text(
                                                      "Import File Successful"),
                                                  Icon(
                                                    Icons.done,
                                                    color: Colors.green,
                                                  ),
                                                ],
                                              ),
                                            ));
                                            Navigator.of(context).pop();
                                            setState(() {});
                                          },
                                          child: const Text("Yes"),
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Row(
                                                children: [
                                                  Text("Import Filed"),
                                                  Icon(
                                                    Icons.cancel_outlined,
                                                    color: Colors.red,
                                                  )
                                                ],
                                              ),
                                            ));
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("No"),
                                        )
                                      ],
                                    );
                                  });

                              setState(() {});
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Row(
                                  children: [
                                    Text("Import Filed"),
                                    Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.red,
                                    )
                                  ],
                                ),
                              ));
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Row(
                                children: [
                                  Text("Import Filed\n${e.toString()}"),
                                  const Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.red,
                                  )
                                ],
                              ),
                            ));
                          }
                        },
                        child: const Text("Add"))
                    : TextButton(
                        onPressed: () async {
                          try {
                            const XTypeGroup picker = XTypeGroup(
                                label: 'images',
                                extensions: [
                                  'jpg',
                                  'jpeg',
                                  'png',
                                  'bmp',
                                  'pdf'
                                ]);
                            final XFile? pickedFile =
                                await openFile(acceptedTypeGroups: [picker]);
                            if (pickedFile != null) {
                              imgNameFront = pickedFile.name;
                              Uint8List imgFile =
                                  await pickedFile.readAsBytes();
                              imgFront = await convertImageTo64Base(imgFile);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Save Picture?"),
                                      content: Container(
                                        margin: const EdgeInsets.all(10),
                                        child: Image.memory(base64Decode(
                                            imgFront)), // عرض الصورة
                                      ),
                                      actions: [
                                        MaterialButton(
                                          onPressed: () {
                                            isAddedimgFront = true;
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Row(
                                                children: [
                                                  Text(
                                                      "Import File Successful"),
                                                  Icon(
                                                    Icons.done,
                                                    color: Colors.green,
                                                  ),
                                                ],
                                              ),
                                            ));
                                            Navigator.of(context).pop();
                                            setState(() {});
                                          },
                                          child: const Text("Yes"),
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Row(
                                                children: [
                                                  Text("Import Filed"),
                                                  Icon(
                                                    Icons.cancel_outlined,
                                                    color: Colors.red,
                                                  )
                                                ],
                                              ),
                                            ));
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("No"),
                                        )
                                      ],
                                    );
                                  });

                              setState(() {});
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Row(
                                  children: [
                                    Text("Import Filed"),
                                    Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.red,
                                    )
                                  ],
                                ),
                              ));
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Row(
                                children: [
                                  Text("Import Filed:\n${e.toString()}"),
                                  const Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.red,
                                  )
                                ],
                              ),
                            ));
                          }
                        },
                        child: const Text("Edit")),
              )),
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////
class TakeHomePicturePage extends StatefulWidget {
  const TakeHomePicturePage({super.key});

  @override
  TakeHomePicturePageState createState() => TakeHomePicturePageState();
}

class TakeHomePicturePageState extends State<TakeHomePicturePage> {
  late CameraController _controller;
  List<CameraDescription>? cameras;
  @override
  void initState() async {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    _controller = CameraController(
      cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back),
      ResolutionPreset.high,
    );

    await _controller.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text("House Picture")),
      body: Stack(
        children: [
          Container(
              margin: const EdgeInsets.all(8),
              height: double.infinity,
              child: CameraPreview(_controller)),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    final image = await _controller.takePicture();
                    Uint8List bytes = await image.readAsBytes();
                    String base64Image = base64Encode(bytes);
                    // Handle the captured image
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Save Picture?"),
                            content: Container(
                              margin: const EdgeInsets.all(10),
                              child: Image.memory(
                                  base64Decode(base64Image)), // عرض الصورة
                            ),
                            actions: [
                              MaterialButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Picture saved"),
                                  ));
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Yes"),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("No"),
                              )
                            ],
                          );
                        });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Error: $e"),
                    ));
                  }
                },
                child: const Text("Capture"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/////////////////////////////////////////////////
class TakeSignaturePage extends StatefulWidget {
  const TakeSignaturePage({super.key});

  @override
  TakeSignaturePageState createState() => TakeSignaturePageState();
}

class TakeSignaturePageState extends State<TakeSignaturePage> {
  final GlobalKey _globalKey = GlobalKey();
  List<Offset?> points = [];
  bool isSigned = false;

  void resetSignature() {
    setState(() {
      points.clear();
      isSigned = false;
    });
  }

  Future<void> saveAsPicture() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    String base64String = base64Encode(pngBytes);
    showDialogMessage('', true);
    Navigator.of(context).pop();
  }

  void showDialogMessage(String error, bool isdone) {
    if (isdone == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Signature Saved Successfully"),
            Icon(
              Icons.done,
              color: Color.fromARGB(255, 126, 233, 3),
            )
          ],
        ),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Signature Saved Failed: $error'),
            const Icon(
              Icons.close,
              color: Colors.red,
            )
          ],
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text('Add Signature'),
        actions: [
          if (points.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.cyan,
              ),
              margin: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: resetSignature,
              ),
            ),
        ],
      ),
      bottomNavigationBar: MaterialButton(
        color: isSigned == true ? Colors.cyan : Colors.grey,
        onPressed: saveAsPicture,
        child: const Text(
          'Save Signature',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: RepaintBoundary(
          key: _globalKey,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                RenderBox renderBox = context.findRenderObject() as RenderBox;
                points.add(renderBox.globalToLocal(details.globalPosition));
                isSigned = true;
              });
            },
            onPanEnd: (details) {
              points.add(null); // لإظهار خط متقطع
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              width: double.infinity,
              height: double.infinity,
              color: Colors.brown,
              child: CustomPaint(
                painter: SignaturePainter(points),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignaturePainter extends CustomPainter {
  final List<Offset?> points;

  SignaturePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) => true;
}

/////////////////
class ShowScanBarcodeArrive extends StatefulWidget {
  const ShowScanBarcodeArrive({
    super.key,
  });
  @override
  State<ShowScanBarcodeArrive> createState() => ShowScanBarcodeArriveState();
}

class ShowScanBarcodeArriveState extends State<ShowScanBarcodeArrive> {
  MobileScannerController cameraController = MobileScannerController();
  String? barcode;
  bool start = false;
  bool save = false;
  String id = 'NULL';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (BarcodeCapture barcodeCapture) async {
              if (start == true) {
                return;
              }
              id = 'NULL';
              final List<Barcode> barcodes = barcodeCapture.barcodes;
              if (barcodes.isNotEmpty) {
                barcode = barcodes.first.rawValue;
                List<String> temp = barcode!.split(',');
                if (temp[0].contains(':')) {
                  id = temp[0].split(':')[1].trim();
                }
                start = true;
                setState(() {});
              }
            },
          ),
          start == true
              ? Center(
                  child: Card(
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(10),
                      children: [
                        Text(
                          id != 'NULL'
                              ? 'Save Order Number: $id ?'
                              : "No Barcode",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        id == 'NULL'
                            ? Row(
                                children: [
                                  save == true
                                      ? const CircularProgressIndicator()
                                      : MaterialButton(
                                          onPressed: () async {
                                            save = true;
                                            setState(() {});
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    icon: const Icon(
                                                      Icons.done,
                                                      color: Colors.green,
                                                    ),
                                                    title: const Text(
                                                        "Saved Successfully"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            start = false;
                                                            save = false;
                                                            setState(() {});
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              const Text("OK"))
                                                    ],
                                                  );
                                                });
                                          },
                                          child: const Text("Save"),
                                        ),
                                  save == true
                                      ? Container()
                                      : MaterialButton(
                                          onPressed: () {
                                            save = false;
                                            start = false;
                                            setState(() {});
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                ],
                              )
                            : MaterialButton(
                                onPressed: () {
                                  save = false;
                                  start = false;
                                  setState(() {});
                                },
                                child: const Text("OK"),
                              ),
                      ],
                    ),
                  ),
                )
              : const Center(),
          Positioned(
            top: 10,
            child: buildControlButtons(),
          ),
        ],
      ),
    );
  }

  Widget buildControlButtons() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.white24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                cameraController.toggleTorch();
              },
              icon: const Icon(Icons.flash_on),
            ),
            IconButton(
              onPressed: () {
                cameraController.switchCamera();
              },
              icon: const Icon(Icons.switch_camera),
            ),
          ],
        ),
      );
}
