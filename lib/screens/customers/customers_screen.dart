import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:saur_dealer/screens/customers/warranty_screen.dart';
import 'package:saur_dealer/utils/colors.dart';
import 'package:saur_dealer/utils/enum.dart';

import '../../model/list_model/warranty_request_list.dart';
import '../../services/api_service.dart';
import '../../services/snakbar_service.dart';
import '../../utils/preference_key.dart';
import '../../utils/theme.dart';
import '../../widgets/gaps.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key, required this.switchTabs});
  final Function(int index) switchTabs;

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
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
        list?.data?.retainWhere((element) =>
            element.allocationStatus == AllocationStatus.APPROVED.name);
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
            'Customers',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          actions: const [
            AppBarSearchButton(
              buttonHasTwoStates: false,
            )
          ],
        ),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return list?.data?.isNotEmpty ?? false
        ? ListView.separated(
            itemBuilder: (context, index) => ListTile(
                  tileColor: Colors.white,
                  leading: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(settingsPageUserIconSize),
                    child: (list?.data
                                ?.elementAt(index)
                                .customer
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
                            imageUrl:
                                list?.data?.elementAt(index).customer?.image ??
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
                  title: Text(
                    '${list?.data?.elementAt(index).customer?.customerName}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: textColorDark,
                        ),
                  ),
                  subtitle: Text(
                    '${list?.data?.elementAt(index).warrantySerialNo}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: textColorDark,
                        ),
                  ),
                  onTap: () => Navigator.pushNamed(
                    context,
                    WarrentyScreen.routePath,
                    arguments: list?.data?.elementAt(index),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          LineAwesomeIcons.what_s_app,
                          color: Colors.green,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.chevron_right,
                        ),
                      ),
                    ],
                  ),
                ),
            separatorBuilder: (context, index) => const Divider(
                  color: dividerColor,
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
                'No customer with warranty found',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: hintColor,
                    ),
              ),
            ),
          ),
          verticalGap(defaultPadding),
          ElevatedButton(
            onPressed: () {
              widget.switchTabs(1);
            },
            child: Text(
              'Raise warranty request',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                  ),
            ),
          )
        ],
      ),
    );
  }
}
