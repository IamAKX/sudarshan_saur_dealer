import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/api_service.dart';
import '../../services/snakbar_service.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';
import '../../widgets/gaps.dart';
import '../home_container/home_container.dart';

class ConclusionScreen extends StatefulWidget {
  const ConclusionScreen({
    super.key,
  });
  static const String routePath = '/conclusionScreen';

  @override
  State<ConclusionScreen> createState() => _ConclusionScreenState();
}

class _ConclusionScreenState extends State<ConclusionScreen> {
  late ApiProvider _api;

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
            'Request Submitted',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        body: getBody(context));
  }

  getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        Container(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(Constants.conclusionMessage),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(defaultPadding / 2),
              border: Border.all(color: hintColor)),
        ),
        verticalGap(defaultPadding),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, HomeContainer.routePath, (route) => false);
          },
          child: const Text('OK'),
        )
      ],
    );
  }
}
