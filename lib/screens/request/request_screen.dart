import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saur_dealer/screens/request/new_request_sreen.dart';

import '../../utils/colors.dart';
import '../../utils/theme.dart';
import '../../widgets/gaps.dart';

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
  bool isListVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () => setState(() {
            isListVisible = !isListVisible;
          }),
          child: Text(
            'Warranty Request',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ),
      body: getBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, NewRequestScreen.routePath);
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
    return isListVisible
        ? Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: ListView(
              children: [
                // Pending tile
                ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(
                      vertical: defaultPadding / 2, horizontal: defaultPadding),
                  textColor: textColorDark,
                  collapsedBackgroundColor: Colors.white,
                  backgroundColor: pendingColor.withOpacity(0.1),
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(settingsPageUserIconSize),
                        child: Image.asset(
                          'assets/images/dummy_user.jpg',
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      horizontalGap(defaultPadding),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'John Doe',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: textColorDark,
                                ),
                          ),
                          Text(
                            '2544845',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
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
                      Text(
                        '5h ago',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: hintColor,
                            ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: defaultPadding / 2),
                        width: 3,
                        height: defaultPadding * 0.75,
                        color: dividerColor,
                      ),
                      Text(
                        'Request in review',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: pendingColor,
                            ),
                      ),
                    ],
                  ),
                  children: [
                    Container(
                      width: double.maxFinite,
                      color: pendingColor,
                      child: Container(
                        margin: const EdgeInsets.only(left: defaultPadding / 2),
                        color: Colors.white,
                        child: const Padding(
                          padding: EdgeInsets.all(defaultPadding / 2),
                          child: Text(
                              'Your request is under validation, you will be notified in 24 hours'),
                        ),
                      ),
                    )
                  ],
                ),
                // Accepted
                ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(
                      vertical: defaultPadding / 2, horizontal: defaultPadding),
                  textColor: textColorDark,
                  collapsedBackgroundColor: Colors.white,
                  backgroundColor: acceptedColor.withOpacity(0.1),
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(settingsPageUserIconSize),
                        child: Image.asset(
                          'assets/images/dummy_user.jpg',
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      horizontalGap(defaultPadding),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'John Doe',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: textColorDark,
                                ),
                          ),
                          Text(
                            '2544845',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
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
                      Text(
                        '1d ago',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: hintColor,
                            ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: defaultPadding / 2),
                        width: 3,
                        height: defaultPadding * 0.75,
                        color: dividerColor,
                      ),
                      Text(
                        'Request is approved',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: acceptedColor,
                            ),
                      ),
                    ],
                  ),
                  children: [
                    Container(
                      width: double.maxFinite,
                      color: acceptedColor,
                      child: Container(
                        margin: const EdgeInsets.only(left: defaultPadding / 2),
                        color: Colors.white,
                        child: const Padding(
                          padding: EdgeInsets.all(defaultPadding / 2),
                          child: Text(
                              'Your warranty card is generated. You get download or get it on email or whatsapp.'),
                        ),
                      ),
                    )
                  ],
                ),
                // Rejected
                ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(
                      vertical: defaultPadding / 2, horizontal: defaultPadding),
                  textColor: textColorDark,
                  collapsedBackgroundColor: Colors.white,
                  backgroundColor: rejectedColor.withOpacity(0.1),
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(settingsPageUserIconSize),
                        child: Image.asset(
                          'assets/images/dummy_user.jpg',
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      horizontalGap(defaultPadding),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'John Doe',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: textColorDark,
                                ),
                          ),
                          Text(
                            '2544845',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
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
                      Text(
                        '2w ago',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: hintColor,
                            ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: defaultPadding / 2),
                        width: 3,
                        height: defaultPadding * 0.75,
                        color: dividerColor,
                      ),
                      Text(
                        'Request is rejected',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: rejectedColor,
                            ),
                      ),
                    ],
                  ),
                  childrenPadding: EdgeInsets.zero,
                  children: [
                    Container(
                      width: double.maxFinite,
                      color: rejectedColor,
                      child: Container(
                        margin: const EdgeInsets.only(left: defaultPadding / 2),
                        color: Colors.white,
                        child: const Padding(
                          padding: EdgeInsets.all(defaultPadding / 2),
                          child: Text(
                              'The serial number in your request is incorrect'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
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
