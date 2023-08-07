import 'package:flutter/material.dart';
import 'package:saur_dealer/utils/helper_method.dart';

import '../../model/warranty_model.dart';
import '../../utils/colors.dart';
import '../../utils/date_time_formatter.dart';
import '../../utils/theme.dart';
import '../../widgets/gaps.dart';

class WarrantyDetailScreen extends StatefulWidget {
  const WarrantyDetailScreen({super.key, required this.warrantyRequest});
  static const String routePath = '/requestDetalScreen';
  final WarrantyModel warrantyRequest;

  @override
  State<WarrantyDetailScreen> createState() => _WarrantyDetailScreenState();
}

class _WarrantyDetailScreenState extends State<WarrantyDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: ListView(
        children: [
          deviceDetailCard(context),
          customerDetailCard(context),
          dealerDetailCard(context),
        ],
      ),
    );
  }

  Card dealerDetailCard(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(defaultPadding),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stockist Details',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            verticalGap(defaultPadding * 0.5),
            cardLargeDetail(context, 'Stockist',
                widget.warrantyRequest.stockists?.stockistName ?? ''),
            cardLargeDetail(context, 'Business',
                widget.warrantyRequest.stockists?.businessName ?? ''),
            cardLargeDetail(context, 'Phone',
                widget.warrantyRequest.stockists?.mobileNo ?? ''),
            cardLargeDetail(
                context, 'Place', '${widget.warrantyRequest.state}'),
            cardLargeDetail(context, 'Address',
                widget.warrantyRequest.stockists?.businessAddress ?? ''),
          ],
        ),
      ),
    );
  }

  Card customerDetailCard(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(defaultPadding),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Details',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            verticalGap(defaultPadding * 0.5),
            cardLargeDetail(context, 'Customer',
                widget.warrantyRequest.customer?.customerName ?? ''),
            cardLargeDetail(context, 'Phone',
                widget.warrantyRequest.customer?.mobileNo ?? ''),
            cardLargeDetail(
                context, 'Email', '${widget.warrantyRequest.customer?.email}'),
            cardLargeDetail(context, 'Address',
                prepareAddress(widget.warrantyRequest.customer?.address)),
          ],
        ),
      ),
    );
  }

  Card deviceDetailCard(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(defaultPadding),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Device Details',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            verticalGap(defaultPadding * 0.5),
            cardLargeDetail(
              context,
              'System info',
              '${widget.warrantyRequest.itemDescription} ${widget.warrantyRequest.lpd}',
            ),
            cardLargeDetail(context, 'Serial No',
                '${widget.warrantyRequest.warrantySerialNo}'),
            cardLargeDetail(context, 'Guarantee',
                '${widget.warrantyRequest.guaranteePeriod}'),
            cardLargeDetail(context, 'Guarantee Status',
                '${widget.warrantyRequest.guaranteeStatus}'),
            cardLargeDetail(
                context, 'Model No', '${widget.warrantyRequest.model}'),
            cardLargeDetail(
                context, 'Invoice', '${widget.warrantyRequest.invoiceNo}'),
            cardLargeDetail(
              context,
              'Installed on',
              DateTimeFormatter.onlyDateShort(
                  widget.warrantyRequest.installationDate ?? ''),
            ),
          ],
        ),
      ),
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
