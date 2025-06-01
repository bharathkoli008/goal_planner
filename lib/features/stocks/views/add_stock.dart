import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goal_planner/core/constants/constants.dart';
import 'package:goal_planner/core/widgets/textfield.dart';
import 'package:goal_planner/features/stocks/models/stock_model.dart';

import '../../../data/repositories/investment_repository.dart';

class StockQuantityInputSheet extends StatefulWidget {
  final String stockName;

  const StockQuantityInputSheet({super.key, required this.stockName});

  @override
  State<StockQuantityInputSheet> createState() => _StockQuantityInputSheetState();
}

class _StockQuantityInputSheetState extends State<StockQuantityInputSheet> {
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  late List<TextEditingController> percentIncreaseControllers;
  double fetchedSharePrice = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    percentIncreaseControllers = List.generate(3, (_) => TextEditingController());
    _fetchStockDetails();
  }

  Future<void> _fetchStockDetails() async {
    // Replace with actual fetch logic
    var stockDetails = await InvestmentRepository().fetchStockDetails(widget.stockName);


    fetchedSharePrice = double.parse(stockDetails['currentPrice']['BSE']);

      priceController.text = fetchedSharePrice.toStringAsFixed(2);

    isLoading = false;
    setState(() {});
  }

  @override
  void dispose() {
    quantityController.dispose();

    for (var c in percentIncreaseControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    final quantity = int.tryParse(quantityController.text);
    final price = double.tryParse(priceController.text);
    if (quantity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid quantity")),
      );
      return;
    }

    final phases = List.generate(3, (i) {

      final percent = double.tryParse(percentIncreaseControllers[i].text) ?? 0;
      return {
        'phase': i + 1,
        'increasePercent': percent,
      };
    });

    StockInvestment value = StockInvestment(buyPrice: double.parse(priceController.text), company: widget.stockName, quantity: quantity, phaseInvestments: phases);

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
            Text("Stock: ${widget.stockName}", style: appFont(16, Colors.white,weight: FontWeight.bold)),
            const SizedBox(height: 10),
            CustomFocusTextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
             label: 'Quantity',
            ),

            const SizedBox(height: 10),

            isLoading ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                children: [
                  CircularProgressIndicator(color: appPurple,strokeWidth: 2,),
                  SizedBox(
                    height: 4,
                  ),
                  Text('Fetching Current Price ..',style: appFont(10, appGrey),)
                ],
              ),
            ) :  CustomFocusTextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              label: 'Price',
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(3, (i) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.28, // Adjust to fit 3 items with spacing
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Phase ${i + 1}", style: appFont(14, appGrey)),
                      const SizedBox(height: 8),
                      CustomFocusTextField(
                        controller: percentIncreaseControllers[i],
                        keyboardType: TextInputType.number,
                        label: 'Increase (%)',
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
              child:  Text('Save',style: appFont(16, Colors.white),),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
