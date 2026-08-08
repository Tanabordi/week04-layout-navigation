import 'package:flutter_test/flutter_test.dart';
import 'package:travel_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TravelApp());

    // Verify that the app builds successfully.
    expect(find.byType(TravelApp), findsOneWidget);
  });
}
