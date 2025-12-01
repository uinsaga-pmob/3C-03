import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rentify_demo/main.dart';
import 'package:rentify_demo/services/app_state.dart';

void main() {
  testWidgets('Rentify loads without crashing', (WidgetTester tester) async {

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const MyApp(),
      ),
    );

    // Minimal validation
    expect(find.byType(MyApp), findsOneWidget);
  });
}
