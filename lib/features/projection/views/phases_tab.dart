import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:goal_planner/core/constants/constants.dart';
import 'package:goal_planner/core/widgets/row_text.dart';
import 'package:goal_planner/features/projection/views/widgets/expanded_tile.dart';

import '../../investment_selector/controllers/investment_selector_controller.dart';
import '../../target_setter/controller/target_controller.dart';

class PhaseTab extends StatefulWidget {
  final InvestmentData targetData;
  final TargetState mainTargetData;
  final List<FlSpot> mfPoints;
  final List<FlSpot> stocksPoints;
  final List<FlSpot> sipPoints;
  final void Function(int)? onTabChanged;

  const PhaseTab({super.key,required this.targetData,required this.mainTargetData, this.onTabChanged, required this.mfPoints, required this.stocksPoints, required this.sipPoints});
  @override
  _PhaseTabState createState() => _PhaseTabState();
}

class _PhaseTabState extends State<PhaseTab>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {


      if (!_tabController.indexIsChanging) {
        // This triggers AFTER the tab has changed
        widget.onTabChanged?.call(_tabController.index);
      }

      if (_tabController.indexIsChanging == false) {
        widget.onTabChanged?.call(_tabController.index);

        setState(() {}); // Rebuild when tab changes
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: appColor,
      body: Column(
        children: [
          Container(
            child: TabBar(
              controller: _tabController,
              labelColor: appPurple,
              padding: EdgeInsets.zero,
              dividerColor: appColor,
              labelStyle: appFont(10, Colors.white),
              unselectedLabelColor: appGrey,
              indicatorColor: appPurple,
        indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(text: "Phase 1",),
                Tab(text: "Phase 2"),
                Tab(text: "Phase 3"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 5,right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SizedBox(
                        height: 10,
                      ),

                      Text('Goal: ${currency}${widget.mainTargetData.targetAmount} Cr',style: appFont(14,Colors.white),),

                      SizedBox(
                        height: 5,
                      ),

                      LinearProgressIndicator(
                        value: getAmountPercentage(),
                        minHeight: 10,
                        valueColor:  AlwaysStoppedAnimation<Color>(appPurple),
                        backgroundColor: appGrey600,
                        borderRadius: BorderRadius.circular(52),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Text('${widget.mainTargetData.phases[_tabController.index].$1}',style: appFont(10, appGrey50),),

                          Text('${widget.mainTargetData.phases[_tabController.index].$2}',style: appFont(10, appGrey50),)


                        ],
                      ),


                      SizedBox(
                        height: 10,
                      ),


                      Text('Phased Investment Plan',style: appFont(14, Colors.white),),

                      SizedBox(
                        height: 5,
                      ),

                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: appDarkGrey,
                            border: Border.all(color: appGrey.withOpacity(0.2),width: 0.5)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text('Phase ${index + 1} (${widget.mainTargetData.phases[_tabController.index].$1} - ${widget.mainTargetData.phases[_tabController.index].$2})',style: appFont(11, appGrey200),),

                              SizedBox(
                                height: 5,
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total Investment : ${indiaFormat.format(getFinalAmount(widget.stocksPoints) + getFinalAmount(widget.sipPoints))}',style: appFont(11, Colors.white,weight: FontWeight.w600),),
                                  Text('SIP : ${indiaFormat.format(getFinalAmount(widget.mfPoints))}/month ',style: appFont(9, Colors.white))
                                ],
                              ),

                              SizedBox(
                                height: 5,
                              ),


                              Text('Equity',style: appFont(11, Colors.white,weight: FontWeight.w600),),

                              SizedBox(
                                height: 10,
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Stocks',style: appFont(11, Colors.white,weight: FontWeight.w600),),
                                  Text(
                                    '${(getPercentage(widget.stocksPoints) * 100).toStringAsFixed(2)}%',
                                    style: appFont(9, Colors.white),
                                  )

                                ],
                              ),

                              LinearProgressIndicator(
                                value: getPercentage(widget.stocksPoints),
                                minHeight: 10,
                                color: appPurple,
                                backgroundColor: appGrey600,
                                borderRadius: BorderRadius.circular(52),
                              ),

                              ExpandableStockCard(
                                title: 'Specific Stocks',
                                amount: indiaFormat.format(getFinalAmount(widget.stocksPoints)),
                                children: widget.targetData.stocks.map((e) {
                                  return rowWhiteText(e.company, e.quantity.toString());
                                }).toList(),
                              ),





                              SizedBox(
                                height: 15,
                              ),



                              Text('Mutual Funds',style: appFont(11, Colors.white,weight: FontWeight.w600),),

                              SizedBox(
                                height: 10,
                              ),


                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Funds',style: appFont(11, Colors.white,weight: FontWeight.w600),),
                                  Text(
                                    '${(getPercentage(widget.mfPoints) * 100).toStringAsFixed(2)}%',
                                    style: appFont(9, Colors.white),
                                  )
                                ],
                              ),

                              LinearProgressIndicator(
                                value: getPercentage(widget.mfPoints),
                                minHeight: 10,
                                color: appPurple,
                                backgroundColor: appGrey600,
                                borderRadius: BorderRadius.circular(52),
                              ),


                              ExpandableStockCard(
                                title: 'Specific Funds',
                                amount: indiaFormat.format(getFinalAmount(widget.mfPoints)),
                                children: widget.targetData.mutualFunds.map((e) {
                                  return rowWhiteText(e.name, e.quantity.toString());
                                }).toList(),
                              ),



                              SizedBox(
                                height: 15,
                              ),


                              Text('Provident Fund',style: appFont(11, Colors.white,weight: FontWeight.w600),),

                              SizedBox(
                                height: 10,
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Pfs',style: appFont(11, Colors.white,weight: FontWeight.w600),),
                                  Text(
                                    '${(getPercentage(widget.sipPoints) * 100).toStringAsFixed(2)}%',
                                    style: appFont(9, Colors.white),
                                  )
                                ],
                              ),

                              LinearProgressIndicator(
                                value: getPercentage(widget.sipPoints),
                                minHeight: 10,
                                color: appPurple,
                                backgroundColor: appGrey600,
                                borderRadius: BorderRadius.circular(52),
                              ),

                              ExpandableStockCard(
                                title: 'Pfs',
                                amount: indiaFormat.format(getFinalAmount(widget.sipPoints)),
                                children: widget.targetData.providentFunds.map((e) {
                                  return rowWhiteText(e.totalCorpus.toString(), '${e.interestRate} %');
                                }).toList(),
                              ),



                            ],
                          ),
                        ),
                      )

                    ],
                  ),
                );
              }),
            ),
          ),

        ],
      ),
    );
  }


  getFinalAmount(List<FlSpot> points){
    return points.last.y;
  }

  getTotalAmount(){
    return widget.mfPoints.last.y +widget.stocksPoints.last.y + widget.sipPoints.last.y ;
  }

  getPercentage(List<FlSpot> points){
    return (points.last.y)/(widget.mfPoints.last.y +widget.stocksPoints.last.y + widget.sipPoints.last.y) ;
  }

  getAmountPercentage(){
    print('Tab Content ${(widget.mfPoints.last.y +widget.stocksPoints.last.y + widget.sipPoints.last.y)} ${(double.parse(widget.mainTargetData.targetAmount) /3)* 10000000}');
    return (widget.mfPoints.last.y +widget.stocksPoints.last.y + widget.sipPoints.last.y) /((double.parse(widget.mainTargetData.targetAmount) /3)* 10000000);
  }


}
