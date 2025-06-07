import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_planner/core/constants/constants.dart';
import 'package:goal_planner/core/widgets/appBar.dart';
import 'package:goal_planner/core/widgets/row_text.dart';
import 'package:goal_planner/core/widgets/textfield.dart';
import '../controllers/pf_notifier.dart';
import '../models/pf_model.dart'; // Import your model here

class PfInputPage extends ConsumerWidget {
  const PfInputPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pfData = ref.watch(pfInputProvider);
    final pfController = ref.read(pfInputProvider.notifier);

    final corpus = TextEditingController(text: pfData.totalCorpus.toString());
    final annual = TextEditingController(text: pfData.annualContribution.toString());
    final interest = TextEditingController(text: pfData.interestRate.toString());

    return Scaffold(
      backgroundColor: appColor,
      appBar: customAppBar('Provident Fund Details'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomFocusTextField(
              key: const Key('corpus'),
              keyboardType: TextInputType.number,
                label: "Total Corpus",
              onSubmitted: (value) =>
                  pfController.updateCorpus(double.tryParse(value) ?? 0), controller: corpus,
            ),
            const SizedBox(height: 16),
            CustomFocusTextField(
              key: const Key('annual'),
              keyboardType: TextInputType.number,
             controller: annual,
                label: "Annual Contribution",
              onSubmitted: (value) =>
                  pfController.updateContribution(double.tryParse(value) ?? 0),
            ),
            const SizedBox(height: 16),
            CustomFocusTextField(
              keyboardType: TextInputType.number,
                controller: interest,
                label: "Interest Rate (%)",

              onChanged: (value) =>
                  pfController.updateInterestRate(double.tryParse(value) ?? 0),
            ),
            const SizedBox(height: 32),
            rowText('Corpus',pfData.totalCorpus.toStringAsFixed(2)),
            rowText('Contribution',pfData.annualContribution.toStringAsFixed(2)),
            rowText('Interest',pfData.interestRate.toStringAsFixed(2)),


            const Spacer(),
            ElevatedButton(
              key: const Key('Submit'),
              onPressed: () {
                final model = PfInputModel(
                  totalCorpus: pfData.totalCorpus,
                  annualContribution: pfData.annualContribution,
                  interestRate: pfData.interestRate,
                );
                Navigator.pop(context, model); // 🔁 Return to previous screen
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
