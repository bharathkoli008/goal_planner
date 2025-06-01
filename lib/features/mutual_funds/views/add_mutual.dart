import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goal_planner/core/constants/constants.dart';
import 'package:goal_planner/core/widgets/textfield.dart';

import '../../../data/repositories/investment_repository.dart';
import '../models/mutual_fund_model.dart';

class MutualFundInputSheet extends StatefulWidget {
  final String stockName;

  const MutualFundInputSheet({super.key, required this.stockName});

  @override
  State<MutualFundInputSheet> createState() => _MutualFundInputSheetState();
}

class _MutualFundInputSheetState extends State<MutualFundInputSheet> {
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  late List<TextEditingController> sipControllers;

  double fetchedSharePrice = 0;
  bool isLoading = true;
  MutualFund? mf; // Store fetched mutual fund data

  @override
  void initState() {
    super.initState();
    sipControllers = List.generate(3, (_) => TextEditingController());
    _fetchStockDetails();
  }

  String extractUntilFund(String input) {
    final index = input.indexOf('Fund');
    if (index != -1) {
      return input.substring(0, index + 'Fund'.length).trim();
    }
    return input;
  }

  Future<void> _fetchStockDetails() async {
    final stockDetails = await InvestmentRepository().fetchMfDetails(
      extractUntilFund(widget.stockName),
    );
    mf = MutualFund.fromJson(stockDetails);
    fetchedSharePrice = mf!.currentNav ?? 0;
    priceController.text = fetchedSharePrice.toStringAsFixed(2);
    isLoading = false;
    setState(() {});
  }

  @override
  void dispose() {
    quantityController.dispose();
    for (var c in sipControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    final quantity = int.tryParse(quantityController.text);
    if (quantity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid quantity")),
      );
      return;
    }

    final phases = List.generate(3, (i) {
      final sip = double.tryParse(sipControllers[i].text) ?? 0;
      return {
        'phase': i + 1,
        'sip': sip,
      };
    });

    SelectedMf value = SelectedMf(mf: mf!, quantity: quantity, name: widget.stockName, phases: phases);

    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Mutual Fund: ${widget.stockName}",
              style: appFont(16, Colors.white, weight: FontWeight.bold),
            ),
            const SizedBox(height: 10),


            CustomFocusTextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              label: 'Units',
            ),
            const SizedBox(height: 10),

            isLoading
                ? Column(
              children: [
                const CircularProgressIndicator(strokeWidth: 2),
                const SizedBox(height: 4),
                Text('Fetching Mutual Fund Info...',
                    style: appFont(10, appGrey)),
              ],
            )
                : CustomFocusTextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              label: 'NAV (Auto-filled)',
            ),

            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(3, (i) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.28,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Phase ${i + 1}", style: appFont(14, appGrey)),
                      const SizedBox(height: 8),
                      CustomFocusTextField(
                        controller: sipControllers[i],
                        keyboardType: TextInputType.number,
                        label: 'SIP (₹)',
                      ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _submit,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(appPurple),
              ),
              child: Text('Save', style: appFont(16, Colors.white)),
            ),
            const SizedBox(height: 16),


            if (!isLoading && mf != null) ...[
              _infoRow("Category", mf!.category ?? ''),
              _infoRow("NAV", "₹${mf!.currentNav}"),
              _infoRow("Fund Size", "₹${mf!.fundSize} Cr"),

              const Divider(height: 20),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$title: ", style: appFont(13, appGrey)),
          Expanded(child: Text(value, style: appFont(13, Colors.white))),
        ],
      ),
    );
  }
}
