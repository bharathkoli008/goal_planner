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
    await tester.ensureVisible(inflationField);
    await tester.pumpAndSettle();

    await tester.tap(inflationField);
    await tester.enterText(inflationField, '12');
    await tester.pumpAndSettle();


    // Tap next to move to InvestmentSelectorPage
    final nextButton = find.text('Next');
    expect(nextButton, findsOneWidget);
    await tester.ensureVisible(nextButton);
    await tester.pumpAndSettle();
    await tester.tap(nextButton);
    await tester.pumpAndSettle();


    // === Investment Selector Page ===
    final investButton = find.byKey(const Key('/mutual-fund'));
    await tester.tap(investButton);
    await tester.pumpAndSettle();

    // Fill target amount
    final mfName = find.byKey(const Key('mf'));
    expect(mfName, findsOneWidget);
    await tester.enterText(mfName, 'kotak');
    await tester.pumpAndSettle();
    // expect(find.text('Stocks'), findsOneWidget);

    final resultTile = find.byType(ListTile).first;
    expect(resultTile, findsOneWidget);
    await tester.tap(resultTile);
    await tester.pumpAndSettle(); // wait for bottom sheet

    final quantityField = find.widgetWithText(TextField, 'Units');
    expect(quantityField, findsOneWidget);
    await tester.enterText(quantityField, '7000');
    await tester.pumpAndSettle();

    final sipFields = find.widgetWithText(TextField, 'SIP (₹)');
    expect(sipFields, findsNWidgets(3));

    await tester.enterText(sipFields.at(0), '2000');
    await tester.enterText(sipFields.at(1), '5000');
    await tester.enterText(sipFields.at(2), '5000');
    await tester.pumpAndSettle();

    // Tap the Save button
    final saveButton = find.widgetWithText(ElevatedButton, 'Save');
    expect(saveButton, findsOneWidget);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();


    final submitMfs = find.text('Submit Selected Stocks');
    expect(submitMfs, findsOneWidget);

    await tester.tap(submitMfs);
    await tester.pumpAndSettle();






    final stockButton = find.byKey(const Key('/stocks'));
    await tester.tap(stockButton);
    await tester.pumpAndSettle();

    // Fill target amount
    final stockName = find.byKey(const Key('stock'));
    expect(stockName, findsOneWidget);
    await tester.enterText(stockName, 'eternal');
    await tester.pumpAndSettle();
    // expect(find.text('Stocks'), findsOneWidget);

    final stockTile = find.byType(ListTile).first;
    expect(stockTile, findsOneWidget);
    await tester.tap(stockTile);
    await tester.pumpAndSettle(); // wait for bottom sheet

    final stockquantityField = find.widgetWithText(TextField, 'Quantity');
    expect(stockquantityField, findsOneWidget);
    await tester.enterText(stockquantityField, '7000');
    await tester.pumpAndSettle();

    final increaseFields = find.widgetWithText(TextField, 'Increase (%)');
    expect(increaseFields, findsNWidgets(3));

    await tester.enterText(increaseFields.at(0), '16');
    await tester.enterText(increaseFields.at(1), '25');
    await tester.enterText(increaseFields.at(2), '35');
    await tester.pumpAndSettle();

    // Tap the Save button
    final stockSaveButton = find.widgetWithText(ElevatedButton, 'Save');
    expect(stockSaveButton, findsOneWidget);
    await tester.tap(stockSaveButton);
    await tester.pumpAndSettle();

    final submitStocks = find.text('Submit Selected Stocks');
    expect(submitStocks, findsOneWidget);

    await tester.tap(submitStocks);
    await tester.pumpAndSettle();


    final pfButton = find.byKey(const Key('/pf'));
    await tester.tap(pfButton);
    await tester.pumpAndSettle();


    final corpusField = find.byKey(const Key('corpus'));
    expect(corpusField, findsOneWidget);
    await tester.enterText(corpusField, '1200000');

    final annualField = find.byKey(const Key('annual'));
    expect(annualField, findsOneWidget);
    await tester.enterText(annualField, '650000');



    final submitPfs = find.text('Submit');
    expect(submitPfs, findsOneWidget);

    await tester.tap(submitPfs);
    await tester.pumpAndSettle();


    final summaryButton = find.text('Next');
    expect(summaryButton, findsOneWidget);
    await tester.tap(summaryButton);
    await tester.pumpAndSettle();







    await tester.pump(const Duration(seconds: 5));


    // final export = find.text('Export');
    // expect(export, findsOneWidget);
    //
    // await tester.tap(export);
    // await tester.pumpAndSettle();


    final phase2Tab = find.text('Phase 2');
    expect(phase2Tab, findsOneWidget);
    await tester.tap(phase2Tab);
    await tester.pumpAndSettle(); // Wait for animation


    final phase3Tab = find.text('Phase 3');
    expect(phase3Tab, findsOneWidget);
    await tester.tap(phase3Tab);
    await tester.pumpAndSettle(); // Wait for animation




    await tester.pump(const Duration(seconds: 5));

    final scrollable = find.byType(Scrollable).first; // or a specific scrollable
    await tester.drag(scrollable, const Offset(0, -1000)); // scroll up (negative y)
    await tester.pumpAndSettle();



    await tester.pump(const Duration(seconds: 5));


  });
}
