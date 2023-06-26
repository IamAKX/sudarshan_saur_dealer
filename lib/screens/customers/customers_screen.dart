import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:saur_dealer/screens/customers/warranty_screen.dart';
import 'package:saur_dealer/utils/colors.dart';

import '../../utils/theme.dart';
import '../../widgets/gaps.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key, required this.switchTabs});
  final Function(int index) switchTabs;

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  bool isListVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWithSearchSwitch(
        actionsIconTheme: const IconThemeData(color: primaryColor),
        animation: (child) => AppBarAnimationSlideLeft(
            milliseconds: 600, withFade: false, percents: 1.0, child: child),
        onChanged: (value) {},
        appBarBuilder: (context) => AppBar(
          title: InkWell(
            onTap: () => setState(() {
              isListVisible = !isListVisible;
            }),
            child: Text(
              'Customers',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
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
    return isListVisible
        ? ListView.separated(
            itemBuilder: (context, index) => ListTile(
                  tileColor: Colors.white,
                  leading: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(settingsPageUserIconSize),
                    child: Image.asset(
                      'assets/images/dummy_user.jpg',
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    'John Doe',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: textColorDark,
                        ),
                  ),
                  subtitle: Text(
                    '126357$index',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: textColorDark,
                        ),
                  ),
                  onTap: () =>
                      Navigator.pushNamed(context, WarrentyScreen.routePath),
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
            itemCount: 20)
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
