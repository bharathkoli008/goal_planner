import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_planner/core/constants/constants.dart';
import 'package:goal_planner/core/widgets/appBar.dart';
import 'package:goal_planner/core/widgets/textfield.dart';
import '../controllers/other_investment_notifier.dart';

class OtherInvestmentPage extends ConsumerWidget {
  const OtherInvestmentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final investment = ref.watch(otherInvestmentProvider);
    final controller = ref.read(otherInvestmentProvider.notifier);

    final corpus = TextEditingController(text: investment.corpus.toString());
    final annual =
        TextEditingController(text: investment.annualReturnRate.toString());
    final type =
        TextEditingController(text: investment.investmentType.toString());

    return Scaffold(
      backgroundColor: appColor,
      appBar: customAppBar('Other Investment'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomFocusTextField(
              label: "Investment Type",
              controller: type,
              onSubmitted: controller.updateType,
            ),
            const SizedBox(height: 16),
            CustomFocusTextField(
              keyboardType: TextInputType.number,
              controller: corpus,
              label: "Corpus (₹)",
              onSubmitted: (val) =>
                  controller.updateCorpus(double.tryParse(val) ?? 0),
            ),
            const SizedBox(height: 16),
            CustomFocusTextField(
              keyboardType: TextInputType.number,
              controller: annual,
              label: "Expected Annual Return (%)",
              onSubmitted: (val) =>
                  controller.updateReturnRate(double.tryParse(val) ?? 0),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, investment);
              },
              child:  Text("Submit",style: appFont(16, Colors.white)),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(appPurple),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
