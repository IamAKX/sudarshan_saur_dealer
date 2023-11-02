import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/allocated_model.dart';
import '../../model/warranty_model.dart';
import '../../services/api_service.dart';
import '../../services/snakbar_service.dart';
import '../../utils/enum.dart';

import '../../utils/colors.dart';
import '../../utils/theme.dart';
import '../../widgets/gaps.dart';

class DealerDetail extends StatefulWidget {
  const DealerDetail({super.key, required this.data});
  static const String routePath = '/dealerDetail';
  final AllocatedModel data;

  @override
  State<DealerDetail> createState() => _DealerDetailState();
}

class _DealerDetailState extends State<DealerDetail> {
  late ApiProvider _api;
  WarrantyModel? warrantyModel;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => reloadScreen(),
    );
  }

  reloadScreen() async {
    _api
        .getSerialDetailFromCrm(widget.data.warrantySerialNo ?? '')
        .then((value) {
      setState(() {
        warrantyModel = value;
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
          '${widget.data.warrantySerialNo}',
          style: Theme.of(context).textTheme.headlineSmall,
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
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        Card(
          color: Colors.white,
          child: Container(
            margin: EdgeInsets.all(defaultPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Device Details',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                verticalGap(defaultPadding * 0.5),
                cardLargeDetail(
                  context,
                  'Serial',
                  '${warrantyModel?.warrantySerialNo}',
                ),
                cardLargeDetail(
                    context, 'Desc', '${warrantyModel?.itemDescription}'),
                cardLargeDetail(context, 'Model No', '${warrantyModel?.model}'),
                cardLargeDetail(
                    context, 'Guarantee', '${warrantyModel?.guaranteePeriod}'),
                cardLargeDetail(context, 'Status',
                    '${widget.data.warrantyRequests?.status ?? AllocationStatus.ALLOCATED.name}'),
              ],
            ),
          ),
        ),
        verticalGap(defaultPadding),
        Card(
          color: Colors.white,
          child: Container(
            margin: EdgeInsets.all(defaultPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stockist Details',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                verticalGap(defaultPadding * 0.5),
                cardLargeDetail(
                  context,
                  'Name',
                  '${widget.data.stockists?.stockistName}',
                ),
                cardLargeDetail(context, 'B. Name',
                    '${widget.data.stockists?.businessName}'),
                cardLargeDetail(
                    context, 'GST', '${widget.data.stockists?.gstNumber}'),
                cardLargeDetail(
                    context, 'Mobile', '${widget.data.stockists?.mobileNo}'),
                cardLargeDetail(context, 'District',
                    '${widget.data.stockists?.address?.district}'),
                cardLargeDetail(context, 'State',
                    '${widget.data.stockists?.address?.state}'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row cardLargeDetail(BuildContext context, String key, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            key,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: textColorLight,
                ),
          ),
        ),
        horizontalGap(10),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColorDark, fontWeight: FontWeight.w400, height: 1.5),
          ),
        )
      ],
    );
  }
}
