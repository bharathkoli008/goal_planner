import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_planner/features/mutual_funds/views/mutual_fund_view.dart';
import 'package:goal_planner/features/target_setter/views/target_setter_page.dart';
import 'package:goal_planner/features/investment_selector/views/investment_selector_page.dart';

import '../features/investment_selector/controllers/investment_selector_controller.dart';
import '../features/other_investments/views/other_investment_view.dart';
import '../features/pf/views/pf_view.dart';
import '../features/projection/views/summary_projection_page.dart';
import '../features/stocks/models/stock_model.dart';
import '../features/stocks/views/stock_view.dart';

class AppRoutes {
  static final router = GoRouter(
    initialLocation: '/target',
    routes: [
      GoRoute(path: '/target', builder: (_, __) => const TargetSetterPage()),
      GoRoute(
        path: '/investments',
        builder: (context, state) {
          final phases = state.extra ;
          return InvestmentSelectorPage(phases: phases);
        },
      ),

      GoRoute(path: '/mutual-fund', builder: (_, __) =>  MutualFundPage()),

      // GoRoute(
      //   path: '/mutual-fund',
      //   builder: (context, state) {
      //     final extra = state.extra;
      //
      //     // Check if extra is null or not the expected type
      //     if (extra == null || extra is! List<(String, String)?>) {
      //       return const Scaffold(
      //         body: Center(child: Text('No phases provided')),
      //       );
      //     }
      //
      //     // Cast safely to List<(String, String)?>
      //     final phasesNullable = extra as List<(String, String)?>;
      //
      //     // Remove any null elements (if applicable)
      //     final phases = phasesNullable.whereType<(String, String)>().toList();
      //
      //     if (phases.isEmpty) {
      //       return const Scaffold(
      //         body: Center(child: Text('No valid phases provided')),
      //       );
      //     }
      //
      //     // Pass the non-nullable list to your page
      //     return MutualFundPage(phases: phases);
      //   },
      // ),




      GoRoute(
        path: '/summary',
        builder: (context, state) {
          final InvestmentData targetData = state.extra  as InvestmentData;
          return SummaryProjectionPage(targetData);
        },
      ),

      GoRoute(path: '/stocks', builder: (_, __) =>  IndustrySearchPage()),

      GoRoute(path: '/pf', builder: (_, __) => const PfInputPage()),
      GoRoute(path: '/other-investments', builder: (_, __) => const OtherInvestmentPage()),

    ],
  );
}
