import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_planner/core/constants/constants.dart';
import 'package:goal_planner/core/widgets/appBar.dart';
import 'package:goal_planner/core/widgets/textfield.dart';

import '../../../data/models/stock.dart';
import '../controllers/stock_notifier.dart';
import '../models/stock_model.dart';
import 'add_stock.dart';


class IndustrySearchPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<IndustrySearchPage> createState() => _IndustrySearchPageState();
}

class _IndustrySearchPageState extends ConsumerState<IndustrySearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<IndustryStock> results = [];
  List<StockInvestment> selectedStocks = [];
  bool isLoading = false;

  void _searchIndustry(String query) async {
    setState(() {
      isLoading = true;
    });
    final results = await ref.read(stockInvestmentProvider.notifier).searchIndustry(query);
    setState(() {
      this.results = results;
      isLoading = false;
    });
  }




  void _addToSelected(IndustryStock stock) async {
    final qty =  await showModalBottomSheet<StockInvestment>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          builder: (context, scrollController) => Container(
            decoration: const BoxDecoration(
              color: appColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.only(bottom: 20),
            child: SingleChildScrollView(
              controller: scrollController,
              child: StockQuantityInputSheet(stockName: stock.commonName),
            ),
          ),
        );
      },
    );

    if (qty != null) {
      setState(() {
        selectedStocks.add(qty);
      });
    }
  }

  void _submit() {
    Navigator.of(context).pop(selectedStocks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor,
      appBar: customAppBar("Select Stocks"),
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: CustomFocusTextField(
                  controller: _controller,
                  label: "Enter industry",
                  onSubmitted: _searchIndustry,
                ),
              ),
              SizedBox(
                width: 15,
              ),
            ],
          ),
          Expanded(
            child: isLoading ? Center(child: CircularProgressIndicator(strokeWidth: 2,color: appPurple,)) :ListView.builder(
              itemCount: results.length,
              itemBuilder: (_, index) {
                final stock = results[index];
                return Column(
                  children: [
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(stock.commonName,style: appFont(14, appPurple),),
                          Text(stock.stockType ?? '',style: appFont(14, appPurple),),
                        ],
                      ),
                      subtitle: Text("Industry: ${stock.mgIndustry}",style: appFont(14, appGrey),),
                      onTap: () => _addToSelected(stock),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(
                        thickness: 0.5,
                        color: appGrey,
                      ),
                    )
                  ],
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _submit,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(appPurple),

            ),
            child: Text("Submit Selected Stocks",style: appFont(16, Colors.white)),
          ),

          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
