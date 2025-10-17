import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:fuel_tracker_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  testWidgets('Renders home screen with no vehicles',
      (WidgetTester tester) async {
    final firestore = FakeFirebaseFirestore();

    await tester.pumpWidget(
      Provider<FirebaseFirestore>(
        create: (_) => firestore,
        child: MaterialApp(
          home: HomeScreen(
            title: 'Fuel Tracker',
          ),
        ),
      ),
    );

    // Let the snapshots stream fire a snapshot.
    await tester.idle();
    // Re-render.
    await tester.pump();

    // Verify that the app shows the "No vehicles" text.
    expect(find.text('No vehicles yet. Add one to get started!'),
        findsOneWidget);
  });
}