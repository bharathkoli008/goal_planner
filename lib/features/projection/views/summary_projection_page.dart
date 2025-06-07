import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_planner/features/projection/views/phases_tab.dart';
import 'package:goal_planner/features/projection/views/projection_chart.dart';

import '../../../core/constants/constants.dart';
import '../../../core/widgets/legend.dart';
import '../../../core/widgets/price_indicator.dart';
import '../../investment_selector/controllers/investment_selector_controller.dart';
import '../../mutual_funds/models/mutual_fund_model.dart';
import '../../pf/models/pf_model.dart';
import '../../stocks/models/stock_model.dart';
import '../../target_setter/controller/target_controller.dart';
import '../controller/export_chart.dart';
import '../controller/summary_controller.dart';

class SummaryProjectionPage extends ConsumerWidget {
  final InvestmentData targetData;
   SummaryProjectionPage(this.targetData, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projections = ref.watch(summaryProjectionProvider);
    final mainTargetData = ref.watch(targetControllerProvider);
    print(mainTargetData.phases);


    final selectedTab = ref.watch(selectedTabIndexProvider);
    final GlobalKey chartKey = GlobalKey();




    if (projections.isEmpty) {
      return Scaffold(
        backgroundColor: appColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: false,
          // automaticallyImplyLeading: false,
          leadingWidth: 30,
          backgroundColor: appColor,
            title: Text('Goal Planning',
            style: appFont(18,Colors.white),)),
        body: Padding(
          padding: const EdgeInsets.only(left: 15,right: 15),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Investment Growth Projection',style: appFont(16, Colors.white),),

                      InkWell(
                          onTap: () => exportChartAsPDF(chartKey,'${mainTargetData.phases[selectedTab].$1} - ${mainTargetData.phases[selectedTab].$2}'),
                        child: Container(
                            decoration: BoxDecoration(
                                color: appPurple,
                                borderRadius: BorderRadius.circular(18)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('Export',style: appFont(12, Colors.white),),
                            )),
                      ),
                    ],
                  ),

                  Text('See how your investments can reach ₹${mainTargetData.targetAmount} Cr by ${mainTargetData.targetYear}.',style: appFont(10, appGrey),),


              RepaintBoundary(
                key: chartKey,
                    child: Container(
                      decoration: BoxDecoration(
                        color: appColor
                      ),
                      child: Column(
                        children:[
                          Row(
                            children: [

                              legend('Mutual Fund',appPurple),
                              legendSpacer(),
                              legend('Stocks',appTeal),
                              legendSpacer(),
                              legend('SIP Growth',appBlue),






                            ],
                          ),



                          StackedAreaChart(
                            mainTargetData: mainTargetData,
                            phase: selectedTab,
                            stocksPoints: sumYValuesByX(getStocksPoints(targetData.stocks,selectedTab,mainTargetData.phases)),
                            mfPoints: sumYValuesByX(getMfPoints(targetData.mutualFunds,selectedTab,mainTargetData.phases)),
                            sipPoints: sumYValuesByX(getPfPoints(targetData.providentFunds,selectedTab,mainTargetData.phases)),
                          ),
                        ]
                      ),
                    ),
                  ),




                  Text('${mainTargetData.goalName} Goal Calculations',style: appFont(14, Colors.white),),

                  SizedBox(
                    height: 15,
                  ),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: appDarkGrey,
                      border: Border.all(color: appGrey,width: 0.5)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          priceIndicator('Required SIP (5yrs)','2.72 Lakh/month'),
                          Text(
                            '➜',
                            style: appFont(12, appPurple),
                          ),
                          priceIndicator('Inflation Adjusted','${calculateInflationAdjustedFV(expectedReturnRate: 15,
                          inflationRate: double.parse(mainTargetData.inflationRate),sipPerMonth: totalSipPerMonth(targetData.mutualFunds),years:( int.parse(mainTargetData.phases.first.$1)) -  int.parse(mainTargetData.phases.last.$2))}'),
                          Text(
                            '-',
                            style: appFont(12, appPurple),
                          ),
                          priceIndicator('Future Value','7.05 Cr'),
                          Text(
                            '=',
                            style: appFont(12, appPurple),
                          ),

                          priceIndicator('Shortfall','4.95 Cr'),



                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  SizedBox(
                    height: 700,
                      child: PhaseTab(
                        stocksPoints: sumYValuesByX(getStocksPoints(targetData.stocks,selectedTab,mainTargetData.phases)),
                        mfPoints: sumYValuesByX(getMfPoints(targetData.mutualFunds,selectedTab,mainTargetData.phases)),
                        sipPoints: sumYValuesByX(getPfPoints(targetData.providentFunds,selectedTab,mainTargetData.phases)),
                        targetData: targetData,
                        mainTargetData: mainTargetData,
                        onTabChanged: (index) {
                          ref.read(selectedTabIndexProvider.notifier).state = index;

                          Text('Current tab index: $index');
                        },
                      ),
                  )


                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Summary Projection')),
      body: ListView.builder(
        itemCount: projections.length,
        itemBuilder: (context, index) {
          final item = projections[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                'Phase 1: ₹${item.phase1.toStringAsFixed(2)}\n'
                    'Phase 2: ₹${item.phase2.toStringAsFixed(2)}\n'
                    'Phase 3: ₹${item.phase3.toStringAsFixed(2)}',
              ),
            ),
          );
        },
      ),
    );
  }

  String calculateInflationAdjustedFV({
    required double sipPerMonth,
    required double expectedReturnRate, // in %
    required double inflationRate, // in %
    required int years,
  }) {
    final double r = expectedReturnRate / 12 / 100;
    final int n = years * 12;

    // Future value of SIP (compounded monthly)
    final fv = sipPerMonth * ((pow(1 + r, n) - 1) / r) * (1 + r);

    // Adjusting for inflation
    final adjustedFV = fv / pow(1 + inflationRate / 100, years);

    return '12 Cr';
  }


  totalSipPerMonth(List<SelectedMf> mutualFunds,){
    double amount = 0;

    for(SelectedMf mf in mutualFunds){
      for(var phase  in mf.phases){
        amount += phase['sip'];
      }

    }

    return amount;
  }




  List<(int, int)> convertToIntPairs(List<(String, String)> stringPairs) {
    return stringPairs.map((pair) => (int.parse(pair.$1), int.parse(pair.$2))).toList();
  }

  List<FlSpot> getStocksPoints(
      List<StockInvestment> stocks,
      int selectedPhaseIndex,
      List<(String, String)> phaseRanges,
      ) {
    print('--- getStocksPoints called ---');
    print('Stocks: $stocks');
    print('Selected phase index: $selectedPhaseIndex');
    print('Phase ranges: $phaseRanges');

    List<FlSpot> points = [];

    final (String startStr, String endStr) = phaseRanges[selectedPhaseIndex];
    final int startYear = int.parse(startStr);
    final int endYear = int.parse(endStr);
    final int numYears = endYear - startYear + 1;

    print('Selected phase range: $startYear to $endYear, length: $numYears');

    for (final stock in stocks) {
      int quantity = stock.quantity;
      double buyPrice = stock.buyPrice ?? 100.0;
      double currentValue = quantity * buyPrice;

      // Get phase investment map
      final List<Map<String, dynamic>> rawPhases =
      (stock.phaseInvestments ?? []).cast<Map<String, dynamic>>();
      final Map<int, double> phaseMap = {
        for (var phase in rawPhases)
          phase['phase'] as int: (phase['increasePercent'] as num?)?.toDouble() ?? 0.0
      };

      print('Processing stock: quantity=$quantity, buyPrice=$buyPrice');

      double valueAtPhaseStart = currentValue;

      // Apply previous phase increases to get value at start of current phase
      for (int i = 0; i < selectedPhaseIndex; i++) {
        double percent = phaseMap[i + 1] ?? 0.0;
        valueAtPhaseStart *= (1 + percent / 100);
        print('Applied phase ${i + 1} increase of $percent% -> $valueAtPhaseStart');
      }

      // Apply current phase increase once
      double phasePercent = phaseMap[selectedPhaseIndex + 1] ?? 0.0;
      double valueAtPhaseEnd = valueAtPhaseStart * (1 + phasePercent / 100);

      print('Current phase ${selectedPhaseIndex + 1} increase: +$phasePercent%');
      print('Value at start of phase: $valueAtPhaseStart');
      print('Value at end of phase: $valueAtPhaseEnd');

      // Add FlSpots for each year in this phase with the final value
      for (int i = 0; i <= numYears; i++) {
        int year = i;
        double value = i == 0 ? valueAtPhaseStart : valueAtPhaseEnd;
        points.add(FlSpot(year.toDouble(), value));
        print('Added FlSpot(year=$year, value=${value.toStringAsFixed(2)})');
      }
    }

    print('Total points generated: ${points.length} ${points}');
    return points;
  }







  // List<FlSpot> getStocksPoints(List<StockInvestment> stocks, int phase) {
  //   List<FlSpot> points = [];
  //
  //   for (int stockIndex = 0; stockIndex < stocks.length ; stockIndex++) {
  //     final stock = stocks[stockIndex];
  //
  //     print("Stock ${stockIndex + 1}:");
  //     print("Quantity: ${stock.quantity}");
  //     print("Company: ${stock.company}");
  //     print("Buy Price: ${stock.buyPrice}");
  //     print("Phases: ${stock.phaseInvestments}");
  //
  //     int quantity = stock.quantity;
  //     double buyPrice = stock.buyPrice ?? 100.0;
  //     double currentValue = quantity * buyPrice;
  //
  //     int year = 0;
  //
  //     // Add Year 0
  //     points.add(FlSpot(year.toDouble(), currentValue));
  //     print("FlSpot($year, ${currentValue.toStringAsFixed(2)})");
  //
  //     List phases = stock.phaseInvestments ?? [];
  //
  //
  //
  //     for (int i = 0; i < phases.length - 1; i++) {
  //       print(' Phase index $i ${phases[i]}');
  //       final phase = phases[i];
  //       year++;
  //
  //       double percent = 0.0;
  //       if (phase.containsKey('increasePercent')) {
  //         percent = (phase['increasePercent'] as num).toDouble();
  //       }
  //
  //       currentValue *= (1 + percent / 100);
  //       points.add(FlSpot(year.toDouble(), currentValue));
  //        print("FlSpot($year, ${currentValue.toStringAsFixed(2)}) [+${percent.toStringAsFixed(2)}%]");
  //     }
  //   }
  //
  //   return points;
  // }


  List<FlSpot> getMfPoints(
      List<SelectedMf> mutualFunds,
      int selectedPhaseIndex,
      List<(String, String)> phaseRanges,
      ) {
    List<FlSpot> points = [];

    for (int index = 0; index < mutualFunds.length; index++) {
      final mf = mutualFunds[index];

      print("Mutual Fund ${index + 1}:");
      print("Quantity: ${mf.quantity}");
      print("Returns: ${mf.mf.absoluteReturns}");
      print("NAV: ${mf.mf.currentNav}");
      print("Phases: ${mf.phases}");

      double nav = mf.mf.currentNav ?? 100.0;
      int units = mf.quantity;
      double baseValue = nav * units;

      // Extract return % map
      Map<String, double>? returnsMap = mf.mf.absoluteReturns;

      List<double> yearlyReturns = [
        returnsMap?['1y'] ?? 8.0,
        ((returnsMap?['1y'] ?? 8.0) + (returnsMap?['3y'] ?? 7.0)) / 2,
        returnsMap?['3y'] ?? 7.0,
        ((returnsMap?['3y'] ?? 7.0) + (returnsMap?['5y'] ?? 6.5)) / 2,
        ((returnsMap?['3y'] ?? 7.0) + (returnsMap?['5y'] ?? 6.5)) / 2,
        ((returnsMap?['5y'] ?? 6.5) + (returnsMap?['10y'] ?? 6.0)) / 2,
        ((returnsMap?['5y'] ?? 6.5) + (returnsMap?['10y'] ?? 6.0)) / 2,
        ((returnsMap?['5y'] ?? 6.5) + (returnsMap?['10y'] ?? 6.0)) / 2,
        ((returnsMap?['5y'] ?? 6.5) + (returnsMap?['10y'] ?? 6.0)) / 2,
        ((returnsMap?['5y'] ?? 6.5) + (returnsMap?['10y'] ?? 6.0)) / 2,
      ];

      // Calculate compounded value from previous phases
      double carryForwardValue = baseValue;
      for (int i = 0; i < selectedPhaseIndex; i++) {
        final (String pStartStr, String pEndStr) = phaseRanges[i];
        final int pStart = int.parse(pStartStr);
        final int pEnd = int.parse(pEndStr);
        final int pYears = pEnd - pStart + 1;

        double avgReturn = 0;
        for (int j = 0; j < pYears; j++) {
          avgReturn += yearlyReturns[j];
        }
        avgReturn /= pYears;

        carryForwardValue = carryForwardValue * (1 + avgReturn / 100);
      }

      // Now calculate for the selected phase
      final (String startStr, String endStr) = phaseRanges[selectedPhaseIndex];
      final int startYear = int.parse(startStr);
      final int endYear = int.parse(endStr);
      final int numYears = endYear - startYear + 1;

      List<double> sips = [];
      for (var phase in mf.phases) {
        final int year = phase['phase'] ?? 0;
        if (year >= startYear && year <= endYear) {
          sips.add(phase['sip'] ?? 0.0);
        }
      }

      while (sips.length < numYears) {
        sips.add(0.0);
      }

      double currentValue = carryForwardValue;
      print("Year 0: ₹${currentValue.toStringAsFixed(2)}");
      points.add(FlSpot(0, currentValue));

      for (int i = 0; i < numYears; i++) {
        double sip = sips[i];
        double returnPercent = yearlyReturns[i];
        currentValue = (currentValue + sip) * (1 + returnPercent / 100);

        print("Year ${i + 1}: ₹${currentValue.toStringAsFixed(2)} [+₹${sip.toStringAsFixed(2)}, ${returnPercent.toStringAsFixed(2)}%]");
        points.add(FlSpot((i + 1).toDouble(), currentValue));
      }
    }

    print("-----------------------------$points");
    return points;
  }


  // List<FlSpot> getMfPoints(List<SelectedMf> mutualFunds, int phase) {
  //   List<FlSpot> points = [];
  //
  //   for (int index = 0; index < mutualFunds.length; index++) {
  //     final mf = mutualFunds[index];
  //
  //     print("Mutual Fund ${index + 1}:");
  //     print("Quantity: ${mf.quantity}");
  //     print("Returns: ${mf.mf.absoluteReturns}");
  //     print("NAV: ${mf.mf.currentNav}");
  //     print("Phases: ${mf.phases}");
  //
  //     double nav = mf.mf.currentNav ?? 100.0;
  //     int units = mf.quantity;
  //     double initialValue = nav * units;
  //
  //     // Extract return % map
  //     Map<String, double>? returnsMap = mf.mf.absoluteReturns;
  //
  //     // Approximate yearly returns
  //     List<double> yearlyReturns = [
  //       returnsMap?['1y'] ?? 8.0,
  //       ((returnsMap?['1y'] ?? 8.0) + (returnsMap?['3y'] ?? 7.0)) / 2,
  //       returnsMap?['3y'] ?? 7.0,
  //       ((returnsMap?['3y'] ?? 7.0) + (returnsMap?['5y'] ?? 6.5)) / 2,
  //       ((returnsMap?['3y'] ?? 7.0) + (returnsMap?['5y'] ?? 6.5)) / 2,
  //       ((returnsMap?['5y'] ?? 6.5) + (returnsMap?['10y'] ?? 6.0)) / 2,
  //       ((returnsMap?['5y'] ?? 6.5) + (returnsMap?['10y'] ?? 6.0)) / 2,
  //       ((returnsMap?['5y'] ?? 6.5) + (returnsMap?['10y'] ?? 6.0)) / 2,
  //       ((returnsMap?['5y'] ?? 6.5) + (returnsMap?['10y'] ?? 6.0)) / 2,
  //       ((returnsMap?['5y'] ?? 6.5) + (returnsMap?['10y'] ?? 6.0)) / 2,
  //     ];
  //
  //     // Gather SIPs from phases (max 3)
  //     List<double> sips = List.generate(10, (i) {
  //       if (i < mf.phases.length) {
  //         return mf.phases[i]['sip'] ?? 0.0;
  //       }
  //       return 0.0;
  //     });
  //
  //
  //
  //     double currentValue = initialValue;
  //     print("Year 0: ₹${currentValue.toStringAsFixed(2)}");
  //
  //     points.add(FlSpot(0, currentValue));
  //
  //     for (int year = 0; year < 10; year++) {
  //       currentValue = (currentValue + sips[year]) * (1 + yearlyReturns[year] / 100);
  //       print("Year ${year + 1}: ₹${currentValue.toStringAsFixed(2)}");
  //
  //       // Add to chart points (x = year, y = value)
  //       points.add(FlSpot(year.toDouble(), currentValue));
  //
  //     }
  //
  //
  //   }
  //   print("-----------------------------${points}");
  //
  //
  //   return points;
  // }





  List<FlSpot> getPfPoints(
      List<PfInputModel> pfInputs,
      int selectedPhaseIndex,
      List<(String, String)> phaseRanges,
      ) {
    print('--- getPfPoints called ---');
    print('PF Inputs: $pfInputs');
    print('Selected Phase Index: $selectedPhaseIndex');
    print('Phase Ranges: $phaseRanges');

    if (selectedPhaseIndex < 0 || selectedPhaseIndex >= phaseRanges.length) {
      throw Exception("Invalid selectedPhaseIndex: $selectedPhaseIndex");
    }


    List<FlSpot> points = [];

    for (int i = 0; i < pfInputs.length; i++) {
      PfInputModel pf = pfInputs[i];
      double corpus = pf.totalCorpus;
      double annualContribution = pf.annualContribution;
      double rate = pf.interestRate / 100;

      print('Processing PF Input #$i: corpus=$corpus, annualContribution=$annualContribution, rate=$rate');

      // First grow corpus over previous phases without contribution
      for (int p = 0; p < selectedPhaseIndex; p++) {
        final (String pStartStr, String pEndStr) = phaseRanges[p];
        final int pStart = int.parse(pStartStr);
        final int pEnd = int.parse(pEndStr);
        final int pYears = pEnd - pStart + 1;

        for (int y = 0; y < pYears; y++) {
          corpus *= (1 + rate); // Only compound
        }
      }

      // Now compute values over the selected phase
      final (String startStr, String endStr) = phaseRanges[selectedPhaseIndex];
      final int startYear = int.parse(startStr);
      final int endYear = int.parse(endStr);
      final int years = endYear - startYear + 1;

      print('Starting phase with corpus: ₹${corpus.toStringAsFixed(2)}');

      for (int year = 0; year <= years; year++) {
        if (points.length <= year) {
          points.add(FlSpot(year.toDouble(), corpus));
        } else {
          points[year] = FlSpot(
            year.toDouble(),
            points[year].y + corpus,
          );
        }

        print('Year $year: corpus after interest and contribution: ₹${corpus.toStringAsFixed(2)}, total point y: ₹${points[year].y.toStringAsFixed(2)}');

        // Update corpus for next year: add contribution then apply interest
        corpus = (corpus + annualContribution) * (1 + rate);
      }
    }

    print('Final PF Points: $points');
    return points;
  }




  // List<FlSpot> getPfPoints(List<PfInputModel> pfInputs, int years,       List<(String, String)> phaseRanges,) {
  //   print('Here at PF POINTS ${pfInputs}');
  //   List<FlSpot> points = [];
  //
  //   for (int i = 0; i < pfInputs.length; i++) {
  //     PfInputModel pf = pfInputs[i];
  //     double corpus = pf.totalCorpus;
  //     double annualContribution = pf.annualContribution;
  //     double rate = pf.interestRate / 100;
  //
  //     print('Here at PF POINTS ${corpus} $annualContribution $rate');
  //     for (int year = 0; year <= years; year++) {
  //       if (i == 0) {
  //         // Initialize points list only for first PF
  //         if (points.length <= year) {
  //           points.add(FlSpot(year.toDouble(), corpus));
  //         } else {
  //           points[year] = FlSpot(
  //             year.toDouble(),
  //             points[year].y + corpus,
  //           );
  //         }
  //       } else {
  //         points[year] = FlSpot(
  //           year.toDouble(),
  //           points[year].y + corpus,
  //         );
  //       }
  //
  //       corpus = (corpus + annualContribution) * (1 + rate);
  //     }
  //   }
  //
  //   print('PF POints $points');
  //
  //   return points;
  // }


  List<FlSpot> sumYValuesByX(List<FlSpot> points) {
    final Map<double, double> sumMap = {};

    for (var point in points) {
      sumMap.update(point.x, (value) => value + point.y, ifAbsent: () => point.y);
    }

    // Sort the keys and convert to FlSpot list
    final sortedKeys = sumMap.keys.toList()..sort();
    return sortedKeys.map((x) => FlSpot(x, sumMap[x]!)).toList();
  }


}
