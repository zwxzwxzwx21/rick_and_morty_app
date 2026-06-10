import 'package:flutter_test/flutter_test.dart';

import 'package:projekt_zaliczeniowy/main.dart';

void main() {
  testWidgets('shows project title', (WidgetTester tester) async {
    await tester.pumpWidget(const ProjektZaliczeniowyApp());

    expect(find.text('Projekt Zaliczeniowy'), findsOneWidget);
    expect(find.text('Projekt zaliczeniowy dziala'), findsOneWidget);
  });
}
