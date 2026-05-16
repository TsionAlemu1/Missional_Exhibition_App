import 'package:flutter_test/flutter_test.dart';
import 'package:mission_exhibition_5k/main.dart';

void main() {
  testWidgets('App should display splash screen on launch',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MissionExhibitionApp());
    expect(find.text('Mission Exhibition 5K'), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
  });
}
