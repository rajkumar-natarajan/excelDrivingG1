import 'package:flutter_test/flutter_test.dart';
import 'package:excel_driving_g1/main.dart';

void main() {
  testWidgets('App builds and shows navigation bar', (WidgetTester tester) async {
    await tester.pumpWidget(const ExcelDrivingG1App());
    await tester.pumpAndSettle();

    // App builds without errors
    expect(find.byType(ExcelDrivingG1App), findsOneWidget);
  });
}
