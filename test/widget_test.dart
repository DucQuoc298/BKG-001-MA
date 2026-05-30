import 'package:bkg_001_ma/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bkg_001_ma/main.dart';

void main() {
  testWidgets('Login screen renders expected fields and actions', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('LUVISTA'), findsOneWidget);
    expect(find.text('Tên đăng nhập / Email'), findsOneWidget);
    expect(find.text('Mật khẩu'), findsOneWidget);
    expect(find.text('Nhớ mật khẩu'), findsOneWidget);
    expect(find.text('Quên mật khẩu?'), findsOneWidget);
    expect(find.text('Đăng nhập'), findsOneWidget);
    expect(find.text('Đăng ký'), findsOneWidget);

    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.byType(Checkbox), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
