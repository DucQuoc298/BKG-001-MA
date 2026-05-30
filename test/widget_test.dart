import 'package:bkg_001_ma/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Home screen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MyApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('LUVISTA'), findsOneWidget);
    expect(find.text('Trang chủ'), findsWidgets);
    expect(find.text('Chào mừng trở lại! 👋'), findsOneWidget);
    expect(find.text('Danh mục'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
