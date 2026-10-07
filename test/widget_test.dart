import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itenas_counter/main.dart';

void main() {
  Future<void> startApp(
    WidgetTester tester, {
    Size size = const Size(390, 844),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const CounterApp());
    await tester.pumpAndSettle();
  }

  void expectCounter(WidgetTester tester, int value, Color color) {
    expect(find.text('$value'), findsOneWidget);
    expect(find.text(value.isEven ? 'GENAP' : 'GANJIL'), findsOneWidget);
    final background = tester.widget<AnimatedContainer>(
      find.byKey(const ValueKey('counter_background')),
    );
    expect((background.decoration! as BoxDecoration).color, color);
  }

  Future<void> press(WidgetTester tester, String key) async {
    final button = find.byKey(ValueKey(key));
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
  }

  testWidgets('Awal nol dan genap; tambah mengubah nilai serta warna', (
    tester,
  ) async {
    await startApp(tester);
    expectCounter(tester, 0, ItenasColors.blue);
    await press(tester, 'increment_button');
    expectCounter(tester, 1, ItenasColors.orange);
    await press(tester, 'increment_button');
    expectCounter(tester, 2, ItenasColors.blue);
  });

  testWidgets('Kurang bekerja melewati nol dan pada bilangan negatif', (
    tester,
  ) async {
    await startApp(tester);
    await press(tester, 'decrement_button');
    expectCounter(tester, -1, ItenasColors.orange);
    await press(tester, 'decrement_button');
    expectCounter(tester, -2, ItenasColors.blue);
    await press(tester, 'increment_button');
    expectCounter(tester, -1, ItenasColors.orange);
  });

  testWidgets('Reset mengembalikan nilai positif dan negatif ke nol biru', (
    tester,
  ) async {
    await startApp(tester);
    await press(tester, 'increment_button');
    await press(tester, 'reset_button');
    expectCounter(tester, 0, ItenasColors.blue);
    await press(tester, 'decrement_button');
    await press(tester, 'reset_button');
    expectCounter(tester, 0, ItenasColors.blue);
    await press(tester, 'reset_button');
    expectCounter(tester, 0, ItenasColors.blue);
  });

  testWidgets('Ketukan cepat tidak kehilangan perubahan state', (tester) async {
    await startApp(tester);
    for (var i = 0; i < 25; i++) {
      await tester.tap(find.byKey(const ValueKey('increment_button')));
      await tester.pump(const Duration(milliseconds: 16));
    }
    await tester.pumpAndSettle();
    expectCounter(tester, 25, ItenasColors.orange);
  });

  for (final size in [
    const Size(320, 568),
    const Size(844, 390),
    const Size(1440, 900),
  ]) {
    testWidgets('Tata letak ${size.width} × ${size.height} tanpa overflow', (
      tester,
    ) async {
      await startApp(tester, size: size);
      await press(tester, 'increment_button');
      expectCounter(tester, 1, ItenasColors.orange);
      await press(tester, 'reset_button');
      expectCounter(tester, 0, ItenasColors.blue);
    });
  }

  testWidgets('Ukuran teks besar tetap dapat digunakan', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.5)),
          child: child!,
        ),
        home: const CounterScreen(),
      ),
    );
    await tester.pumpAndSettle();
    await press(tester, 'increment_button');
    expectCounter(tester, 1, ItenasColors.orange);
  });
}
