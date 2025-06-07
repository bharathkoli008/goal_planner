import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_planner/core/constants/constants.dart';
import 'package:goal_planner/features/stocks/models/stock_model.dart';

import '../../mutual_funds/models/mutual_fund_model.dart';
import '../../other_investments/models/other_investment_model.dart';
import '../../pf/models/pf_model.dart';
import '../controllers/investment_selector_controller.dart';
import '../models/investment_option.dart';

class InvestmentSelectorPage extends ConsumerWidget {
  final phases;
  const InvestmentSelectorPage({super.key,required this.phases});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final investmentData = ref.watch(investmentProvider);

    final investments = {
      InvestmentType.mutualFund: 'Mutual Funds',
      InvestmentType.stocks: 'Stocks',
      InvestmentType.providentFund: 'Provident Funds',
      InvestmentType.other: 'Other Investments',
    };
    final images = {
      InvestmentType.mutualFund:'money.png',
      InvestmentType.stocks:'stock-market.png',
      InvestmentType.providentFund: 'emergency-fund.png',
      InvestmentType.other:'funding.png'
    };

    final routes = {
      InvestmentType.mutualFund:'/mutual-fund',
      InvestmentType.stocks:'/stocks',
      InvestmentType.providentFund: '/pf',
      InvestmentType.other:'/other-investments'
    };


    navigate(InvestmentType type) async {

      switch(type) {
        case InvestmentType.mutualFund:
          final updatedInvestments =  await context.push<List<SelectedMf>>('${routes[type]}', extra: phases);
          for (final investment in updatedInvestments ?? []) {
            ref.read(investmentProvider.notifier).addInvestment(InvestmentType.mutualFund, investment);
          }
          break;

        case InvestmentType.stocks:
          final updatedInvestments =  await context.push<List<StockInvestment>>('${routes[type]}', extra: phases);
          for (final investment in updatedInvestments ?? []) {
            ref.read(investmentProvider.notifier).addInvestment(InvestmentType.stocks, investment);
          }
          break;

        case InvestmentType.providentFund:
          final updatedInvestments =  await context.push<PfInputModel>('${routes[type]}', extra: phases);
          ref.read(investmentProvider.notifier).addInvestment(InvestmentType.providentFund, updatedInvestments);
          break;

        case InvestmentType.other:
          final updatedInvestments = await context.push<OtherInvestment>(
            '${routes[type]}',
            extra: phases,
          );
          ref.read(investmentProvider.notifier).addInvestment(
            InvestmentType.other,
            updatedInvestments,
          );
          break;
      }


    }

    return Scaffold(
      backgroundColor: appColor,
      appBar: AppBar(title:  Text('Select Investments',style: appFont(16, Colors.white),),backgroundColor: appColor,
      iconTheme: IconThemeData(color: Colors.white
      ),),

      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              padding: const EdgeInsets.all(16),
              children: investments.entries.map((entry) {
                final type = entry.key;
                final title = entry.value;
                final count = ref.watch(investmentProvider.notifier).countOf(type);
                final imageAsset = 'assets/${images[entry.key]}';

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: (count > 0) ? Colors.white.withOpacity(0.1) :  Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.white.withOpacity(0.15)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    imageAsset,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                title,
                                style: appFont(12, Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                key: Key(routes[entry.key]!),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: (count > 0) ? appPurple.withOpacity(0.8) : appPurple,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () async {
                                  navigate(type);
                                },
                                child:  Text('Add',style: appFont(14, Colors.white,weight: FontWeight.bold),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (count > 0)
                      Positioned(
                        top: -8,
                        right: -8,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: appPurple,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: Text(
                            '$count',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                )
                ;
              }).toList(),),
          ),

          const SizedBox(height: 32),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(appGrey),

                  ),
                  onPressed: () {

                    ref.read(investmentProvider.notifier).clear();
                  },
                  child:  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Clear',style: appFont(16, appDarkGrey),),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(appPurple),

                  ),
                  onPressed: () {

                    context.push('/summary',extra: investmentData);
                  },
                  child:  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Next',style: appFont(16, Colors.white),),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ));
  }
}


