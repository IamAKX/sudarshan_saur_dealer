import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:saur_dealer/screens/customers/warranty_screen.dart';
import 'package:saur_dealer/utils/colors.dart';
import 'package:saur_dealer/utils/enum.dart';

import '../../model/allocated_model.dart';
import '../../model/list_model/allocated_list.dart';
import '../../model/list_model/warranty_request_list.dart';
import '../../services/api_service.dart';
import '../../services/snakbar_service.dart';
import '../../utils/preference_key.dart';
import '../../utils/theme.dart';
import '../../widgets/gaps.dart';
import 'dealer_detail.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key, required this.switchTabs});
  final Function(int index) switchTabs;

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  late ApiProvider _api;
  AllocatedList? list;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => reloadScreen(),
    );
  }

  reloadScreen() async {
    await _api
        .getAllocatedWarrantyList(SharedpreferenceKey.getUserId())
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
      backgroundColor: Colors.white,
      appBar: AppBarWithSearchSwitch(
        actionsIconTheme: const IconThemeData(color: primaryColor),
        animation: (child) => AppBarAnimationSlideLeft(
            milliseconds: 600, withFade: false, percents: 1.0, child: child),
        onChanged: (value) {},
        appBarBuilder: (context) => AppBar(
          title: Text(
            'Allocated',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          actions: const [
            // AppBarSearchButton(
            //   buttonHasTwoStates: false,
            // )
          ],
        ),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    if (_api.status == ApiStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return list?.data?.isNotEmpty ?? false
        ? ListView.separated(
            itemBuilder: (context, index) {
              AllocatedModel? item = list?.data?.elementAt(index);
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(settingsPageUserIconSize),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(110),
                    child: (item?.stockists?.image?.isEmpty ?? true)
                        ? Image.asset(
                            'assets/images/profile_image_placeholder.png',
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          )
                        : CachedNetworkImage(
                            imageUrl: item?.stockists?.image ?? '',
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
                ),
                title: Text(
                  '${item?.warrantySerialNo}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                subtitle: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${item?.stockists?.stockistName ?? ''}',
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      color: dividerColor,
                      width: 1,
                      height: 15,
                    ),
                    Text(
                      item?.warrantyRequests?.status ??
                          AllocationStatus.ALLOCATED.name,
                      style: TextStyle(
                          color: getColorByStatus(
                              item?.warrantyRequests?.status ??
                                  AllocationStatus.ALLOCATED.name)),
                    ),
                  ],
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: hintColor,
                ),
                onTap: () => Navigator.pushNamed(
                        context, DealerDetail.routePath,
                        arguments: list?.data?.elementAt(index))
                    .then((value) => reloadScreen()),
              );
            },
            separatorBuilder: (context, index) => const Divider(
                  color: dividerColor,
                  indent: defaultPadding * 5,
                ),
            itemCount: list?.data?.length ?? 0)
        : noWarrantyCardWidget(context);
  }

  Center noWarrantyCardWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/svg/no_warranty.svg',
            width: 150,
          ),
          verticalGap(defaultPadding),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(
                'No serial number allocated',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: hintColor,
                    ),
              ),
            ),
          ),
          verticalGap(defaultPadding),
          // ElevatedButton(
          //   onPressed: () {
          //     widget.switchTabs(1);
          //   },
          //   child: Text(
          //     'Raise warranty request',
          //     style: Theme.of(context).textTheme.labelLarge?.copyWith(
          //           color: Colors.white,
          //         ),
          //   ),
          // )
        ],
      ),
    );
  }
}
