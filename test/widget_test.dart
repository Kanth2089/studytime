import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studytime/main.dart';

void main() {
  testWidgets('App load smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const StudyTimetableApp());

    // Verify that the login page / title is displayed.
    expect(find.byIcon(Icons.menu_book_rounded), findsOneWidget);
  });
}
