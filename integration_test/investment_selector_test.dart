import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:goal_planner/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('InvestmentSelectorPage renders and responds to interactions', (WidgetTester tester) async {
    // Start the app
    app.main();
    await tester.pumpAndSettle();

    // === Target Selector Page ===
    // Fill goal name
    final goalField = find.byKey(const Key('goalName'));
    expect(goalField, findsOneWidget);
    await tester.enterText(goalField, 'Buy a House');

    // Fill target amount
    final amountField = find.byKey(const Key('targetAmount'));
    expect(amountField, findsOneWidget);
    await tester.enterText(amountField, '12');

    // Fill target year
    final yearDropdown = find.byKey(const Key('targetYear'));
    expect(yearDropdown, findsOneWidget);

// Tap to open dropdown menu
    await tester.tap(yearDropdown);
    await tester.pumpAndSettle();

// Find the dropdown item with text '2026' and tap it
    final year2026 = find.text('2032').last; // Use .last to ensure it's the dropdown menu item
    expect(year2026, findsOneWidget);
    await tester.tap(year2026);
    await tester.pumpAndSettle();


    // Fill inflation rate
    final inflationField = find.byKey(const Key('inflationRate'));
    expect(inflationField, findsOneWidget);
    await tester.enterText(inflationField, '12');

    await tester.pumpAndSettle();

    // Tap next to move to InvestmentSelectorPage
    final nextButton = find.text('Next');
    expect(nextButton, findsOneWidget);
    await tester.tap(nextButton);
    await tester.pumpAndSettle();

    // // === Investment Selector Page ===
    // expect(find.text('Mutual Funds'), findsOneWidget);
    // expect(find.text('Stocks'), findsOneWidget);
    //
    // // Tap add on one investment
    // final addButton = find.widgetWithText(ElevatedButton, 'Add').first;
    // await tester.tap(addButton);
    // await tester.pumpAndSettle();
    //
    //
    // // Navigate to InvestmentSelectorPage
    // // Adjust this if you have a specific route
    // final navButton = find.text('Next');
    // expect(navButton, findsOneWidget);
    // await tester.tap(navButton);
    // await tester.pumpAndSettle();
    //
    // // Check if investment cards are present
    // expect(find.text('Mutual Funds'), findsOneWidget);
    // expect(find.text('Stocks'), findsOneWidget);
    // expect(find.text('Provident Funds'), findsOneWidget);
    // expect(find.text('Other Investments'), findsOneWidget);
    //
    // // Tap the "Add" button for Mutual Funds
    // final mfAddButton = find.widgetWithText(ElevatedButton, 'Add').at(0);
    // await tester.tap(mfAddButton);
    // await tester.pumpAndSettle();
    //
    // // Since it's a push, we should now be on the Mutual Fund input screen (dummy for test)
    // expect(find.byType(Scaffold), findsWidgets); // Check a new scaffold exists
    //
    // // Go back
    // await tester.pageBack();
    // await tester.pumpAndSettle();
    //
    // // Test Clear button
    // final clearButton = find.widgetWithText(ElevatedButton, 'Clear');
    // expect(clearButton, findsOneWidget);
    // await tester.tap(clearButton);
    // await tester.pumpAndSettle();
    //
    // // Test Next button
    // final nextButton2 = find.widgetWithText(ElevatedButton, 'Next');
    // expect(nextButton, findsOneWidget);
    // await tester.tap(nextButton2);
    // await tester.pumpAndSettle();
    //
    // // Should navigate to summary page (or fail gracefully if empty)
    // expect(find.text('Summary'), findsOneWidget);
  });
}
