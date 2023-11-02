import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../model/images_model.dart';

class StorageService {
  static Future<String> uploadEventImage(
      File file, String fileName, String folder) async {
    String path = '$folder/$fileName';
    final ref = FirebaseStorage.instance.ref().child(path);
    UploadTask? uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    final downloadLink = await snapshot.ref.getDownloadURL();
    return downloadLink;
  }

  static Future<String> uploadProfileImage(File file, String userId) async {
    String path =
        '$userId/profileImane/${file.path.split(Platform.pathSeparator).last}';
    final ref = FirebaseStorage.instance.ref().child(path);
    UploadTask? uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    final downloadLink = await snapshot.ref.getDownloadURL();
    return downloadLink;
  }

  static Future<ImagesModel> uploadReqDocuments(File systemImage,
      File serialNumberImage, File aadhaarImage, String userId) async {
    ImagesModel model = ImagesModel();

    // upload serial number
    String serialNumberImagePath =
        '$userId/${serialNumberImage.path.split(Platform.pathSeparator).last}';
    var ref = FirebaseStorage.instance.ref().child(serialNumberImagePath);
    UploadTask? uploadTask = ref.putFile(serialNumberImage);
    var snapshot = await uploadTask.whenComplete(() {});
    var downloadLink = await snapshot.ref.getDownloadURL();
    model.imgSystemSerialNo = downloadLink;

    // upload aadhaar
    String aadhaarImagePath =
        '$userId/${aadhaarImage.path.split(Platform.pathSeparator).last}';
    ref = FirebaseStorage.instance.ref().child(aadhaarImagePath);
    uploadTask = ref.putFile(aadhaarImage);
    snapshot = await uploadTask.whenComplete(() {});
    downloadLink = await snapshot.ref.getDownloadURL();
    model.imgAadhar = downloadLink;

    // upload systemImage
    String systemImagePath =
        '$userId/${systemImage.path.split(Platform.pathSeparator).last}';
    ref = FirebaseStorage.instance.ref().child(systemImagePath);
    uploadTask = ref.putFile(systemImage);
    snapshot = await uploadTask.whenComplete(() {});
    downloadLink = await snapshot.ref.getDownloadURL();
    model.imgLiveSystem = downloadLink;

    return model;
  }
}
