// import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_6moonz3/main.dart';  // main.dart faylingizni import qilish

void main() {
  testWidgets('TodosScreen test', (WidgetTester tester) async {
    // Ilovani ishga tushirish
    await tester.pumpWidget(const MainApp());

    // Todos ekranidagi matnni tekshirish
    expect(find.text('Bu Todos Ekrani'), findsOneWidget);

    // AppBar sarlavhasini tekshirish
    expect(find.text('Todos'), findsOneWidget);
  });
}
