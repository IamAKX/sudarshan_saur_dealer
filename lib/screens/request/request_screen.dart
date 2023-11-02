import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:saur_dealer/main.dart';
import 'package:saur_dealer/screens/raise_warranty_request/installation_address_screen.dart';
import 'package:saur_dealer/screens/request/new_request_sreen.dart';
import 'package:saur_dealer/screens/request/warranty_detail.dart';
import 'package:saur_dealer/utils/date_time_formatter.dart';
import 'package:saur_dealer/utils/helper_method.dart';

import '../../model/list_model/warranty_request_list.dart';
import '../../services/api_service.dart';
import '../../services/snakbar_service.dart';
import '../../utils/colors.dart';
import '../../utils/preference_key.dart';
import '../../utils/theme.dart';
import '../../widgets/gaps.dart';
import '../raise_warranty_request/new_customer.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({
    Key? key,
    required this.switchTabs,
  }) : super(key: key);
  final Function(int index) switchTabs;

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  late ApiProvider _api;
  WarrantyRequestList? list;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => reloadScreen(),
    );
  }

  reloadScreen() async {
    await _api
        .getWarrantyRequestListByDealerId(SharedpreferenceKey.getUserId())
        .then((value) {
      setState(() {
        list = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Guarantee Request',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          Visibility(
            visible: prefs.containsKey(SharedpreferenceKey.newCustId),
            child: IconButton(
              onPressed: () {
                prefs.remove(SharedpreferenceKey.newCustId);
                prefs.remove(SharedpreferenceKey.newCustPhone);
                prefs.remove(SharedpreferenceKey.newCustSerial);
                prefs.remove(SharedpreferenceKey.ongoingRequest);
                setState(() {});
              },
              icon: Icon(Icons.auto_delete_outlined),
            ),
          )
        ],
      ),
      body: getBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (prefs.containsKey(SharedpreferenceKey.newCustPhone)) {
            Navigator.pushNamed(context, InstallationAddressScreen.routePath);
          } else {
            Navigator.pushNamed(context, NewCustomerScreen.routePath);
          }
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: primaryColor,
          size: 35,
        ),
      ),
    );
  }

  getBody(BuildContext context) {
    return list?.data?.isNotEmpty ?? false
        ? Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: ListView.builder(
              itemCount: list?.data?.length ?? 0,
              itemBuilder: (context, index) => ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(
                    vertical: defaultPadding / 2, horizontal: defaultPadding),
                textColor: textColorDark,
                collapsedBackgroundColor: Colors.white,
                backgroundColor:
                    getColorByStatus(list?.data?.elementAt(index).status ?? '')
                        .withOpacity(0.1),
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(settingsPageUserIconSize),
                      child: (list?.data
                                  ?.elementAt(index)
                                  .customers
                                  ?.image
                                  ?.isEmpty ??
                              true)
                          ? Image.asset(
                              'assets/images/profile_image_placeholder.png',
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: list?.data
                                      ?.elementAt(index)
                                      .customers
                                      ?.image ??
                                  '',
                              fit: BoxFit.cover,
                              width: 40,
                              height: 40,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/images/profile_image_placeholder.png',
                                width: 40,
                                height: 40,
                              ),
                            ),
                    ),
                    horizontalGap(defaultPadding),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          list?.data
                                  ?.elementAt(index)
                                  .customers
                                  ?.customerName ??
                              '',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: textColorDark,
                                  ),
                        ),
                        Text(
                          list?.data
                                  ?.elementAt(index)
                                  .warrantyDetails
                                  ?.warrantySerialNo ??
                              '',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: textColorDark,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
                subtitle: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Text(
                    //   DateTimeFormatter.timesAgo(
                    //       list?.data?.elementAt(index).createdOn ?? ''),
                    //   style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    //         color: hintColor,
                    //       ),
                    // ),
                    // Container(
                    //   margin: const EdgeInsets.symmetric(
                    //       horizontal: defaultPadding / 2),
                    //   width: 3,
                    //   height: defaultPadding * 0.75,
                    //   color: dividerColor,
                    // ),
                    Text(
                      getShortMessageByStatus(
                          list?.data?.elementAt(index).status ?? ''),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: getColorByStatus(
                                list?.data?.elementAt(index).status ?? ''),
                          ),
                    ),
                  ],
                ),
                children: [
                  Container(
                    width: double.maxFinite,
                    color: getColorByStatus(
                        list?.data?.elementAt(index).status ?? ''),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin:
                                const EdgeInsets.only(left: defaultPadding / 2),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(defaultPadding / 2),
                              child: Text(
                                getDetailedMessageByStatus(
                                    list?.data?.elementAt(index).status ?? ''),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                WarrantyDetailScreen.routePath,
                                arguments: list?.data?.elementAt(index));
                          },
                          icon: const Icon(Icons.info),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : noRequestWidget(context);
    //The serial number in your request is incorrect
  }

  Center noRequestWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/svg/request_warranty.svg',
            width: 150,
          ),
          verticalGap(defaultPadding),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(
                'Not requested for warranty card yet?\nHit the "+" button to raise new request.',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: hintColor,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
