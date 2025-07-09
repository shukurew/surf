import 'package:permission_handler/permission_handler.dart';

class PermissionServiceAll {
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      final result = await Permission.camera.request();
      return result.isGranted;
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    return false;
  }

  Future<bool> requestImagePermission() async {
    final status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      final result = await Permission.storage.request();
      return result.isGranted;
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    return false;
  }

  Future<bool> requestAllPermissions() async {
    final cameraGranted = await requestCameraPermission();
    final imageGranted = await requestImagePermission();

    return cameraGranted && imageGranted;
  }
}
