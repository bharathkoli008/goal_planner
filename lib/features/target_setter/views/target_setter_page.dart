import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_planner/core/constants/constants.dart';

import '../../../core/widgets/drop_down_widget.dart';
import '../../../core/widgets/textfield.dart';
import '../controller/target_controller.dart';

class TargetSetterPage extends ConsumerStatefulWidget {
  const TargetSetterPage({super.key});

  @override
  ConsumerState<TargetSetterPage> createState() => _TargetSetterPageState();
}

class _TargetSetterPageState extends ConsumerState<TargetSetterPage> {
  late final TextEditingController goalController;
  late final TextEditingController amountController;
  late final TextEditingController inflationController;
  late final List<(TextEditingController, TextEditingController)>
      phaseControllers;
  late final List<TextEditingController> phaseInflationControllers;
  late String previousInflationRate;

  @override
  void initState() {
    super.initState();
    final state = ref.read(targetControllerProvider);

    goalController = TextEditingController(text: state.goalName);
    amountController = TextEditingController(text: state.targetAmount);
    inflationController = TextEditingController(text: state.inflationRate);
    previousInflationRate = state.inflationRate;

    phaseControllers = List.generate(
      3,
      (i) => (
        TextEditingController(
            text: state.phases.length > i ? state.phases[i].$1 : ''),
        TextEditingController(
            text: state.phases.length > i ? state.phases[i].$2 : ''),
      ),
    );

    phaseInflationControllers = List.generate(
      3,
      (i) => TextEditingController(
        text: state.phaseInflations.length > i
            ? state.phaseInflations[i]
            : state.inflationRate,
      ),
    );
  }

  @override
  void dispose() {
    goalController.dispose();
    amountController.dispose();
    inflationController.dispose();
    for (var (a, b) in phaseControllers) {
      a.dispose();
      b.dispose();
    }
    for (var c in phaseInflationControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(targetControllerProvider.notifier);
    final state = ref.watch(targetControllerProvider);

    final goalController = TextEditingController(text: state.goalName);
    final amountController = TextEditingController(text: state.targetAmount);
    final yearController = TextEditingController(text: state.targetYear);
    final inflationController =
        TextEditingController(text: state.inflationRate);

// Update inflation controller if changed from state
    if (inflationController.text != state.inflationRate) {
      inflationController.text = state.inflationRate;
    }

// Update phase inflation controllers if needed
    if (state.inflationRate != previousInflationRate) {
      for (int i = 0; i < phaseInflationControllers.length; i++) {
        if (phaseInflationControllers[i].text == previousInflationRate ||
            phaseInflationControllers[i].text.isEmpty) {
          phaseInflationControllers[i].text = state.inflationRate;
        }
      }
      previousInflationRate = state.inflationRate;
    }

    final phaseControllers = List.generate(
      3,
      (i) => (
        TextEditingController(
            text: state.phases.length > i ? state.phases[i].$1 : ''),
        TextEditingController(
            text: state.phases.length > i ? state.phases[i].$2 : ''),
      ),
    );

    return Scaffold(
      backgroundColor: appColor,
      appBar: AppBar(title:  Text('Set Your Target',style: appFont(16, Colors.white),),backgroundColor: appColor,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            CustomFocusTextField(
              controller: goalController,
              key: const Key('goalName'),
              label: "Goal Name",
              onChanged: (val) => controller.setGoalName(val),

            ),

            const SizedBox(height: 16),
            CustomFocusTextField(
              key: const Key('targetAmount'),
              controller: amountController,
              keyboardType: TextInputType.number,
              label: "Target Amount (e.g., ₹1 Crore)",
              onChanged: controller.setAmount,
            ),

            const SizedBox(height: 16),

            CustomFocusDropdown<String>(
              key: const Key('targetYear'),
              label: 'Target Year',
              value: state.targetYear,
              items: _yearDropdownItems(),
              onChanged: (val) {
                if (val != null) {
                  controller.setTargetYears(val);
                }
              },
            ),

            const SizedBox(height: 16),
            CustomFocusTextField(
              key: const Key('inflationRate'),
              controller: inflationController,
              keyboardType: TextInputType.number,
              label: 'Inflation Rate (%)',
              onChanged: controller.setInflationRate,
            ),
            const SizedBox(height: 20),
             Text('Phases',
                style: appFont(14, appGrey50,weight: FontWeight.bold)),
            const SizedBox(height: 16),
            for (int i = 0; i < 3; i++) ...[
              Row(
                children: [
                  Expanded(
                    child: CustomFocusDropdown<String>(
                      value:
                          _getValidDropdownValue(phaseControllers[i].$1.text),
                      label: 'Phase ${i + 1} From',
                      items: _yearDropdownItems(),
                      onChanged: (val) {
                        if (val != null) {
                          controller.setPhase(
                              i, val, phaseControllers[i].$2.text);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomFocusDropdown<String>(
                      value:
                          _getValidDropdownValue(phaseControllers[i].$2.text),
                      label: 'Phase ${i + 1} To',
                      items: _yearDropdownItems(),
                      onChanged: (val) {
                        if (val != null) {
                          controller.setPhase(
                              i, phaseControllers[i].$1.text, val);
                        }
                      },
                    ),
                  ),

                  SizedBox(
                    width: 10,
                  ),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: CustomFocusTextField(
                      keyboardType: TextInputType.number,

                      label: 'Inflation(%)',
                      controller: phaseInflationControllers[i],
                      onChanged: (val) => controller.setPhaseInflation(i, val),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              const SizedBox(height: 16),
            ],
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(appPurple),

                ),
                onPressed: () {
                  final phases = [];
                  for (int i = 0; i < 3; i++){

                    phases.add((phaseControllers[i].$1.text,phaseControllers[i].$2.text));
                  }

                  print(phases);

                  context.push('/investments', extra: phases);
                },
                child:  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Next',style: appFont(16, Colors.white),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _yearList({int start = 2024, int end = 2050}) {
    return List.generate(end - start + 1, (i) => (start + i).toString());
  }

  List<DropdownMenuItem<String>> _yearDropdownItems(
      {int start = 2024, int end = 2050}) {
    return _yearList(start: start, end: end).map((year) {
      return DropdownMenuItem(value: year, child: Text(year));
    }).toList();
  }

  String? _getValidDropdownValue(String? value) {
    final years = _yearList();
    if (value == null || value.isEmpty || !years.contains(value)) return null;
    return value;
  }
}
