// PinyaCure smoke test: app builds and shows main navigation.

import 'package:flutter_test/flutter_test.dart';
import 'package:pinyacure/main.dart';

void main() {
  testWidgets('PinyaCure app loads and shows home', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('TAHANAN'), findsOneWidget);
  });
}
