import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_planner/core/constants/constants.dart';
import 'package:goal_planner/core/widgets/appBar.dart';
import 'package:goal_planner/core/widgets/textfield.dart';

import '../../../data/models/stock.dart';
import '../../stocks/controllers/stock_notifier.dart';
import '../../stocks/models/stock_model.dart';
import '../../stocks/views/add_stock.dart';
import '../controllers/mutual_fund_notifier.dart';
import '../models/mutual_fund_model.dart';
import 'add_mutual.dart';



class MutualFundPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<MutualFundPage> createState() => _MutualFundPageState();
}

class _MutualFundPageState extends ConsumerState<MutualFundPage> {
  final TextEditingController _controller = TextEditingController();
  List<MutualFundModel> results = [];
  List<SelectedMf> selectedMfs = [];
  bool isLoading = false;

  void _searchIndustry(String query) async {
    setState(() {
      isLoading = true;
    });
    final results = await ref.read(mutualFundProvider.notifier).searchIndustry(query);
    setState(() {
      this.results = results;
      isLoading = false;
    });
  }




  void _addToSelected(MutualFundModel stock) async {
    final qty =  await showModalBottomSheet<SelectedMf>(
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
              child: MutualFundInputSheet(stockName: stock.commonName),
            ),
          ),
        );
      },
    );

    if (qty != null) {
      setState(() {
        selectedMfs.add(qty);
      });
    }
  }

  void _submit() {
    Navigator.of(context).pop(selectedMfs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor,
      appBar: customAppBar("Select Mutual Fund"),
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: CustomFocusTextField(
                  key:const Key('mf'),
                  controller: _controller,
                  label: "Enter industry",
                  onChanged: _searchIndustry,
                ),
              ),
              SizedBox(
                width: 15,
              ),
            ],
          ),
          Expanded(
            child: isLoading ? Center(child: CircularProgressIndicator(strokeWidth: 2,color: appPurple,)) :  ListView.builder(
              itemCount: results.length,
              itemBuilder: (_, index) {
                final stock = results[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(stock.commonName,style: appFont(12, appPurple,weight: FontWeight.w600),),
                      subtitle: Text("Type: ${stock.schemeType}",style: appFont(10, appGrey),),
                      onTap: () {
                        // print(stock.commonName);
                        // print(stock.id);
                        _addToSelected(stock);
                      },
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
