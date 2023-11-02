import 'dart:io';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:saur_dealer/utils/preference_key.dart';

import '../../main.dart';
import '../../model/warranty_request_model.dart';
import '../../services/api_service.dart';
import '../../services/snakbar_service.dart';
import '../../services/storage_service.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/enum.dart';
import '../../utils/location_controller.dart';
import '../../utils/theme.dart';
import '../../widgets/gaps.dart';
import 'conclusion_screen.dart';

class PhotoUploadScreen extends StatefulWidget {
  const PhotoUploadScreen({
    super.key,
    required this.warrantyRequestModel,
  });
  final WarrantyRequestModel warrantyRequestModel;
  static const String routePath = '/photoUploadScreen';

  @override
  State<PhotoUploadScreen> createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
  late ApiProvider _api;
  bool uploadingImage = false;
  File? systemImage, serialNumberImage, aadhaarImage;
  bool agreement = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => reloadScreen(),
    );
  }

  reloadScreen() async {}

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Photo Upload',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          actions: [
            (uploadingImage || _api.status == ApiStatus.loading)
                ? Container(
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    // width: 20,
                    // height: 20,
                    child: const CircularProgressIndicator(),
                  )
                : TextButton(
                    onPressed: () async {
                      if (await Permission
                          .location.status.isPermanentlyDenied) {
                        // ignore: use_build_context_synchronously
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.bottomSlide,
                          title: 'Location access needed',
                          desc:
                              'You have denied location request multiple times, you have to grant access from app settings',
                          onDismissCallback: (type) {},
                          autoDismiss: false,
                          btnOkOnPress: () async {
                            await openAppSettings();
                            navigatorKey.currentState?.pop();
                          },
                          btnOkText: 'Open settings',
                          btnOkColor: primaryColor,
                        ).show();

                        return;
                      }

                      Position? position = await determinePosition();
                      if (systemImage == null ||
                          serialNumberImage == null ||
                          aadhaarImage == null) {
                        SnackBarService.instance
                            .showSnackBarError('Please select all 3 images');
                        return;
                      }
                      if (agreement) {
                        setState(() {
                          uploadingImage = true;
                        });
                        SnackBarService.instance.showSnackBarInfo(
                            'Uploading images, please wait it will take some time...');
                        widget.warrantyRequestModel.images =
                            await StorageService.uploadReqDocuments(
                                systemImage!,
                                serialNumberImage!,
                                aadhaarImage!,
                                widget.warrantyRequestModel.customers
                                        ?.customerId
                                        .toString() ??
                                    '');
                        setState(() {
                          uploadingImage = false;
                        });
                        widget.warrantyRequestModel.status =
                            AllocationStatus.PENDING.name;
                        widget.warrantyRequestModel.initUserType = 'DEALER';
                        widget.warrantyRequestModel.initiatedBy =
                            SharedpreferenceKey.getUserId().toString();

                        String? lat = position.latitude.toString();
                        lat = lat.substring(0, min(lat.length, 10));
                        String? lon = position.longitude.toString();
                        lon = lon.substring(0, min(lon.length, 10));

                        if (lat.isEmpty || lon.isEmpty) {
                          SnackBarService.instance
                              .showSnackBarError('Please give location access');

                          if (await Permission.locationWhenInUse
                              .request()
                              .isGranted) {
                            // Either the permission was already granted before or the user just granted it.
                          }

                          return;
                        }

                        widget.warrantyRequestModel.lat = lat;

                        widget.warrantyRequestModel.lon = lon;
                        _api
                            .createNewWarrantyRequest(
                                widget.warrantyRequestModel)
                            .then((value) {
                          if (value) {
                            prefs.remove(SharedpreferenceKey.newCustId);
                            prefs.remove(SharedpreferenceKey.newCustPhone);
                            prefs.remove(SharedpreferenceKey.newCustSerial);
                            prefs.remove(SharedpreferenceKey.ongoingRequest);

                            Navigator.pushNamed(
                                context, ConclusionScreen.routePath,
                                arguments: widget.warrantyRequestModel);
                          }
                        });
                      } else {
                        SnackBarService.instance.showSnackBarError(
                            'Please read and agree tems and conditions');
                        return;
                      }
                    },
                    child: const Text('Next'),
                  ),
          ],
        ),
        body: getBody(context));
  }

  getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        Text(
          'System Photo',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        verticalGap(defaultPadding / 2),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: hintColor.withOpacity(0.5),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          height: 200,
          width: double.infinity,
          child: systemImage != null
              ? Image.file(
                  systemImage!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                )
              : InkWell(
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      setState(() {
                        systemImage = File(image.path);
                      });
                    }
                  },
                  child: const Icon(
                    LineAwesomeIcons.camera,
                    size: 60,
                    color: Colors.grey,
                  ),
                ),
        ),
        verticalGap(defaultPadding),
        Text(
          'System Serial Number',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        verticalGap(defaultPadding / 2),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: hintColor.withOpacity(0.5),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          height: 200,
          width: double.infinity,
          child: serialNumberImage != null
              ? Image.file(
                  serialNumberImage!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                )
              : InkWell(
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      setState(() {
                        serialNumberImage = File(image.path);
                      });
                    }
                  },
                  child: const Icon(
                    LineAwesomeIcons.camera,
                    size: 60,
                    color: Colors.grey,
                  ),
                ),
        ),
        verticalGap(defaultPadding),
        Text(
          'Aadhaar Card',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        verticalGap(defaultPadding / 2),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: hintColor.withOpacity(0.5),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          height: 200,
          width: double.infinity,
          child: aadhaarImage != null
              ? Image.file(
                  aadhaarImage!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                )
              : InkWell(
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      setState(() {
                        aadhaarImage = File(image.path);
                      });
                    }
                  },
                  child: const Icon(
                    LineAwesomeIcons.camera,
                    size: 60,
                    color: Colors.grey,
                  ),
                ),
        ),
        verticalGap(defaultPadding * 1.5),
        TextButton(
          onPressed: () {
            showPrivacyDialogbox(context);
          },
          child: Text('Read Terms and Conditions'),
        ),
      ],
    );
  }

  showPrivacyDialogbox(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Terms and Conditions"),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text(Constants.termsAndConditions),
                    verticalGap(defaultPadding),
                    Row(
                      children: [
                        Checkbox(
                          value: agreement,
                          onChanged: (value) {
                            setState(() {
                              agreement = value ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            'I/we read and agreed and accepted the above terms and conditions',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              actions: [
                okButton,
              ],
            );
          },
        );
      },
    );
  }
}
