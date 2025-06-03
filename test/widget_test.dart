import 'package:flutter_test/flutter_test.dart';
import 'package:goal_planner/features/target_setter/controller/target_controller.dart';
import 'package:riverpod/riverpod.dart';


void main() {
  late ProviderContainer container;
  late TargetController controller;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
    controller = container.read(targetControllerProvider.notifier);
  });

  test('initial state is correct', () {
    final state = container.read(targetControllerProvider);
    expect(state.goalName, '');
    expect(state.targetAmount, '');
    expect(state.targetYear, '2024');
    expect(state.inflationRate, '');
    expect(state.phases, []);
    expect(state.phaseInflations, ['', '', '']);
  });

  test('setGoalName updates goalName', () {
    controller.setGoalName('Buy a House');
    final state = container.read(targetControllerProvider);
    expect(state.goalName, 'Buy a House');
  });

  test('setAmount updates targetAmount', () {
    controller.setAmount('1000000');
    final state = container.read(targetControllerProvider);
    expect(state.targetAmount, '1000000');
  });

  test('setInflationRate updates inflationRate', () {
    controller.setInflationRate('5');
    final state = container.read(targetControllerProvider);
    expect(state.inflationRate, '5');
  });

  test('setTargetYears updates targetYear and auto-generates phases', () {
    controller.setInflationRate('5');
    controller.setTargetYears('2026');
    final state = container.read(targetControllerProvider);

    expect(state.targetYear, '2026');
    expect(state.phases.length, 3);
    expect(state.phaseInflations.length, 3);
    expect(state.phaseInflations, ['5', '5', '5']);
  });

  test('setPhaseInflation updates specific phase inflation', () {
    controller.setPhaseInflation(0, '4.0');
    controller.setPhaseInflation(2, '6.0');
    final state = container.read(targetControllerProvider);

    expect(state.phaseInflations.length, 3);
    expect(state.phaseInflations[0], '4.0');
    expect(state.phaseInflations[1], '');
    expect(state.phaseInflations[2], '6.0');
  });

  test('autoGeneratePhases works as expected', () {
    controller.setInflationRate('4.5');
    controller.setAmount('500000');
    controller.setGoalName('Education');
    controller.setTargetYears('2030'); // this auto-generates phases
    final state = container.read(targetControllerProvider);

    expect(state.phases.length, 3);
    expect(state.phaseInflations, ['4.5', '4.5', '4.5']);
  });
}
